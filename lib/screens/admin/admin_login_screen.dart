import 'package:flutter/material.dart';
import '../../theme/auth_theme.dart';
import '../../widgets/auth/auth_widgets.dart';
import '../../widgets/auth/placeholder_widgets.dart';
import '../../utils/auth_validators.dart';
import '../../constants/assets.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulasi proses login
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Navigasi ke dashboard admin (akan dibuat nanti)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Login berhasil!'),
          backgroundColor: AuthTheme.primaryColor,
        ),
      );
    }
  }

  Widget _buildBackgroundImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.posterLogin),
          fit: BoxFit.cover,
          onError: (exception, stackTrace) {
            // Fallback jika gambar tidak ditemukan
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 768;

          // Desktop layout (>= 768px)
          if (!isMobile) {
            return Row(
              children: [
                // Gambar kiri
                Expanded(flex: 1, child: _buildBackgroundImage()),
                // Form kanan
                Expanded(flex: 1, child: _buildLoginForm(isMobile)),
              ],
            );
          }
          // Mobile layout (< 768px)
          else {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.posterLogin),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                    // Fallback jika gambar tidak ditemukan
                  },
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF059669).withOpacity(0.85),
                      const Color(0xFF047857).withOpacity(0.90),
                    ],
                  ),
                ),
                child: _buildLoginForm(isMobile),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildLoginForm(bool isMobile) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo untuk mobile
            if (isMobile)
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: PlaceholderWidgets.buildLogoPlaceholder(),
              ),

            // Container form
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                color: isMobile ? Colors.white.withOpacity(0.95) : Colors.white,
                borderRadius: BorderRadius.circular(AuthTheme.borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.admin_panel_settings,
                            size: 48,
                            color: AuthTheme.primaryColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'ADMIN LOGIN',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AuthTheme.getTextColor(
                                isMobile,
                                mobileColor: const Color(0xFF059669),
                                desktopColor: const Color(0xFF374151),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Masuk ke panel administrator',
                            style: TextStyle(
                              fontSize: 14,
                              color: AuthTheme.getSubtitleColor(isMobile),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Email field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email Admin',
                          style: TextStyle(
                            color: isMobile
                                ? const Color(0xFF059669)
                                : const Color(0xFF374151),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: AuthValidators.validateEmail,
                          decoration: InputDecoration(
                            hintText: 'admin@klinik.com',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.95),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF059669),
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Password field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Password',
                          style: TextStyle(
                            color: isMobile
                                ? const Color(0xFF059669)
                                : const Color(0xFF374151),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          validator: AuthValidators.validatePassword,
                          decoration: InputDecoration(
                            hintText: 'Masukkan password admin',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.95),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF059669),
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey[500],
                              ),
                              onPressed: _togglePasswordVisibility,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isMobile
                              ? Colors.white.withOpacity(0.95)
                              : AuthTheme.primaryColor,
                          foregroundColor: isMobile
                              ? const Color(0xFF059669)
                              : Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 4,
                        ),
                        child: _isLoading
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text('Memproses...'),
                                ],
                              )
                            : const Text(
                                'Login Admin',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Divider
                    AuthWidgets.buildDividerWithText(
                      text: 'atau',
                      isMobile: isMobile,
                    ),

                    const SizedBox(height: 16),

                    // Link ke user login
                    AuthWidgets.buildAuthLink(
                      text: 'Login sebagai User?',
                      linkText: 'Klik Disini',
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      isMobile: isMobile,
                    ),

                    const SizedBox(height: 16),

                    // Info tambahan
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue[600],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Halaman ini khusus untuk administrator klinik',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer untuk mobile
            if (isMobile)
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Text(
                  '© 2025 Klinik SerbaBisa. All rights reserved.',
                  style: TextStyle(fontSize: 12, color: Colors.grey[200]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
