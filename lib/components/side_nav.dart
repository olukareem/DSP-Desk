import 'package:drivers_management_app/screens/fleet/fleet_overview_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:drivers_management_app/screens/dashboard/kpis_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../screens/authentication/auth_screen.dart';
import '../theme/app_theme.dart';

class SideNav extends StatefulWidget {
  const SideNav({super.key});

  @override
  State<SideNav> createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> {
  final Map<String, bool> _isTileExpanded = {};
  String _activeScreen = 'KPIs'; // Initial active screen

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppTheme.primaryBlue,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildCustomHeader(),
            _buildCustomExpansionTile(
              context,
              svgIconPath: 'assets/icons/grid-01.svg',
              title: 'Dashboard',
              children: [
                _buildCustomListTile(
                  context,
                  'KPIs',
                  () {
                    setState(() {
                      _activeScreen = 'KPIs'; // Set the active screen
                    });
                    Navigator.of(context).pop(); // Close the drawer
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => KpiScreen(),
                    ));
                  },
                  isActive: _activeScreen == 'KPIs', // Highlight active screen
                ),
                _buildCustomListTile(
                  context,
                  'Real Time Statics',
                  () {
                    setState(() {
                      _activeScreen =
                          'Real Time Statics'; // Set the active screen
                    });
                  },
                  isActive: _activeScreen == 'Real Time Statics',
                ),
              ],
              isParentActive: _activeScreen == 'KPIs' ||
                  _activeScreen ==
                      'Real Time Statics', // Make parent active when children are active
            ),
            _buildCustomExpansionTile(
              context,
              svgIconPath: 'assets/icons/truck-01.svg',
              title: 'Fleet',
              children: [
                _buildCustomListTile(
                  context,
                  'Fleet Overview',
                  () {
                    setState(() {
                      _activeScreen = 'Fleet Overview';
                    });
                    Navigator.of(context).pop(); // Close the drawer
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FleetOverviewScreen(),
                    ));
                  },
                  isActive: _activeScreen == 'Fleet Overview',
                ),
                _buildCustomListTile(
                  context,
                  'Fleet Inspection',
                  () {
                    setState(() {
                      _activeScreen = 'Fleet Inspection';
                    });
                  },
                  isActive: _activeScreen == 'Fleet Inspection',
                ),
                _buildCustomListTile(
                  context,
                  'Fleet Assignment',
                  () {
                    setState(() {
                      _activeScreen = 'Fleet Assignment';
                    });
                  },
                  isActive: _activeScreen == 'Fleet Assignment',
                ),
              ],
              isParentActive: _activeScreen == 'Fleet Overview' ||
                  _activeScreen == 'Fleet Inspection' ||
                  _activeScreen == 'Fleet Assignment',
            ),
            _buildCustomExpansionTile(
              context,
              svgIconPath: 'assets/icons/user-01.svg',
              title: 'Drivers',
              children: [
                _buildCustomListTile(
                  context,
                  'Driver List',
                  () {
                    setState(() {
                      _activeScreen = 'Driver List';
                    });
                  },
                  isActive: _activeScreen == 'Driver List',
                ),
                _buildCustomListTile(
                  context,
                  'Driver Schedule',
                  () {
                    setState(() {
                      _activeScreen = 'Driver Schedule';
                    });
                  },
                  isActive: _activeScreen == 'Driver Schedule',
                ),
              ],
              isParentActive: _activeScreen == 'Driver List' ||
                  _activeScreen == 'Driver Schedule',
            ),
            _buildCustomListTile(
              context,
              'Trips',
              () {
                setState(() {
                  _activeScreen = 'Trips';
                });
              },
              svgIconPath: 'assets/icons/route.svg',
              isActive: _activeScreen == 'Trips',
            ),
            _buildCustomExpansionTile(
              context,
              svgIconPath: 'assets/icons/tool-02.svg',
              title: 'Maintenance',
              children: [
                _buildCustomListTile(
                  context,
                  'Schedule',
                  () {
                    setState(() {
                      _activeScreen = 'Schedule';
                    });
                  },
                  isActive: _activeScreen == 'Schedule',
                ),
                _buildCustomListTile(
                  context,
                  'History',
                  () {
                    setState(() {
                      _activeScreen = 'History';
                    });
                  },
                  isActive: _activeScreen == 'History',
                ),
              ],
              isParentActive:
                  _activeScreen == 'Schedule' || _activeScreen == 'History',
            ),
            _buildCustomExpansionTile(
              context,
              svgIconPath: 'assets/icons/trend-up-01.svg',
              title: 'Report',
              children: [
                _buildCustomListTile(
                  context,
                  'View Report',
                  () {
                    setState(() {
                      _activeScreen = 'View Report';
                    });
                  },
                  isActive: _activeScreen == 'View Report',
                ),
              ],
              isParentActive: _activeScreen == 'View Report',
            ),
            _buildCustomListTile(
              context,
              'Chat',
              () {
                setState(() {
                  _activeScreen = 'Chat';
                });
              },
              svgIconPath: 'assets/icons/chat-01.svg',
              isActive: _activeScreen == 'Chat',
            ),
            _buildCustomExpansionTile(
              context,
              svgIconPath: 'assets/icons/settings-01.svg',
              title: 'Settings',
              children: [],
              isParentActive: false,
            ),
            _buildCustomListTile(
              context,
              'Logout',
              () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) =>
                              const AuthScreen(isLogin: true)),
                      (route) => false,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error logging out. Please try again.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              svgIconPath: 'assets/icons/log-out-01.svg',
              isActive: _activeScreen == 'Logout',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Container(
      width: 258,
      height: 100,
      padding: EdgeInsets.only(top: 20.0, left: 26.0, right: 26.0),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue, // Match drawer color
        border: Border(
          right: BorderSide(
            color: Colors.transparent,
            width: 1,
          ),
        ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 108.17,
          height: 36,
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
            color: const Color.fromRGBO(255, 255, 255, 1),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomExpansionTile(
    BuildContext context, {
    required String svgIconPath,
    required String title,
    required List<Widget> children,
    required bool isParentActive,
  }) {
    final isExpanded = _isTileExpanded[title] ?? false;

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent, // Remove divider lines
      ),
      child: ExpansionTile(
        leading: SvgPicture.asset(
          svgIconPath,
          color:
              isParentActive ? Colors.white : Color.fromRGBO(223, 223, 223, 1),
          width: 24,
          height: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isParentActive
                ? Colors.white
                : Color.fromRGBO(223, 223, 223, 1), // Active color
          ),
        ),
        trailing: Icon(
          isExpanded ? Icons.keyboard_arrow_down : Icons.chevron_right,
          color:
              isParentActive ? Colors.white : Color.fromRGBO(223, 223, 223, 1),
        ),
        backgroundColor:
            AppTheme.primaryBlue, // Ensure consistent background color
        collapsedBackgroundColor: AppTheme.primaryBlue,
        childrenPadding: EdgeInsets.only(left: 16.0),
        children: children,
        onExpansionChanged: (bool expanded) {
          setState(() {
            _isTileExpanded[title] = expanded;
          });
        },
      ),
    );
  }

  Widget _buildCustomListTile(
    BuildContext context,
    String title,
    VoidCallback onTap, {
    String? svgIconPath,
    bool isActive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          onTap();
        },
        highlightColor: Colors.white24,
        splashColor: Colors.white30,
        child: ListTile(
          tileColor: AppTheme.primaryBlue, // Ensure tile color is consistent
          leading: svgIconPath != null
              ? SvgPicture.asset(
                  svgIconPath,
                  color: isActive
                      ? Colors.white
                      : Color.fromRGBO(223, 223, 223, 1),
                  width: 24,
                  height: 24,
                )
              : null,
          title: Text(
            title,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : Color.fromRGBO(223, 223, 223, 1),
            ),
          ),
        ),
      ),
    );
  }
}
