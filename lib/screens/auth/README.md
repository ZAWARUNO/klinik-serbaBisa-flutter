# Halaman Autentikasi - Klinik SerbaBisa

Folder ini berisi halaman-halaman autentikasi untuk aplikasi Klinik SerbaBisa dengan desain yang super bagus dan responsif.

## Struktur File

```
lib/screens/auth/
├── login_screen.dart          # Halaman login
├── register_screen.dart       # Halaman register
├── auth_routes.dart          # Routing untuk halaman auth
└── README.md                 # Dokumentasi ini
```

## Fitur

### Login Screen (`login_screen.dart`)

- ✅ Form login dengan email dan password
- ✅ Validasi form real-time
- ✅ Toggle visibility password
- ✅ Loading state saat submit
- ✅ Responsive design (mobile & desktop)
- ✅ Background image dengan overlay gradient
- ✅ Navigasi ke halaman register

### Register Screen (`register_screen.dart`)

- ✅ Form register lengkap (email, nama, umur, kelamin, HP, alamat, password)
- ✅ Validasi form real-time
- ✅ Password strength indicator
- ✅ Toggle visibility password
- ✅ Loading state saat submit
- ✅ Responsive design (mobile & desktop)
- ✅ Background image dengan overlay gradient
- ✅ Navigasi ke halaman login

### Auth Routes (`auth_routes.dart`)

- ✅ Routing untuk halaman login dan register
- ✅ Fallback ke halaman login

## Desain

### Mobile Layout

- Background image dengan gradient overlay hijau
- Logo klinik di bagian atas
- Form dengan background semi-transparan
- Warna teks putih untuk kontras

### Desktop Layout

- Split screen: gambar di kiri, form di kanan
- Background putih untuk form
- Warna teks abu-abu untuk readability

### Warna Utama

- Primary: `#10B981` (Emerald)
- Primary Dark: `#059669`
- Link: `#EF4444` (Red)
- Mobile Link: `#FCD34D` (Yellow)

## Dependencies

Pastikan assets berikut tersedia di folder `assets/images/`:

- `poster-login.png` - Background image untuk halaman auth
- `logo_transparant_klinik.png` - Logo klinik
- `logo_favicon.png` - Favicon aplikasi

## Penggunaan

### Navigasi ke Login

```dart
Navigator.pushNamed(context, AuthRoutes.login);
```

### Navigasi ke Register

```dart
Navigator.pushNamed(context, AuthRoutes.register);
```

### Setup di main.dart

```dart
MaterialApp(
  // ...
  routes: AuthRoutes.getRoutes(),
  onGenerateRoute: AuthRoutes.onGenerateRoute,
  // ...
);
```

## Validasi

Semua form menggunakan validasi yang ketat:

- Email: Format email valid
- Password: Minimal 8 karakter
- Nama: Minimal 2 karakter
- Umur: 1-120 tahun
- HP: Format nomor Indonesia (08xxx atau 628xxx)
- Alamat: Minimal 10 karakter

## Password Strength

Indikator kekuatan password berdasarkan:

1. Minimal 8 karakter
2. Mengandung huruf kecil
3. Mengandung huruf besar
4. Mengandung angka
5. Mengandung karakter khusus

Level: Sangat Lemah → Lemah → Sedang → Kuat

## Responsive Breakpoint

- Mobile: < 768px
- Desktop: ≥ 768px

## Customization

Untuk mengubah tema atau styling, edit file:

- `lib/theme/auth_theme.dart` - Tema dan warna
- `lib/widgets/auth/auth_widgets.dart` - Widget components
- `lib/utils/auth_validators.dart` - Validasi form
