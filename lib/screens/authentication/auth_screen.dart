import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_text_field.dart';
import '../../theme/app_theme.dart';
import '../../theme/buttons.dart';
import '../../services/auth_service.dart';
import '../dashboard/kpis_screen.dart';
import 'dart:io';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'forgot_password_screens.dart';

// Email Verification Screen
class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

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

  const AuthScreen({super.key, this.isLogin = true});

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
  bool _isTermsAgreed = false;

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
                const SizedBox(height: 32),
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 120.19,
                    height: 40,
                    color: AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(height: 64),
                Center(
                  child: Text(
                    widget.isLogin ? 'Login' : 'Sign Up',
                    style: GoogleFonts.spectral(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      height: 1.54,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    widget.isLogin
                        ? 'Welcome back! Please enter your details'
                        : 'Create an account to get started',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.54,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildRoleSelector(),
                const SizedBox(height: 24),
                if (!widget.isLogin) ...[
                  // For Full Name field
                  _buildTextField(
                    controller: _fullNameController,
                    label: 'Full Name',
                    customHintText: 'Enter name',
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
                  isRequired: true,
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
                  // For Password field
                  _buildTextField(
                    controller: _passwordController,
                    label: 'Password',
                    customHintText: 'Enter password',
                    isRequired: true,
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
                    customHintText: 'Repeat password',
                    obscureText: true,
                    validator: (value) => value != _passwordController.text
                        ? 'Passwords do not match'
                        : null,
                  ),
                if (!widget.isLogin) ...[
                  const SizedBox(height: 16),
                  _buildTermsAndConditionsCheckbox(),
                ],
                const SizedBox(height: 24),
                _buildSubmitButton(),
                const SizedBox(height: 8),
                _buildToggleAuthModeButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Center(
      child: Container(
        width: 290,
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(249, 249, 249, 1),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 111,
              child: AppButton(
                text: 'Driver',
                size: ButtonSize.medium,
                variant: _selectedRole == UserRole.driver
                    ? ButtonVariant.roleActive
                    : ButtonVariant.roleInactive,
                onPressed: () =>
                    setState(() => _selectedRole = UserRole.driver),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 111,
              child: AppButton(
                text: 'Manager',
                size: ButtonSize.medium,
                variant: _selectedRole == UserRole.manager
                    ? ButtonVariant.roleActive
                    : ButtonVariant.roleInactive,
                onPressed: () =>
                    setState(() => _selectedRole = UserRole.manager),
              ),
            ),
          ],
        ),
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
    String? customHintText,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool? isRequired = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppTextField(
        label: label,
        hintText: customHintText ?? 'Enter ${label.toLowerCase()}',
        isRequired: isRequired ?? false,
        keyboardType: keyboardType ?? TextInputType.text,
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        showPasswordToggle: obscureText,
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
          isRequired: true,
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
                    height: 20, // Adjusted height
                    width: 20, // Adjusted width
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _rememberMe = !_rememberMe;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: _rememberMe
                              ? const Color.fromRGBO(
                                  52, 84, 207, 1) // Fill color when checked
                              : Colors
                                  .transparent, // Transparent when unchecked
                          border: Border.all(
                            color: const Color.fromRGBO(
                                193, 199, 201, 1), // Border color
                            width: 1,
                          ),
                        ),
                        child: _rememberMe
                            ? Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Remember Me',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.54,
                      color: const Color.fromRGBO(102, 112, 133, 1),
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
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.54,
                    color: AppTheme.primaryBlue,
                    decoration: TextDecoration.underline,
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

  Widget _buildTermsAndConditionsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
          width: 20,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isTermsAgreed = !_isTermsAgreed;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: _isTermsAgreed
                    ? const Color.fromRGBO(52, 84, 207, 1)
                    : Colors.transparent,
                border: Border.all(
                  color: const Color.fromRGBO(193, 199, 201, 1),
                  width: 1,
                ),
              ),
              child: _isTermsAgreed
                  ? Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.54,
                color: const Color.fromRGBO(102, 112, 133, 1),
              ),
              children: [
                const TextSpan(text: 'By signing up, you agree to our '),
                TextSpan(
                  text: 'Terms of Use',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.54,
                    color: const Color.fromRGBO(28, 74, 151, 1),
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Handle navigation to Terms of Use
                      // _openTermsOfUse(context);
                    },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleAuthModeButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          widget.isLogin
              ? "Don't have an account?"
              : 'Already have an account?',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.54,
            color: const Color.fromRGBO(102, 112, 133, 1),
          ),
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
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.54,
              color: AppTheme.primaryBlue,
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
        final userCredential = await _authService.signInWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        await _saveLoginState(userCredential);

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
