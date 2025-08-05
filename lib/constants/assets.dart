class Assets {
  // Path untuk folder images
  static const String imagesPath = 'assets/images/';

  // Gambar untuk autentikasi
  static const String posterLogin = '${imagesPath}poster-login.png';
  static const String logoTransparant =
      '${imagesPath}logo_transparant_klinik.png';
  static const String logoFavicon = '${imagesPath}logo_favicon.png';

  // Path untuk folder icons
  static const String iconsPath = 'assets/icons/';

  // Path untuk folder fonts
  static const String fontsPath = 'assets/fonts/';

  // Daftar semua assets yang diperlukan
  static const List<String> requiredImages = [
    posterLogin,
    logoTransparant,
    logoFavicon,
  ];

  // Daftar semua assets untuk pubspec.yaml
  static const Map<String, List<String>> pubspecAssets = {
    'assets/images/': [
      'poster-login.png',
      'logo_transparant_klinik.png',
      'logo_favicon.png',
    ],
  };
}
