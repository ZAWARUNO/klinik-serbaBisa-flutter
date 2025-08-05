# Klinik SerbaBisa - Flutter App

Aplikasi Flutter untuk sistem manajemen klinik dengan halaman autentikasi yang super bagus dan responsif.

## 🚀 Fitur Utama

### Halaman Autentikasi
- ✅ **Login Screen** - Form login dengan validasi real-time
- ✅ **Register Screen** - Form registrasi lengkap dengan password strength indicator
- ✅ **Responsive Design** - Tampilan yang optimal untuk mobile dan desktop
- ✅ **Modern UI/UX** - Desain yang elegan dengan gradient dan shadow effects
- ✅ **Form Validation** - Validasi yang ketat untuk semua input
- ✅ **Loading States** - Indikator loading saat proses autentikasi

### Desain & Tema
- 🎨 **Color Scheme** - Tema hijau emerald yang profesional
- 📱 **Mobile-First** - Optimized untuk perangkat mobile
- 🖥️ **Desktop Support** - Layout split-screen untuk desktop
- 🌈 **Gradient Effects** - Background gradient yang menarik
- ✨ **Smooth Animations** - Transisi dan animasi yang halus

## 📁 Struktur Project

```
lib/
├── main.dart                    # Entry point aplikasi
├── screens/
│   └── auth/                    # Halaman autentikasi
│       ├── login_screen.dart    # Halaman login
│       ├── register_screen.dart # Halaman register
│       ├── auth_routes.dart     # Routing autentikasi
│       └── README.md           # Dokumentasi auth
├── widgets/
│   └── auth/
│       └── auth_widgets.dart    # Widget components
├── theme/
│   └── auth_theme.dart         # Tema dan styling
├── utils/
│   └── auth_validators.dart    # Validasi form
└── constants/
    └── assets.dart             # Path assets

assets/
└── images/                     # Gambar dan assets
    ├── poster-login.png        # Background image
    ├── logo_transparant_klinik.png # Logo klinik
    ├── logo_favicon.png        # Favicon
    └── README.md              # Dokumentasi assets
```

## 🛠️ Setup & Instalasi

### Prerequisites
- Flutter SDK (versi 3.8.1 atau lebih baru)
- Dart SDK
- Android Studio / VS Code
- Emulator atau device fisik

### Langkah Instalasi

1. **Clone repository**
   ```bash
   git clone <repository-url>
   cd klinik_serbabisa
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Siapkan assets**
   - Buat folder `assets/images/`
   - Tambahkan gambar yang diperlukan:
     - `poster-login.png` (1920x1080px)
     - `logo_transparant_klinik.png` (256x256px)
     - `logo_favicon.png` (32x32px)

4. **Run aplikasi**
   ```bash
   flutter run
   ```

## 🎨 Desain System

### Color Palette
- **Primary**: `#10B981` (Emerald)
- **Primary Dark**: `#059669`
- **Accent**: `#34D399`
- **Link**: `#EF4444` (Red)
- **Mobile Link**: `#FCD34D` (Yellow)

### Typography
- **Font Family**: Poppins
- **Title**: 24px, Bold
- **Subtitle**: 14px, Regular
- **Body**: 14px, Medium
- **Button**: 16px, SemiBold

### Spacing
- **Border Radius**: 12px (form), 25px (button), 32px (logo)
- **Padding**: 24px (form), 16px (field), 12px (vertical)
- **Margin**: 16px, 24px, 32px

## 📱 Responsive Design

### Mobile Layout (< 768px)
- Background image dengan gradient overlay
- Logo klinik di bagian atas
- Form dengan background semi-transparan
- Warna teks putih untuk kontras

### Desktop Layout (≥ 768px)
- Split screen: gambar di kiri, form di kanan
- Background putih untuk form
- Warna teks abu-abu untuk readability

## ✅ Validasi Form

### Login Form
- **Email**: Format email valid
- **Password**: Minimal 8 karakter

### Register Form
- **Email**: Format email valid
- **Nama**: Minimal 2 karakter
- **Umur**: 1-120 tahun
- **HP**: Format nomor Indonesia (08xxx atau 628xxx)
- **Alamat**: Minimal 10 karakter
- **Password**: Minimal 8 karakter dengan strength indicator

### Password Strength
1. Minimal 8 karakter
2. Mengandung huruf kecil
3. Mengandung huruf besar
4. Mengandung angka
5. Mengandung karakter khusus

Level: **Sangat Lemah** → **Lemah** → **Sedang** → **Kuat**

## 🔧 Customization

### Mengubah Tema
Edit file `lib/theme/auth_theme.dart`:
```dart
static const Color primaryColor = Color(0xFF10B981);
static const Color primaryDarkColor = Color(0xFF059669);
```

### Mengubah Validasi
Edit file `lib/utils/auth_validators.dart`:
```dart
static String? validateEmail(String? value) {
  // Custom validation logic
}
```

### Mengubah Widget Components
Edit file `lib/widgets/auth/auth_widgets.dart`:
```dart
static Widget buildTextField({...}) {
  // Custom widget logic
}
```

## 🚀 Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 📋 TODO

- [ ] Integrasi dengan backend API
- [ ] State management (Provider/Bloc)
- [ ] Local storage untuk session
- [ ] Push notifications
- [ ] Offline support
- [ ] Unit tests
- [ ] Integration tests
- [ ] CI/CD pipeline

## 🤝 Contributing

1. Fork repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

Jika ada pertanyaan atau masalah, silakan buat issue di repository ini.

---

**Dibuat dengan ❤️ untuk Klinik SerbaBisa**
