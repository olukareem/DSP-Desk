import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../theme/app_text_field.dart';
import '../../theme/app_theme.dart';
import '../../theme/buttons.dart';
import '../authentication/auth_screen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  static final ScrollController _scrollController = ScrollController();
  static final GlobalKey _featuresKey = GlobalKey();
  static final GlobalKey _contactKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(51, 92, 161, 1),
        elevation: 0,
        leadingWidth:
            92, // Adjusting the leading width to align better with body text padding
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: SizedBox(
            width: 80.0,
            height: 28.0,
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              color: Colors.white,
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
            width: 390,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // DSP Desk Icon Logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 96.15,
                      height: 32,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                        color: const Color.fromRGBO(28, 74, 151, 1),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      iconSize: 24,
                      color: const Color.fromRGBO(33, 36, 41, 1),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Menu Items
                _buildMenuItem(context, "Home"),
                const SizedBox(height: 10),
                _buildMenuItem(context, "Features"),
                const SizedBox(height: 10),
                _buildMenuItem(context, "Contact Us"),
                const SizedBox(height: 10),
                // Login Menu Item
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AuthScreen(isLogin: true),
                      ),
                    );
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF667085),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Sign Up Button
                AppButton(
                  text: 'Sign Up Desk',
                  variant: ButtonVariant.wide,
                  isFullWidth: true,
                  size: ButtonSize.medium,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AuthScreen(isLogin: false),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: Color.fromRGBO(51, 92, 161,
                  1), // Blue background color for the whole section
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    "Simplify Your Delivery Biz Ops",
                    style: GoogleFonts.spectral(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "DSP Desk lets you manage your roster and fleet, report incidents, and track expenses - all in one place.",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      // Handle email input
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'We care about your data in our privacy policy',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'See DSP Desk',
                    variant: ButtonVariant.wide,
                    isFullWidth: true,
                    size: ButtonSize.large,
                    onPressed: () {
                      // Handle see DSP Desk
                    },
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AspectRatio(
                      aspectRatio:
                          1.4, // Horizontal tablet aspect ratio like in the image
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            'assets/gif/landing_gif.gif',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            // Trusted by DSP Section
            Container(
              width: double.infinity,
              color: const Color.fromRGBO(247, 248, 250, 1),
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "TRUSTED BY DSP ACROSS THE COMPANY",
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        color: Color.fromRGBO(102, 112, 133, 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SvgPicture.asset('assets/images/Amwell.svg'),
                        SvgPicture.asset('assets/images/Percy.svg'),
                        SvgPicture.asset('assets/images/Uservoice.svg'),
                        SvgPicture.asset('assets/images/CorVel.svg'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Comprehensive Management Platform",
                style: GoogleFonts.spectral(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Streamline business operations, workflows, and analytics to manage your fleet like a pro. Our tool is built for DSPs by DSPs.",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  color: Color.fromRGBO(102, 112, 133, 1),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                ListTile(
                  leading: SvgPicture.asset(
                    'assets/icons/check-circle.svg',
                  ),
                  title: Text(
                    "Our automations boost efficiencies by leaps and bounds.",
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: Color.fromRGBO(102, 112, 133, 1),
                    ),
                  ),
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    'assets/icons/check-circle.svg',
                  ),
                  title: Text(
                    "Track records and rest assured your documentation is stored safely.",
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: Color.fromRGBO(102, 112, 133, 1),
                    ),
                  ),
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    'assets/icons/check-circle.svg',
                  ),
                  title: Text(
                    "Vehicle health monitoring for proactive maintenance, servicing, and cost management.",
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: Color.fromRGBO(102, 112, 133, 1),
                    ),
                  ),
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    'assets/icons/check-circle.svg',
                  ),
                  title: Text(
                    "Assign driver routes and track historical performance.",
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: Color.fromRGBO(102, 112, 133, 1),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: AppButton(
                text: 'See DSP Desk',
                variant: ButtonVariant.primary,
                isFullWidth: false,
                size: ButtonSize.large,
                onPressed: () {
                  // Handle see DSP Desk
                },
              ),
            ),
            const SizedBox(height: 10),
            Image.asset(
              'assets/images/top.png',
              width: double.infinity,
              height: 200,
            ),
            Image.asset(
              'assets/images/graph.png',
              width: double.infinity,
              height: 200,
            ),
            const SizedBox(height: 40),
            // Key Features Section
            Container(
              key: _featuresKey,
              width: double.infinity,
              color: const Color.fromRGBO(247, 248, 250, 1),
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Key Features",
                      style: GoogleFonts.spectral(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        _buildFeatureCard(
                          context,
                          iconPath: 'assets/icons/calendar.svg',
                          title: "Daily Scheduling",
                          description:
                              "Assign your driver roster to routes, vehicles, and devices, while tracking attendance and performance.",
                        ),
                        _buildFeatureCard(
                          context,
                          iconPath: 'assets/icons/route-02.svg',
                          title: "Track Your Day",
                          description:
                              "Document and review comprehensive records on routes, package deliveries, and fleet health.",
                        ),
                        _buildFeatureCard(
                          context,
                          iconPath: 'assets/icons/tool-02.svg',
                          title: "Fleet Management",
                          description:
                              "Stay in the know on all things related to the health of your vehicles.",
                        ),
                        _buildFeatureCard(
                          context,
                          iconPath: 'assets/icons/message.svg',
                          title: "Messaging",
                          description:
                              "Stay in compliance and keep digital logs of communications with staff members.",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Contact Section
            Container(
              key: _contactKey,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xFFF4F8FE),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Schedule a Demo",
                    style: GoogleFonts.spectral(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Full Name',
                    hintText: 'Enter name',
                    isRequired: false,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Email address',
                    hintText: 'Enter email',
                    isRequired: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Tell Us What You Are Looking For',
                    hintText: 'Description Here',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    text: 'Send Message',
                    variant: ButtonVariant.primary,
                    isFullWidth: true,
                    size: ButtonSize.large,
                    onPressed: () {
                      // Handle send message
                    },
                  ),
                  const SizedBox(height: 40),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Background rectangle
                      Container(
                        width: 165,
                        height: 494,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(51, 92, 161, 1),
                        ),
                      ),
                      // Front frame container
                      Positioned(
                        top: 38,
                        child: Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 32,
                              height: 417.8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF1C4A97),
                              ),
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Chat section
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/message-chat-circle.svg',
                                        width: 17.25,
                                        height: 17.25,
                                        colorFilter: const ColorFilter.mode(
                                          Colors.white,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Chat to us',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            height: 1.54,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25.25),
                                    child: Text(
                                      'Our friendly team is here to help.',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        height: 1.44,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25.25),
                                    child: Text(
                                      'DSPDesk@gmail.com',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        height: 1.44,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // Office section
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/marker-pin-02.svg',
                                        width: 17.25,
                                        height: 17.25,
                                        colorFilter: const ColorFilter.mode(
                                          Colors.white,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Office',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            height: 1.54,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25.25),
                                    child: Text(
                                      'Visit Our Office HQ.',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        height: 1.44,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25.25),
                                    child: Text(
                                      '100 Smith Street\nCollingwood VIC 3066 AU',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        height: 1.44,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // Phone section
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/phone.svg',
                                        width: 17.25,
                                        height: 17.25,
                                        colorFilter: const ColorFilter.mode(
                                          Colors.white,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Phone',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            height: 1.54,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25.25),
                                    child: Text(
                                      'Mon-Fri from 8am to 5pm.',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        height: 1.44,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25.25),
                                    child: Text(
                                      '+1 (555) 000-0000',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        height: 1.44,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8)),
                                child: Image.asset(
                                  'assets/images/skyscraper_mask.png',
                                  fit: BoxFit.fitWidth,
                                  width: MediaQuery.of(context).size.width - 32,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Footer Section
            Container(
              color: const Color(0xFF1C4A97),
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 102.16,
                      height: 34,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 34),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Text(
                      "Consolidated tools for efficiency manage your business at one centralized location",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor:
                                Colors.transparent, // Remove the divider
                            listTileTheme: const ListTileThemeData(
                              iconColor: Colors.white,
                              textColor: Colors.white,
                            ),
                          ),
                          child: Column(
                            children: const [
                              FooterExpandableSection(
                                title: 'Links',
                                items: [],
                              ),
                              FooterExpandableSection(
                                title: 'Company',
                                items: [],
                              ),
                              FooterExpandableSection(
                                title: 'Contact Us',
                                items: [],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      FaIcon(FontAwesomeIcons.facebook, color: Colors.white),
                      SizedBox(width: 24.95),
                      FaIcon(FontAwesomeIcons.instagram, color: Colors.white),
                      SizedBox(width: 24.95),
                      FaIcon(FontAwesomeIcons.twitter, color: Colors.white),
                      SizedBox(width: 24.95),
                      FaIcon(FontAwesomeIcons.linkedin, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: const Divider(color: Colors.white54),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: Text(
                        "Copyrights 2023. All Rights Reserved",
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context,
      {required String iconPath,
      required String title,
      required String description}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 42,
              height: 42,
              colorFilter: ColorFilter.mode(
                AppTheme.primaryBlue,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF667085),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: GestureDetector(
        onTap: () {
          if (title == "Features") {
            Navigator.pop(context);
            Scrollable.ensureVisible(
              _featuresKey.currentContext!,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          } else if (title == "Home") {
            Navigator.pop(context);
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          } else if (title == "Contact Us") {
            Navigator.pop(context);
            Scrollable.ensureVisible(
              _contactKey.currentContext!,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        },
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontFamily: 'Montserrat',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.5,
                color: const Color.fromRGBO(102, 112, 133, 1),
              ),
        ),
      ),
    );
  }
}

class FooterExpandableSection extends StatefulWidget {
  final String title;
  final List<String> items;

  const FooterExpandableSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  State<FooterExpandableSection> createState() =>
      _FooterExpandableSectionState();
}

class _FooterExpandableSectionState extends State<FooterExpandableSection> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          visualDensity: const VisualDensity(vertical: -4),
          title: Text(
            widget.title,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
          ),
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
        ),
        if (isExpanded)
          ...widget.items.map((item) => Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
                child: Text(
                  item,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              )),
      ],
    );
  }
}
