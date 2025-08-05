# Placeholder Images - Klinik SerbaBisa

File ini berisi informasi tentang gambar placeholder yang diperlukan untuk aplikasi.

## Gambar yang Diperlukan

### 1. poster-login.png

**Status**: ❌ Belum ada (perlu dibuat/ditambahkan)

**Spesifikasi**:

- Ukuran: 1920x1080px (16:9) atau 1200x800px
- Format: PNG
- Deskripsi: Background image untuk halaman login dan register
- Konten: Poster atau gambar yang menampilkan layanan klinik, dokter, atau suasana klinik yang profesional

**Sumber yang bisa digunakan**:

- Unsplash: https://unsplash.com/s/photos/medical-clinic
- Pexels: https://www.pexels.com/search/medical/
- Buat sendiri menggunakan Canva atau Figma

### 2. logo_transparant_klinik.png

**Status**: ❌ Belum ada (perlu dibuat/ditambahkan)

**Spesifikasi**:

- Ukuran: 256x256px atau 512x512px
- Format: PNG dengan background transparan
- Deskripsi: Logo Klinik SerbaBisa dengan background transparan
- Konten: Logo yang menampilkan nama "Klinik SerbaBisa" dengan ikon medis

**Sumber yang bisa digunakan**:

- Buat sendiri menggunakan Canva, Figma, atau Adobe Illustrator
- Gunakan template logo medis dari Freepik atau Flaticon
- Konsultasi dengan desainer grafis

### 3. logo_favicon.png

**Status**: ❌ Belum ada (perlu dibuat/ditambahkan)

**Spesifikasi**:

- Ukuran: 32x32px, 64x64px, atau 128x128px
- Format: PNG
- Deskripsi: Versi kecil dari logo klinik untuk favicon
- Konten: Versi yang disederhanakan dari logo utama

## Cara Menambahkan Gambar

1. **Download atau buat gambar** sesuai spesifikasi di atas
2. **Simpan gambar** di folder `assets/images/` dengan nama yang tepat
3. **Pastikan format dan ukuran** sesuai dengan spesifikasi
4. **Test aplikasi** untuk memastikan gambar tampil dengan benar

## Alternatif Sementara

Jika gambar belum tersedia, aplikasi akan menampilkan error. Untuk testing, Anda bisa:

1. **Gunakan gambar placeholder** dari:

   - https://placeholder.com/
   - https://picsum.photos/
   - https://via.placeholder.com/

2. **Contoh command untuk download placeholder**:

   ```bash
   # Download placeholder untuk poster
   curl -o assets/images/poster-login.png "https://picsum.photos/1920/1080"

   # Download placeholder untuk logo
   curl -o assets/images/logo_transparant_klinik.png "https://picsum.photos/256/256"

   # Download placeholder untuk favicon
   curl -o assets/images/logo_favicon.png "https://picsum.photos/32/32"
   ```

## Tips Desain

### Untuk Poster Login

- Gunakan warna yang harmonis dengan tema aplikasi (hijau emerald #10B981)
- Pastikan teks tetap terbaca dengan overlay gradient
- Hindari elemen yang terlalu detail di area form
- Fokus pada tema kesehatan dan profesionalisme

### Untuk Logo

- Gunakan warna yang kontras dengan background
- Pastikan logo tetap terbaca dalam ukuran kecil
- Pertahankan aspek ratio yang konsisten
- Sertakan elemen medis (stetoskop, salib, dll.)

### Untuk Favicon

- Gunakan versi yang paling sederhana dari logo
- Pastikan terbaca dalam ukuran 16x16px
- Gunakan warna yang kontras
- Hindari detail yang terlalu kecil

## Catatan Penting

- **Hak Cipta**: Pastikan gambar yang digunakan memiliki lisensi yang sesuai
- **Optimasi**: Kompres gambar untuk mengurangi ukuran file
- **Backup**: Simpan file asli gambar untuk keperluan editing di masa depan
- **Testing**: Test aplikasi di berbagai ukuran layar untuk memastikan responsivitas
