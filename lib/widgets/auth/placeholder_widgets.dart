import 'package:flutter/material.dart';
import '../../theme/auth_theme.dart';

class PlaceholderWidgets {
  // Placeholder untuk background image
  static Widget buildBackgroundPlaceholder() {
    return Container(
      decoration: BoxDecoration(gradient: AuthTheme.mobileGradient),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_transparant_klinik.png',
              width: 200,
              height: 150,
              color: Colors.white.withOpacity(0.8),
            ),
            const SizedBox(height: 16),
            Text(
              'Layanan Kesehatan Terpercaya Untuk Seluruh Masyarakat Indonesia',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Placeholder untuk logo
  static Widget buildLogoPlaceholder({double size = 64}) {
    return Image.asset(
      'assets/images/logo_favicon.png',
      width: size,
      height: size,
      color: Colors.white,
    );
  }

  // Placeholder untuk favicon
  static Widget buildFaviconPlaceholder({double size = 32}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AuthTheme.primaryColor,
        borderRadius: BorderRadius.circular(size * 0.2),
      ),
      child: Image.asset(
        'assets/images/logo_favicon.png',
        width: size * 0.6,
        height: size * 0.6,
        color: Colors.white,
      ),
    );
  }

  // Error widget untuk gambar yang gagal dimuat
  static Widget buildImageErrorWidget({
    required String imagePath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, size: 32, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'Gambar tidak tersedia',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          Text(
            imagePath.split('/').last,
            style: TextStyle(fontSize: 10, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  // Loading widget untuk gambar
  static Widget buildImageLoadingWidget({double? width, double? height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AuthTheme.primaryColor),
        ),
      ),
    );
  }

  // Info widget untuk gambar yang belum ditambahkan
  static Widget buildMissingImageInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
              const SizedBox(width: 8),
              Text(
                'Gambar Belum Ditambahkan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Untuk tampilan yang optimal, silakan tambahkan gambar berikut:',
            style: TextStyle(color: Colors.orange[800], fontSize: 14),
          ),
          const SizedBox(height: 8),
          _buildImageList(),
        ],
      ),
    );
  }

  static Widget _buildImageList() {
    final images = [
      'assets/images/poster-login.png (1920x1080px)',
      'assets/images/logo_transparant_klinik.png (256x256px)',
      'assets/images/logo_favicon.png (32x32px)',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: images.map((image) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Icon(Icons.image, size: 16, color: Colors.orange[600]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  image,
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
