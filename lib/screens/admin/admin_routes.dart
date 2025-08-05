import 'package:flutter/material.dart';
import 'admin_login_screen.dart';

class AdminRoutes {
  static const String adminLogin = '/admin/login';

  static Map<String, WidgetBuilder> getRoutes() {
    return {adminLogin: (context) => const AdminLoginScreen()};
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case adminLogin:
        return MaterialPageRoute(
          builder: (context) => const AdminLoginScreen(),
        );
      default:
        return null;
    }
  }
}
