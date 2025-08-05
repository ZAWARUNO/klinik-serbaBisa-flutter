import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class AuthRoutes {
  static const String login = '/login';
  static const String register = '/register';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (context) => const RegisterScreen());
      default:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
    }
  }
}
