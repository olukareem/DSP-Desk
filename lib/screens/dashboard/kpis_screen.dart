import 'package:drivers_management_app/screens/dashboard/kpi/kpi_charts.dart';
import 'package:drivers_management_app/screens/dashboard/kpi/notes/notes_widget.dart';
import 'package:flutter/material.dart';

import '../../components/header.dart';
import '../../components/side_nav.dart';
import '../../theme/app_theme.dart';

class KpiScreen extends StatefulWidget {
  const KpiScreen({super.key});

  @override
  State<KpiScreen> createState() => _KpiScreenState();
}
class _KpiScreenState extends State<KpiScreen> {
  bool isKpiTabActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      drawer: SideNav(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(height: 16),
            _buildTabSection(),
            SizedBox(height: 16), 
            Expanded(
              child: isKpiTabActive
                  ? KPIsWidget()
                  : NotesWidget(),
            ),
          ],
        ),
      ),
    );
  }

  // Tab section to switch between KPI Graph and Notes
  Widget _buildTabSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isKpiTabActive = true;
            });
          },
          child: _buildTabButton(
            title: 'KPI Graph',
            isActive: isKpiTabActive,
          ),
        ),
        SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            setState(() {
              isKpiTabActive = false;
            });
          },
          child: _buildTabButton(
            title: 'Notes',
            isActive: !isKpiTabActive,
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton({required String title, required bool isActive}) {
    return Container(
      width: 106,
      height: 38,
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primaryBlue : AppTheme.secondaryLightBlue,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isActive ? Colors.white : AppTheme.inactiveTabTextColor,
          ),
        ),
      ),
    );
  }
}
