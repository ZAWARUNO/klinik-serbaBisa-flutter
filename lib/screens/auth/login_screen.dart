import 'package:flutter/material.dart';
import 'register_screen.dart';
import '../../widgets/auth/placeholder_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulasi proses login
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Navigate to home atau dashboard
      // Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 768) {
            // Desktop layout
            return Row(
              children: [
                // Gambar Kiri
                Expanded(flex: 1, child: _buildBackgroundImage()),
                // Form Section
                Expanded(flex: 1, child: _buildFormContent()),
              ],
            );
          } else {
            // Mobile layout
            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/poster-login.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF10B981).withOpacity(0.85),
                      const Color(0xFF059669).withOpacity(0.90),
                    ],
                  ),
                ),
                child: _buildFormContent(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildFormContent() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo untuk mobile
              if (MediaQuery.of(context).size.width <= 768) ...[
                PlaceholderWidgets.buildLogoPlaceholder(size: 64),
                const SizedBox(height: 16),
                Text(
                  'Klinik SerbaBisa',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],

              // Form
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: MediaQuery.of(context).size.width > 768
                      ? Colors.white
                      : Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Judul
                      Text(
                        'MASUK AKUN',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: MediaQuery.of(context).size.width > 768
                              ? Colors.grey[700]
                              : const Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Subjudul
                      Text(
                        'Masuk ke akun Anda untuk melakukan reservasi janji temu',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: MediaQuery.of(context).size.width > 768
                              ? Colors.grey[500]
                              : const Color(0xFF17313E),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Email Field
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        hint: 'contoh@email.com',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email harus diisi';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Format email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      _buildPasswordField(),
                      const SizedBox(height: 24),

                      // Login Button
                      _buildLoginButton(),
                      const SizedBox(height: 24),

                      // Divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: MediaQuery.of(context).size.width > 768
                                  ? Colors.grey[300]
                                  : const Color(0xFF17313E).withOpacity(0.3),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'atau',
                              style: TextStyle(
                                color: MediaQuery.of(context).size.width > 768
                                    ? Colors.grey[600]
                                    : const Color(0xFF17313E),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: MediaQuery.of(context).size.width > 768
                                  ? Colors.grey[300]
                                  : const Color(0xFF17313E).withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Belum punya akun?',
                            style: TextStyle(
                              color: MediaQuery.of(context).size.width > 768
                                  ? Colors.grey[600]
                                  : const Color(0xFF17313E),
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Daftar Disini',
                              style: TextStyle(
                                color: MediaQuery.of(context).size.width > 768
                                    ? Colors.red[500]
                                    : Colors.yellow[500],
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: MediaQuery.of(context).size.width > 768
                ? Colors.grey[600]
                : const Color(0xFF17313E),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
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
              borderSide: const BorderSide(color: Color(0xFF10B981), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
            color: MediaQuery.of(context).size.width > 768
                ? Colors.grey[600]
                : const Color(0xFF17313E),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password harus diisi';
            }
            if (value.length < 8) {
              return 'Password minimal 8 karakter';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Minimal 8 karakter',
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
              borderSide: const BorderSide(color: Color(0xFF10B981), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[500],
              ),
              onPressed: _togglePasswordVisibility,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/poster-login.png'),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
      child: PlaceholderWidgets.buildBackgroundPlaceholder(),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: MediaQuery.of(context).size.width > 768
            ? const Color(0xFF10B981)
            : Colors.white.withOpacity(0.95),
        foregroundColor: MediaQuery.of(context).size.width > 768
            ? Colors.white
            : const Color(0xFF10B981),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
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
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Text('Memproses...'),
              ],
            )
          : const Text(
              'Masuk Sekarang',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
    );
  }
}
