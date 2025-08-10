# Panduan API Routes untuk Dashboard Flutter

## Overview

Dokumen ini menjelaskan API routes yang perlu ditambahkan di Laravel untuk mendukung fitur dashboard Flutter.

## Routes yang Perlu Ditambahkan

### 1. Tambahkan di `routes/web.php`

```php
use App\Http\Controllers\API\DashboardController;

// API Routes untuk Dashboard Pasien
Route::prefix('api')->group(function () {
    // Dashboard routes
    Route::get('/pasien/reservasi/{email}', [DashboardController::class, 'getReservasiData']);
    Route::get('/pasien/hasil-reservasi/{email}', [DashboardController::class, 'getHasilReservasi']);
    Route::get('/pasien/dashboard-stats/{email}', [DashboardController::class, 'getDashboardStats']);
    Route::get('/pasien/reservasi-terbaru/{email}', [DashboardController::class, 'getReservasiTerbaru']);
    Route::get('/pasien/hasil-reservasi-terbaru/{email}', [DashboardController::class, 'getHasilReservasiTerbaru']);

    // Jadwal routes
    Route::get('/jadwal-dokter', [DashboardController::class, 'getJadwalDokter']);
    Route::get('/jadwal-hari-ini', [DashboardController::class, 'getJadwalHariIni']);
});
```

### 2. Buat Controller `app/Http/Controllers/API/DashboardController.php`

```php
<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class DashboardController extends Controller
{
    // Get reservasi data untuk pasien
    public function getReservasiData($email)
    {
        try {
            $reservasi = DB::table('reservasi as r')
                ->leftJoin('jadwal as j', 'r.schedule_id', '=', 'j.schedule_id')
                ->where('r.email', $email)
                ->select([
                    'r.id',
                    'r.email',
                    'r.nama',
                    'r.umur',
                    'r.kelamin',
                    'r.nomor_hp',
                    'r.alamat',
                    'r.schedule_id',
                    'r.keluhan',
                    'r.status',
                    'j.nama as nama_dokter',
                    'j.poli',
                    'j.hari',
                    'j.waktu',
                    'r.created_at'
                ])
                ->orderBy('r.created_at', 'desc')
                ->get();

            return response()->json([
                'success' => true,
                'message' => 'Data reservasi berhasil diambil',
                'data' => $reservasi
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data reservasi: ' . $e->getMessage()
            ], 500);
        }
    }

    // Get jadwal dokter
    public function getJadwalDokter()
    {
        try {
            $jadwal = DB::table('jadwal')
                ->orderBy('hari')
                ->orderBy('waktu')
                ->get();

            return response()->json([
                'success' => true,
                'message' => 'Data jadwal dokter berhasil diambil',
                'data' => $jadwal
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data jadwal: ' . $e->getMessage()
            ], 500);
        }
    }

    // Get hasil reservasi untuk pasien
    public function getHasilReservasi($email)
    {
        try {
            $hasil = DB::table('hasil_reservasi')
                ->where('email', $email)
                ->orderBy('created_at', 'desc')
                ->get();

            return response()->json([
                'success' => true,
                'message' => 'Data hasil reservasi berhasil diambil',
                'data' => $hasil
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data hasil reservasi: ' . $e->getMessage()
            ], 500);
        }
    }

    // Get dashboard statistics
    public function getDashboardStats($email)
    {
        try {
            $today = Carbon::now()->format('l'); // Get current day name in English
            $dayMapping = [
                'Sunday' => 'minggu',
                'Monday' => 'senin',
                'Tuesday' => 'selasa',
                'Wednesday' => 'rabu',
                'Thursday' => 'kamis',
                'Friday' => 'jumat',
                'Saturday' => 'sabtu'
            ];
            $todayIndonesian = $dayMapping[$today] ?? 'minggu';

            $stats = [
                'total_reservasi' => DB::table('reservasi')->where('email', $email)->count(),
                'reservasi_belum' => DB::table('reservasi')->where('email', $email)->where('status', 'belum')->count(),
                'reservasi_sudah' => DB::table('reservasi')->where('email', $email)->where('status', 'sudah')->count(),
                'total_hasil_reservasi' => DB::table('hasil_reservasi')->where('email', $email)->count(),
                'jadwal_hari_ini' => DB::table('jadwal')->where('hari', $todayIndonesian)->count()
            ];

            return response()->json([
                'success' => true,
                'message' => 'Statistik dashboard berhasil diambil',
                'data' => $stats
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil statistik: ' . $e->getMessage()
            ], 500);
        }
    }

    // Get jadwal hari ini
    public function getJadwalHariIni()
    {
        try {
            $today = Carbon::now()->format('l');
            $dayMapping = [
                'Sunday' => 'minggu',
                'Monday' => 'senin',
                'Tuesday' => 'selasa',
                'Wednesday' => 'rabu',
                'Thursday' => 'kamis',
                'Friday' => 'jumat',
                'Saturday' => 'sabtu'
            ];
            $todayIndonesian = $dayMapping[$today] ?? 'minggu';

            $jadwalHariIni = DB::table('jadwal')
                ->where('hari', $todayIndonesian)
                ->orderBy('waktu')
                ->get();

            return response()->json([
                'success' => true,
                'message' => 'Jadwal hari ini berhasil diambil',
                'data' => $jadwalHariIni
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil jadwal hari ini: ' . $e->getMessage()
            ], 500);
        }
    }

    // Get reservasi terbaru (5 terakhir)
    public function getReservasiTerbaru($email)
    {
        try {
            $reservasiTerbaru = DB::table('reservasi as r')
                ->leftJoin('jadwal as j', 'r.schedule_id', '=', 'j.schedule_id')
                ->where('r.email', $email)
                ->select([
                    'r.id',
                    'r.nama',
                    'r.keluhan',
                    'r.status',
                    'j.nama as nama_dokter',
                    'j.poli',
                    'j.hari',
                    'j.waktu',
                    'r.created_at'
                ])
                ->orderBy('r.created_at', 'desc')
                ->limit(5)
                ->get();

            return response()->json([
                'success' => true,
                'message' => 'Reservasi terbaru berhasil diambil',
                'data' => $reservasiTerbaru
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil reservasi terbaru: ' . $e->getMessage()
            ], 500);
        }
    }

    // Get hasil reservasi terbaru (3 terakhir)
    public function getHasilReservasiTerbaru($email)
    {
        try {
            $hasilTerbaru = DB::table('hasil_reservasi')
                ->where('email', $email)
                ->select([
                    'id',
                    'diagnosis',
                    'obat',
                    'created_at'
                ])
                ->orderBy('created_at', 'desc')
                ->limit(3)
                ->get();

            return response()->json([
                'success' => true,
                'message' => 'Hasil reservasi terbaru berhasil diambil',
                'data' => $hasilTerbaru
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil hasil reservasi terbaru: ' . $e->getMessage()
            ], 500);
        }
    }
}
```

