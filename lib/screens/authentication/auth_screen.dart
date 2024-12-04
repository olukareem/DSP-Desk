import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_text_field.dart';
import '../../theme/app_theme.dart';
import '../../theme/buttons.dart';
import '../../services/auth_service.dart';
import '../dashboard/kpis_screen.dart';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'forgot_password_screens.dart';

// Email Verification Screen
class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.mark_email_unread_outlined,
                size: 64,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Verify your email',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                'We\'ve sent you an email verification link. Please check your inbox and verify your email address.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              AppButton(
                text: 'I\'ve verified my email',
                onPressed: () async {
                  User? user = FirebaseAuth.instance.currentUser;
                  await user?.reload();
                  if (user?.emailVerified ?? false) {
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KpiScreen(),
                        ),
                      );
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Email not verified yet. Please check your inbox.'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  }
                },
                isFullWidth: true,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () async {
                  try {
                    User? user = FirebaseAuth.instance.currentUser;
                    await user?.sendEmailVerification();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Verification email resent. Please check your inbox.'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Error sending verification email: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: const Text('Resend verification email'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Main Auth Screen
class AuthScreen extends StatefulWidget {
  final bool isLogin;

  const AuthScreen({Key? key, this.isLogin = true}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _countryCodeController = TextEditingController(text: '+1');

  UserRole _selectedRole = UserRole.driver;
  bool _isLoading = false;
  bool _rememberMe = false;

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _countryCodeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('rememberMe') ?? false;
    if (rememberMe && FirebaseAuth.instance.currentUser != null) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const KpiScreen()),
        );
      }
    }
  }

  // Add this method to save login state
  Future<void> _saveLoginState(UserCredential userCredential) async {
    if (_rememberMe) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('rememberMe', true);
      await prefs.setString('userEmail', userCredential.user?.email ?? '');
    }
  }

  Future<bool> _checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Unable to connect to the network. Please check your internet connection.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 120.19,
                    height: 40,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  widget.isLogin ? 'Login' : 'Sign Up',
                  style: TextStyle(
                    fontFamily: 'Spectral',
                    fontSize: 32,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.isLogin
                      ? 'Welcome back! Please enter your details'
                      : 'Create an account to get started',
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                _buildRoleSelector(),
                if (!widget.isLogin) ...[
                  _buildTextField(
                    controller: _fullNameController,
                    label: 'Full Name',
                    isRequired: true,
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter your name'
                        : null,
                  ),
                  _buildPhoneNumberField(),
                ],
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  isRequired: !widget.isLogin,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value!)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                if (widget.isLogin)
                  _buildPasswordSection()
                else
                  _buildTextField(
                    controller: _passwordController,
                    label: 'Password',
                    isRequired: !widget.isLogin,
                    obscureText: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your password';
                      }
                      if (value!.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                if (!widget.isLogin)
                  _buildTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    obscureText: true,
                    validator: (value) => value != _passwordController.text
                        ? 'Passwords do not match'
                        : null,
                  ),
                const SizedBox(height: 24),
                _buildSubmitButton(),
                const SizedBox(height: 16),
                _buildToggleAuthModeButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildRoleButton(
              title: 'Driver',
              isSelected: _selectedRole == UserRole.driver,
              onTap: () => setState(() => _selectedRole = UserRole.driver),
            ),
          ),
          Expanded(
            child: _buildRoleButton(
              title: 'Manager',
              isSelected: _selectedRole == UserRole.manager,
              onTap: () => setState(() => _selectedRole = UserRole.manager),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.primary,
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Country Code Selector
          SizedBox(
            width: 120,
            child: IntlPhoneField(
              decoration: InputDecoration(
                labelText: 'Code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              initialCountryCode: 'US',
              disableLengthCheck: true,
              showDropdownIcon: true,
              onChanged: (phone) {
                _countryCodeController.text = phone.countryCode;
              },
              invalidNumberMessage: null,
              onCountryChanged: (country) {
                _countryCodeController.text = '+${country.dialCode}';
              },
            ),
          ),
          const SizedBox(width: 8),
          // Phone Number Field
          Expanded(
            child: TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your phone number';
                }
                if (!RegExp(r'^\d{10}$').hasMatch(value!)) {
                  return 'Please enter a valid 10-digit phone number';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool? isRequired = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppTextField(
        label: label,
        hintText: 'Enter ${label.toLowerCase()}',
        isRequired: isRequired ?? false,
        keyboardType: keyboardType ?? TextInputType.text,
        controller: controller,
        validator: validator,
      ),
    );
  }

  Widget _buildPasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          controller: _passwordController,
          label: 'Password',
          isRequired: !widget.isLogin,
          obscureText: true,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter your password';
            }
            if (value!.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                      activeColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Remember Me',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Forgot Password?',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return AppButton(
      text: widget.isLogin ? 'Login' : 'Sign Up',
      onPressed: _handleSubmit,
      isLoading: _isLoading,
      isFullWidth: true,
    );
  }

  Widget _buildToggleAuthModeButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.isLogin
              ? "Don't have an account?"
              : 'Already have an account?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AuthScreen(isLogin: !widget.isLogin),
              ),
            );
          },
          child: Text(
            widget.isLogin ? 'Sign Up' : 'Login',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  String getFullPhoneNumber() {
    return '${_countryCodeController.text}${_phoneController.text}';
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!await _checkConnectivity()) return;

    setState(() => _isLoading = true);

    try {
      if (widget.isLogin) {
        // Login flow
        print("Starting login process...");
        await _authService.signInWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: Colors.green,
            ),
          );

          setState(() => _isLoading = false);

          // Navigate after brief delay to show snackbar
          await Future.delayed(const Duration(seconds: 1));
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const KpiScreen()),
            (route) => false,
          );
        }
      } else {
        // Sign up flow
        print("Starting signup process...");
        final userCredential = await _authService.signUpWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          fullName: _fullNameController.text.trim(),
          phoneNumber: getFullPhoneNumber(),
          role: _selectedRole,
        );

        setState(() => _isLoading = false);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sign up successful!'),
              backgroundColor: Colors.green,
            ),
          );

          await Future.delayed(const Duration(seconds: 1));
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const KpiScreen()),
            (route) => false,
          );
        }
      }
    } catch (e) {
      print("Error in handleSubmit: $e");
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_getErrorMessage(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getErrorMessage(String error) {
    print('Raw error: $error');
    if (error.contains('network-request-failed')) {
      return 'Connection failed. Please check your internet connection and try again.';
    } else if (error.contains('wrong-password')) {
      return 'Incorrect password. Please try again.';
    } else if (error.contains('user-not-found')) {
      return 'No user found with this email. Please sign up first.';
    } else if (error.contains('invalid-email')) {
      return 'Invalid email address.';
    } else if (error.contains('email-already-in-use')) {
      return 'This email is already registered. Please login instead.';
    } else if (error.contains('weak-password')) {
      return 'Password is too weak. Please use a stronger password.';
    }
    return 'An error occurred. Please try again.';
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate to KpiScreen after showing loading indicator
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print(
          "LoadingScreen mounted, about to navigate to KpiScreen"); // Debug print
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const KpiScreen(),
        ),
      );
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
