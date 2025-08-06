# Patient Screens

Folder ini berisi halaman-halaman yang terkait dengan fitur pasien.

## Struktur File

- `patient_dashboard_screen.dart` - Halaman dashboard utama pasien
- `patient_routes.dart` - Konfigurasi routing untuk halaman pasien

## Fitur Dashboard Pasien

### 1. Welcome Section

- Pesan selamat datang personal
- Statistik ringkas (janji temu, riwayat medis, resep aktif)
- Desain gradient yang menarik

### 2. Quick Actions

- Buat Janji - Untuk membuat janji temu baru
- Riwayat Medis - Melihat riwayat kesehatan
- Resep Obat - Mengelola resep aktif
- Konsultasi - Fitur konsultasi online

### 3. Janji Temu Terbaru

- Daftar janji temu yang sudah dijadwalkan
- Status janji (dikonfirmasi/menunggu)
- Informasi dokter dan waktu

### 4. Riwayat Medis

- Daftar riwayat konsultasi
- Diagnosis dan perawatan
- Tanggal dan dokter yang menangani

### 5. Statistik Kesehatan

- Jumlah konsultasi
- Jumlah resep
- Jumlah vaksinasi

### 6. Bottom Navigation

- Dashboard (halaman utama)
- Janji Temu
- Riwayat
- Profil

## Responsive Design

Dashboard pasien dirancang responsif dengan:

- Layout mobile (1 kolom) untuk layar < 768px
- Layout desktop (multi kolom) untuk layar >= 768px
- Animasi fade dan slide untuk transisi yang smooth

## Navigation

Setelah login berhasil, pengguna akan diarahkan ke:

```
/patient/dashboard
```

## Data Sample

Dashboard menggunakan data sample untuk demonstrasi:

- 2 janji temu (1 dikonfirmasi, 1 menunggu)
- 2 riwayat medis
- Statistik kesehatan

## TODO

- [ ] Integrasi dengan API backend
- [ ] Implementasi fitur buat janji
- [ ] Implementasi fitur konsultasi
- [ ] Implementasi fitur resep obat
- [ ] Implementasi notifikasi real-time
- [ ] Implementasi edit profil
- [ ] Implementasi pengaturan
