import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: kToolbarHeight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
            Row(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      width: 48,
                      height: 48,
                      child: const Icon(
                        Icons.menu,
                        color: Color(0xFF667085),
                        size: 24,
                      ),
                    ),
                  ),
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
              ],
            ),
            // Right section with actions
            Row(
              children: [
                _buildActionButton(
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
                const SizedBox(width: 8),
                _buildActionButton(
                  onTap: () {
                    // Add notification functionality
                  },
                  child: SvgPicture.asset(
                    'assets/icons/notification.svg',
                    width: 20,
                    height: 20,
                  ),
                ),
                const SizedBox(width: 8),
                const CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          width: 40,
          height: 40,
          child: child,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}