## Testing API Routes

### 1. Test dengan Postman atau Browser

```bash
# Test reservasi data
GET http://192.168.18.232:8000/api/pasien/reservasi/requin@gmail.com

# Test jadwal dokter
GET http://192.168.18.232:8000/api/jadwal-dokter

# Test hasil reservasi
GET http://192.168.18.232:8000/api/pasien/hasil-reservasi/requin@gmail.com

# Test dashboard stats
GET http://192.168.18.232:8000/api/pasien/dashboard-stats/requin@gmail.com
```

### 2. Expected Response Format

```json
{
  "success": true,
  "message": "Data berhasil diambil",
  "data": [
    {
      "id": 1,
      "email": "requin@gmail.com",
      "nama": "apri",
      "umur": 17,
      "kelamin": "Laki-laki",
      "nomor_hp": "089797878776",
      "alamat": "sini lah~",
      "schedule_id": 1,
      "keluhan": "saya demam",
      "status": "sudah",
      "nama_dokter": "DR. Tohir Arsyad Romadhon",
      "poli": "umum",
      "hari": "minggu",
      "waktu": "07:00:00",
      "created_at": "2025-07-27T21:13:42.000000Z"
    }
  ]
}
```

## Troubleshooting

### 1. CORS Issues

Jika ada masalah CORS, tambahkan middleware CORS di Laravel:

```php
// config/cors.php
return [
    'paths' => ['api/*'],
    'allowed_methods' => ['*'],
    'allowed_origins' => ['*'],
    'allowed_origins_patterns' => [],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => false,
];
```

### 2. Database Connection

Pastikan koneksi database Laravel sudah benar dan tabel-tabel sudah ada sesuai dengan struktur database yang diberikan.

### 3. Carbon Package

Pastikan package Carbon sudah terinstall:

```bash
composer require nesbot/carbon
```

## Catatan Penting

1. **Email Parameter**: API menggunakan email sebagai parameter untuk mengidentifikasi pasien
2. **Error Handling**: Semua endpoint memiliki error handling yang konsisten
3. **Response Format**: Semua response menggunakan format yang sama dengan `success`, `message`, dan `data`
4. **Database Joins**: Menggunakan LEFT JOIN untuk menghubungkan tabel reservasi dengan jadwal dokter
5. **Date Formatting**: Menggunakan Carbon untuk konversi hari dalam bahasa Indonesia
