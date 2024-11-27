import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Occupy full width available
      height: 64, // Fixed height
      padding: const EdgeInsets.symmetric(
          vertical: 16, horizontal: 20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Color(0xFFEAECF0),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(children: [
            // Hamburger menu
            IconButton(
              icon: const Icon(Icons.menu, color: Color(0xFF667085)),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Opens the side nav
              },
            ),

            const SizedBox(width: 8),

            // Logo
            SizedBox(
              width: 78.12,
              height: 26,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                color: const Color.fromRGBO(28, 74, 151, 1),
              ),
            ),
          ]),

          // Search, notification, and avatar
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: GestureDetector(
                  onTap: () {
                    // Add search functionality
                  },
                  child: SvgPicture.asset(
                    'assets/icons/search.svg',
                    width: 20,
                    height: 20,
                    color: Colors.grey,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Notification Icon
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2.5),
                    child: GestureDetector(
                      onTap: () {
                        // Add notification functionality
                      },
                      child: SvgPicture.asset(
                        'assets/icons/notification.svg',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 16),

              // Avatar Circle
              CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage(
                      'assets/images/avatar.png'), // Placeholder image path
                  backgroundColor: Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
