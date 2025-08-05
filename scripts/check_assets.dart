import 'dart:io';
import 'package:flutter/material.dart';
import '../lib/constants/assets.dart';

void main() {
  print('🔍 Memeriksa ketersediaan asset...\n');

  // Periksa setiap asset yang diperlukan
  for (String assetPath in Assets.requiredImages) {
    File assetFile = File(assetPath);
    if (assetFile.existsSync()) {
      print('✅ ${assetPath} - TERSEDIA');
    } else {
      print('❌ ${assetPath} - TIDAK DITEMUKAN');
    }
  }

  print('\n📁 Memeriksa struktur folder...');

  // Periksa folder assets
  Directory assetsDir = Directory('assets');
  if (assetsDir.existsSync()) {
    print('✅ Folder assets/ - TERSEDIA');

    Directory imagesDir = Directory('assets/images');
    if (imagesDir.existsSync()) {
      print('✅ Folder assets/images/ - TERSEDIA');

      // List semua file di folder images
      List<FileSystemEntity> files = imagesDir.listSync();
      print('📋 File yang ada di assets/images/:');
      for (FileSystemEntity file in files) {
        if (file is File) {
          print('   📄 ${file.path.split('/').last}');
        }
      }
    } else {
      print('❌ Folder assets/images/ - TIDAK DITEMUKAN');
    }
  } else {
    print('❌ Folder assets/ - TIDAK DITEMUKAN');
  }

  print('\n💡 Tips:');
  print('1. Pastikan semua file gambar ada di folder assets/images/');
  print('2. Jalankan "flutter clean" dan "flutter pub get"');
  print('3. Restart aplikasi dengan "flutter run"');
}
