import 'package:flutter/material.dart';
import 'screens/auth/auth_routes.dart';
import 'theme/auth_theme.dart';

void main() {
  runApp(const KlinikSerbaBisaApp());
}

class KlinikSerbaBisaApp extends StatelessWidget {
  const KlinikSerbaBisaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Klinik SerbaBisa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AuthTheme.primaryColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          backgroundColor: AuthTheme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AuthTheme.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AuthTheme.buttonBorderRadius),
            ),
            padding: AuthTheme.buttonPadding,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AuthTheme.borderRadius),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AuthTheme.borderRadius),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AuthTheme.borderRadius),
            borderSide: const BorderSide(
              color: AuthTheme.primaryColor,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AuthTheme.borderRadius),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: AuthTheme.fieldPadding,
        ),
      ),
      initialRoute: AuthRoutes.login,
      routes: AuthRoutes.getRoutes(),
      onGenerateRoute: AuthRoutes.onGenerateRoute,
    );
  }
}
