import 'package:flutter/material.dart';

class AuthWidgets {
  // Custom Text Field untuk form autentikasi
  static Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool isMobile = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isMobile ? Colors.white : Colors.grey[600],
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
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  // Custom Button untuk autentikasi
  static Widget buildAuthButton({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isMobile = false,
  }) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isMobile
            ? Colors.white.withOpacity(0.95)
            : const Color(0xFF10B981),
        foregroundColor: isMobile ? const Color(0xFF10B981) : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 4,
      ),
      child: isLoading
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
          : Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
    );
  }

  // Logo widget untuk mobile
  static Widget buildMobileLogo() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Image.asset(
          'assets/images/logo_transparant_klinik.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  // Form container dengan styling
  static Widget buildFormContainer({
    required Widget child,
    bool isMobile = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isMobile ? Colors.white.withOpacity(0.95) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  // Password strength indicator
  static Widget buildPasswordStrengthIndicator({
    required int strength,
    bool isMobile = false,
  }) {
    final colors = [Colors.red, Colors.orange, Colors.yellow, Colors.green];

    final texts = ['Sangat Lemah', 'Lemah', 'Sedang', 'Kuat'];

    return Row(
      children: [
        Row(
          children: List.generate(4, (index) {
            Color barColor = index < strength
                ? colors[(strength - 1).clamp(0, 3)]
                : Colors.grey[300]!;

            return Container(
              width: 16,
              height: 4,
              margin: EdgeInsets.only(right: index < 3 ? 4 : 0),
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
        const SizedBox(width: 8),
        Text(
          strength > 0
              ? texts[(strength - 1).clamp(0, 3)]
              : 'Kekuatan password',
          style: TextStyle(
            fontSize: 12,
            color: isMobile ? Colors.white : Colors.grey[500],
          ),
        ),
      ],
    );
  }

  // Divider dengan text
  static Widget buildDividerWithText({
    required String text,
    bool isMobile = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: isMobile ? Colors.white.withOpacity(0.3) : Colors.grey[300],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: TextStyle(
              color: isMobile ? Colors.white : Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: isMobile ? Colors.white.withOpacity(0.3) : Colors.grey[300],
          ),
        ),
      ],
    );
  }

  // Link text untuk navigasi
  static Widget buildAuthLink({
    required String text,
    required String linkText,
    required VoidCallback onTap,
    bool isMobile = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            color: isMobile ? Colors.white : Colors.grey[600],
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            linkText,
            style: TextStyle(
              color: isMobile ? Colors.yellow[300] : Colors.red[500],
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
