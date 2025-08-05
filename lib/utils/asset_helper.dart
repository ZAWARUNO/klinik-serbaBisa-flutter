import 'package:flutter/material.dart';
import '../constants/assets.dart';

class AssetHelper {
  /// Memuat gambar dengan error handling yang lebih baik
  static Widget loadImage({
    required String assetPath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Color? color,
    Widget? errorWidget,
  }) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      color: color,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Error loading image: $assetPath - $error');
        return errorWidget ??
            Container(
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
                ],
              ),
            );
      },
    );
  }

  /// Memuat background image dengan fallback
  static Widget loadBackgroundImage({
    required String assetPath,
    BoxFit fit = BoxFit.cover,
    Alignment alignment = Alignment.center,
  }) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(assetPath),
          fit: fit,
          alignment: alignment,
          onError: (exception, stackTrace) {
            debugPrint(
              'Error loading background image: $assetPath - $exception',
            );
          },
        ),
      ),
    );
  }

  /// Memuat logo dengan fallback
  static Widget loadLogo({double size = 64, Color? color}) {
    return loadImage(
      assetPath: Assets.logoFavicon,
      width: size,
      height: size,
      color: color ?? Colors.white,
      errorWidget: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFF10B981),
          borderRadius: BorderRadius.circular(size * 0.2),
        ),
        child: Icon(
          Icons.medical_services,
          size: size * 0.6,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Memuat background poster dengan fallback
  static Widget loadBackgroundPoster({
    BoxFit fit = BoxFit.cover,
    Alignment alignment = Alignment.center,
  }) {
    return loadBackgroundImage(
      assetPath: Assets.posterLogin,
      fit: fit,
      alignment: alignment,
    );
  }

  /// Validasi apakah asset tersedia
  static Future<bool> isAssetAvailable(String assetPath) async {
    try {
      await AssetImage(assetPath).resolve(ImageConfiguration.empty);
      return true;
    } catch (e) {
      debugPrint('Asset not available: $assetPath - $e');
      return false;
    }
  }
}
