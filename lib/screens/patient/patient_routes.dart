import 'package:flutter/material.dart';
import 'patient_dashboard_screen.dart';

class PatientRoutes {
  static const String dashboard = '/patient/dashboard';

  static Map<String, WidgetBuilder> getRoutes() {
    return {dashboard: (context) => const PatientDashboardScreen()};
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboard:
        return MaterialPageRoute(
          builder: (context) => const PatientDashboardScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('Halaman tidak ditemukan')),
          ),
        );
    }
  }
}
