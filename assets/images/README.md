# Assets Images - Klinik SerbaBisa

Folder ini berisi gambar-gambar yang diperlukan untuk aplikasi Klinik SerbaBisa.

## File yang Diperlukan

### 1. `poster-login.png`

- **Ukuran**: 1920x1080px (16:9) atau 1200x800px
- **Format**: PNG dengan transparansi
- **Kegunaan**: Background image untuk halaman login dan register
- **Deskripsi**: Poster atau gambar yang menampilkan layanan klinik, dokter, atau suasana klinik yang profesional

### 2. `logo_transparant_klinik.png`

- **Ukuran**: 256x256px atau 512x512px
- **Format**: PNG dengan background transparan
- **Kegunaan**: Logo klinik yang ditampilkan di halaman mobile
- **Deskripsi**: Logo Klinik SerbaBisa dengan background transparan

### 3. `logo_favicon.png`

- **Ukuran**: 32x32px, 64x64px, atau 128x128px
- **Format**: PNG
- **Kegunaan**: Favicon aplikasi
- **Deskripsi**: Versi kecil dari logo klinik untuk favicon

## Spesifikasi Teknis

### Format yang Didukung

- PNG (direkomendasikan untuk transparansi)
- JPG/JPEG (untuk foto)
- WebP (untuk optimasi)

### Optimasi

- Kompres gambar untuk mengurangi ukuran file
- Gunakan resolusi yang sesuai dengan kebutuhan
- Pertimbangkan loading time di koneksi lambat

### Responsive Images

- Siapkan beberapa ukuran untuk device yang berbeda
- Gunakan `Image.asset()` dengan `fit: BoxFit.cover` untuk background
- Gunakan `Image.asset()` dengan `fit: BoxFit.contain` untuk logo

## Penggunaan di Kode

### Background Image

```dart
decoration: BoxDecoration(
  image: DecorationImage(
    image: AssetImage('assets/images/poster-login.png'),
    fit: BoxFit.cover,
    alignment: Alignment.center,
  ),
),
```

### Logo Image

```dart
Image.asset(
  'assets/images/logo_transparant_klinik.png',
  fit: BoxFit.contain,
)
```

## Setup di pubspec.yaml

Pastikan assets sudah dideklarasikan di `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/poster-login.png
    - assets/images/logo_transparant_klinik.png
    - assets/images/logo_favicon.png
```

## Tips Desain

### Poster Login

- Gunakan warna yang harmonis dengan tema aplikasi (hijau emerald)
- Pastikan teks tetap terbaca dengan overlay gradient
- Hindari elemen yang terlalu detail di area form

### Logo

- Gunakan warna yang kontras dengan background
- Pastikan logo tetap terbaca dalam ukuran kecil
- Pertahankan aspek ratio yang konsisten

### Favicon

- Gunakan versi yang paling sederhana dari logo
- Pastikan terbaca dalam ukuran 16x16px
- Gunakan warna yang kontras
