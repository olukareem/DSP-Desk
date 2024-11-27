import 'package:flutter/material.dart';
import 'screens/dashboard/kpis_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DSP Desk',
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
      home: KpiScreen(), // Replace with landing page
    );
  }
}
