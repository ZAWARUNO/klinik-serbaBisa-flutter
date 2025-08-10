-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Aug 07, 2025 at 08:28 AM
-- Server version: 8.0.30
-- PHP Version: 8.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `klinik-serbabisa`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `nomor` int NOT NULL,
  `nama_admin` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`nomor`, `nama_admin`, `email`, `password`) VALUES
(1, 'apri', 'apriansyah@gmail.com', '123456');

-- --------------------------------------------------------

--
-- Table structure for table `data`
--

CREATE TABLE `data` (
  `nomor` int NOT NULL,
  `email` varchar(255) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `umur` varchar(3) NOT NULL,
  `kelamin` char(1) NOT NULL,
  `nomor_hp` varchar(20) NOT NULL,
  `alamat` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `data`
--

INSERT INTO `data` (`nomor`, `email`, `nama`, `umur`, `kelamin`, `nomor_hp`, `alamat`, `password`) VALUES
(8, 'requin@gmail.com', 'apri', '17', 'L', '089797878776', 'sini lah~', '$2y$10$/Zgiy.s7Dmv4XRJ2trCkfesSX4hGOEg2BjaaPOWcFN708NVj2Vnr.'),
(9, 'aannunaah4@gmail.com', 'tyt0orru', '18', 'P', '089909999999', 'disini dibatas kote ini ingin kutuliskan kenangan untuk mu disini dibatas kote ini ingin kutuliskan kenangan untuk mu~~', '25d55ad283aa400af464c76d713c07ad'),
(10, 'anunah42@gmail.com', 'yoru', '18', 'L', '089797878776', 'disini dibatas kote ini ingin kutuliskan kenangan untuk mu disini dibatas kote ini ingin kutuliskan kenangan untuk mu', '12345678'),
(11, 'anunah43@gmail.com', 'rapi', '23', 'L', '089797878776', 'paris perancis', '12345678'),
(12, 'anunah433@gmail.com', 'rapi', '23', 'L', '089797878776', 'paris perancis', '12345678'),
(13, 'anunah43w3@gmail.com', 'rapi', '23', 'L', '089797878776', 'paris perancis', '12345678'),
(14, 'nugrahaabisantana@gmail.com', 'Nugraha abi Santana', '17', 'L', '0895320904623', 'Perumahan Griya darussalam\r\nbluk c.7', '12345678'),
(15, 'apri@gmail.com', 'apri', '27', 'L', '0821569808', 'jadi gini terus gini.terus.gitu', '$2y$12$YSpRRZH1UV3AVYTptSXaDeleJc6dyZyl6wfjj.6l.y5/y0DUt/fs.');

-- --------------------------------------------------------

--
-- Table structure for table `dokter`
--

CREATE TABLE `dokter` (
  `dokter_id` int NOT NULL,
  `nama_dokter` varchar(255) NOT NULL,
  `poli` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `dokter`
--

INSERT INTO `dokter` (`dokter_id`, `nama_dokter`, `poli`, `password`) VALUES
(1, 'DR. Tohir Arsyad Romadhon', 'umum', '$2y$12$WRA6TNNjr75XzdJhKA7Z6OcmmwpqSXK/Pt1YMzCtseB7n3vWSc3cu'),
(3, 'Dr. Izzati Al Fahwas', 'Dokter Anak', '$2y$12$yvokUVWLKbpjFYrzKi4pVOHefMMDJo10LXofYQdirwLTLQprDZIZ.'),
(4, 'Dr. El Prans sakyono', 'Dokter Kehamilan', '12345678'),
(5, 'Dr. Akhmad Akhnaf', 'Psikolog', '$2y$12$hwTAaVzGA3FLjwSDkzq3O.FGjQx9Hn6SQNQcbgpCAUCW7A73dqbau'),
(6, 'Dr. Fahrel Djayantara', 'Dokter Mata', '12345678');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hasil_reservasi`
--

CREATE TABLE `hasil_reservasi` (
  `id` bigint UNSIGNED NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nama` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `umur` int NOT NULL,
  `kelamin` enum('L','P') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ringkasan_anamnesis` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `pemeriksaan_fisik` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `diagnosis` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `obat` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tindakan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `edukasi_saran` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `dokter_id` int NOT NULL,
  `nama_dokter` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `poli_dokter` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `hasil_reservasi`
--

INSERT INTO `hasil_reservasi` (`id`, `email`, `nama`, `umur`, `kelamin`, `ringkasan_anamnesis`, `pemeriksaan_fisik`, `diagnosis`, `obat`, `tindakan`, `edukasi_saran`, `dokter_id`, `nama_dokter`, `poli_dokter`, `created_at`, `updated_at`) VALUES
(2, 'nugrahaabisantana@gmail.com', 'Nugraha abi Santana', 17, 'L', 'Seorang remaja laki-laki bernama Nugraha Abi Santana, berusia 17 tahun, datang ke klinik dengan keluhan demam sejak satu hari yang lalu. Nugraha mengeluhkan suhu tubuhnya meningkat hingga sekitar 38,5°C. Ia tidak mengalami muntah atau diare, hanya merasa agak lemas dan nafsu makannya sedikit menurun. Ia tidak memiliki riwayat kejang demam sebelumnya dan tidak diketahui memiliki alergi obat. Nugraha juga menyampaikan bahwa ia tidak memiliki kontak dengan orang yang sedang menderita penyakit infeksi berat dalam beberapa hari terakhir.', 'Pada pemeriksaan fisik, suhu tubuh Nugraha tercatat sebesar 38,7°C. Denyut nadinya 100 kali per menit, pernapasan 20 kali per menit, dan tekanan darah 110/70 mmHg. Secara umum, Nugraha tampak lemas ringan namun tetap sadar penuh dan responsif. Pemeriksaan tenggorokan menunjukkan adanya kemerahan ringan tanpa adanya bercak putih. Bunyi napas terdengar normal, tidak ada tanda sesak napas, dan pemeriksaan perut juga tidak menunjukkan kelainan.', 'Berdasarkan keluhan dan hasil pemeriksaan fisik, dokter menegakkan diagnosis demam ringan kemungkinan disebabkan oleh infeksi virus, seperti faringitis ringan atau flu biasa. Tidak ada tanda-tanda infeksi bakteri, pneumonia, atau dehidrasi yang berat.', 'Dokter meresepkan paracetamol tablet sebagai penurun panas, dengan dosis sesuai berat badan dan dapat diminum setiap 6–8 jam jika dibutuhkan. Selain itu, Nugraha juga diberikan suplemen vitamin C untuk membantu memperkuat daya tahan tubuhnya.', 'Dokter menganjurkan agar Nugraha melakukan kompres hangat pada dahi dan ketiak jika demam masih tinggi, serta memastikan ia cukup minum air putih agar tidak dehidrasi. Istirahat yang cukup juga sangat dianjurkan.', 'Dokter menjelaskan bahwa demam ringan seperti ini biasanya akan mereda dalam 2–3 hari. Nugraha disarankan untuk meminum obat penurun panas jika suhu tubuhnya mencapai 38°C atau lebih. Ia juga diimbau untuk tidak mengenakan pakaian atau selimut terlalu tebal. Apabila muncul tanda-tanda bahaya seperti kejang, sesak napas, muntah terus-menerus, atau demam yang tidak kunjung turun setelah tiga hari, maka ia harus segera kembali ke klinik atau mendatangi unit gawat darurat. Dokter menutup sesi konsultasi dengan menekankan pentingnya istirahat total dan menjaga asupan cairan.', 5, 'Dr. Akhmad Akhnaf', 'Psikolog', '2025-07-28 21:28:50', '2025-07-28 21:28:50'),
(3, 'requin@gmail.com', 'apri', 17, 'L', 'davfbe', 'dbfdeer', 'dfberb', 'fgrefs', 'dbder', 'bgbterbrht', 3, 'Dr. Izzati Al Fahwas', 'Dokter Anak', '2025-07-28 22:57:49', '2025-07-28 22:57:49'),
(4, 'requin@gmail.com', 'apri', 17, 'L', 'shhhdhhhhh', 'dsbvjdbsjvks', 'svaefbrds', 'trbdgnr', 'dbsdf', 'dbgfdfh', 3, 'Dr. Izzati Al Fahwas', 'Dokter Anak', '2025-07-28 22:58:32', '2025-07-28 22:58:32'),
(5, 'apri@gmail.com', 'apri', 27, 'L', 'jadi ini bapak udah gak panjang lagi kalo mau panjang terpaksa langganan upin ipin univers', 'sehat cuman kurang seimbang karena tangan kanan nya besar sebelah', 'kurang kasih sayang', 'uang tunai 100 RB', 'males bertindak tanpa money', 'banyak banyakin bergaul yah', 1, 'DR. Tohir Arsyad Romadhon', 'umum', '2025-08-06 21:24:14', '2025-08-06 21:24:14');

-- --------------------------------------------------------

--
-- Table structure for table `jadwal`
--

CREATE TABLE `jadwal` (
  `schedule_id` int NOT NULL,
  `nama` varchar(255) NOT NULL,
  `poli` varchar(100) NOT NULL,
  `hari` varchar(8) NOT NULL,
  `waktu` time NOT NULL,
  `maximal_reservasi` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `jadwal`
--

INSERT INTO `jadwal` (`schedule_id`, `nama`, `poli`, `hari`, `waktu`, `maximal_reservasi`) VALUES
(1, 'DR. Tohir Arsyad Romadhon', 'umum', 'minggu', '07:00:00', 20),
(2, 'DR. Tohir Arsyad Romadhon', 'umum', 'selasa', '09:30:00', 20),
(3, 'DR. Tohir Arsyad Romadhon', 'umum', 'kamis', '09:30:00', 20),
(4, 'DR. Tohir Arsyad Romadhon', 'umum', 'jumat', '09:30:00', 20),
(5, 'DR. Tohir Arsyad Romadhon', 'umum', 'sabtu', '07:00:00', 20),
(6, 'Dr. Izzati Al Fahwas', 'anak', 'senin', '09:30:00', 25),
(7, 'Dr. Izzati Al Fahwas', 'anak', 'rabu', '07:00:00', 25),
(8, 'Dr. Izzati Al Fahwas', 'anak', 'jumat', '07:00:00', 25),
(9, 'Dr. El Prans sakyono', 'kehamilan', 'senin', '09:30:00', 10),
(11, 'Dr. El Prans sakyono', 'kehamilan', 'rabu', '09:30:00', 10),
(12, 'Dr. El Prans sakyono', 'kehamilan', 'kamis', '09:30:00', 10),
(13, 'Dr. El Prans sakyono', 'kehamilan', 'jumat', '09:30:00', 10),
(14, 'Dr. El Prans sakyono', 'kehamilan', 'sabtu', '09:30:00', 10),
(16, 'Dr. Akhmad Akhnaf', 'psikolog', 'sabtu', '07:00:00', 30),
(17, 'Dr. Akhmad Akhnaf', 'psikolog', 'minggu', '07:00:00', 30),
(19, 'Dr. Fahrel Djayantara', 'mata', 'senin', '09:30:00', 15),
(20, 'Dr. Fahrel Djayantara', 'mata', 'selasa', '07:00:00', 18),
(21, 'Dr. Fahrel Djayantara', 'mata', 'rabu', '09:30:00', 15),
(22, 'Dr. Fahrel Djayantara', 'mata', 'kamis', '07:00:00', 18);

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(9, '2014_10_12_000000_create_users_table', 1),
(10, '2014_10_12_100000_create_password_reset_tokens_table', 1),
(11, '2019_08_19_000000_create_failed_jobs_table', 1),
(12, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(13, '2025_07_17_065814_create_reservations_table', 1),
(14, '2025_07_26_034022_add_patient_id_to_reservasi_table', 2),
(15, '2025_07_26_034123_populate_patient_id_in_reservasi_table', 2),
(16, '2025_07_26_035127_add_patient_id_to_reservasi_table', 2),
(17, '2025_07_26_035140_populate_patient_id_in_reservasi_table', 2),
(20, '2025_07_26_042607_fix_existing_reservasi_data', 3),
(21, '2025_07_28_060734_create_hasil_reservasi_table', 3);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reservasi`
--

CREATE TABLE `reservasi` (
  `id` int NOT NULL,
  `patient_id` int DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `umur` int NOT NULL,
  `kelamin` enum('Laki-laki','Perempuan') NOT NULL,
  `nomor_hp` varchar(20) NOT NULL,
  `alamat` text NOT NULL,
  `schedule_id` int NOT NULL,
  `keluhan` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` enum('belum','sudah') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'belum'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `reservasi`
--

INSERT INTO `reservasi` (`id`, `patient_id`, `email`, `nama`, `umur`, `kelamin`, `nomor_hp`, `alamat`, `schedule_id`, `keluhan`, `created_at`, `updated_at`, `status`) VALUES
(5, 8, 'requin@gmail.com', 'apri', 17, 'Laki-laki', '089797878776', 'sini lah~', 9, 'udah 10 bulan', '2025-07-20 21:20:16', '2025-07-25 22:15:19', NULL),
(6, 8, 'requin@gmail.com', 'apri', 17, 'Laki-laki', '089797878776', 'sini lah~', 3, 'saya kurang makan pak', '2025-07-21 20:59:16', '2025-07-25 22:15:19', NULL),
(7, 8, 'requin@gmail.com', 'apri', 17, 'Laki-laki', '089797878776', 'sini lah~', 9, 'mau keluar dok AKKKKHHHHHH', '2025-07-21 21:04:04', '2025-07-25 22:15:19', NULL),
(8, 8, 'requin@gmail.com', 'apri', 17, 'Laki-laki', '089797878776', 'sini lah~', 1, 'TOHITRRRRRR', '2025-07-21 21:07:08', '2025-07-25 22:15:19', NULL),
(9, 8, 'requin@gmail.com', 'apri', 17, 'Laki-laki', '089797878776', 'sini lah~', 6, 'Anak saya suka darkcraft', '2025-07-21 21:25:05', '2025-07-25 22:15:19', 'sudah'),
(11, 8, 'requin@gmail.com', 'apri', 17, 'Laki-laki', '089797878776', 'sini lah~', 11, 'aku suka prana', '2025-07-22 20:15:47', '2025-07-25 22:15:19', 'sudah'),
(12, 8, 'requin@gmail.com', 'apri', 17, 'Laki-laki', '089797878776', 'sini lah~', 7, 'anak saya hobi main minecraft', '2025-07-22 20:18:47', '2025-07-25 22:15:19', 'belum'),
(13, 8, 'requin@gmail.com', 'apri', 17, 'Laki-laki', '089797878776', 'sini lah~', 1, 'testing', '2025-07-22 20:20:23', '2025-07-25 22:15:19', 'belum'),
(14, 8, 'requin@gmail.com', 'apri', 17, 'Laki-laki', '089797878776', 'sini lah~', 1, 'balabalsad', '2025-07-22 20:22:12', '2025-07-25 22:15:19', 'belum'),
(15, 8, 'requin@gmail.com', 'apri', 17, 'Laki-laki', '089797878776', 'sini lah~', 6, 'csefw', '2025-07-23 00:33:41', '2025-07-25 22:15:19', 'belum'),
(20, 8, 'requin@gmail.com', 'apri', 17, 'Laki-laki', '089797878776', 'sini lah~', 21, 'Anusbzn', '2025-07-24 00:55:45', '2025-07-25 22:15:19', 'belum'),
(22, 8, 'requin@gmail.com', 'apri', 17, 'Laki-laki', '089797878776', 'sini lah~', 7, 'swswsa', '2025-07-25 20:31:56', '2025-07-25 22:15:19', 'belum'),
(23, 8, 'requin@gmail.com', 'apri', 17, 'Laki-laki', '089797878776', 'sini lah~', 6, 'dadwdad', '2025-07-25 20:32:11', '2025-07-25 22:15:19', 'belum'),
(24, 8, 'requin@gmail.com', 'apri', 17, 'Laki-laki', '089797878776', 'sini lah~', 6, 'dadadwad', '2025-07-25 20:32:22', '2025-07-25 22:15:19', 'belum'),
(25, 8, 'requin@gmail.com', 'apri', 17, 'Laki-laki', '089797878776', 'sini lah~', 20, 'dadwdaw', '2025-07-25 20:32:53', '2025-07-25 22:15:19', 'sudah'),
(26, 8, 'requin@gmail.com', 'apri', 17, 'Laki-laki', '089797878776', 'sini lah~', 1, 'dawdad', '2025-07-25 21:19:16', '2025-07-25 22:15:19', 'belum'),
(27, 8, 'requin@gmail.com', 'apri', 17, 'Laki-laki', '089797878776', 'sini lah~', 1, 'adawdadawd', '2025-07-25 21:32:47', '2025-07-25 22:15:19', 'belum'),
(28, 8, 'requin@gmail.com', 'apri', 17, 'Laki-laki', '089797878776', 'sini lah~', 6, 'blabalabal', '2025-07-25 21:41:54', '2025-07-25 22:15:19', 'belum'),
(29, 8, 'requin@gmail.com', 'apri', 17, 'Laki-laki', '089797878776', 'sini lah~', 3, 'batuk berdahak', '2025-07-25 21:56:32', '2025-07-25 22:15:19', 'sudah'),
(30, 14, 'nugrahaabisantana@gmail.com', 'Nugraha abi Santana', 17, 'Laki-laki', '0895320904623', 'Perumahan Griya darussalam\r\nbluk c.7', 1, 'saya demam', '2025-07-27 21:13:42', '2025-07-28 00:45:06', 'sudah'),
(31, 15, 'apri@gmail.com', 'apri', 27, 'Laki-laki', '0821569808', 'jadi gini terus gini.terus.gitu', 1, 'testing apri', '2025-08-06 21:14:23', '2025-08-06 21:14:23', 'belum');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`nomor`);

--
-- Indexes for table `data`
--
ALTER TABLE `data`
  ADD PRIMARY KEY (`nomor`);

--
-- Indexes for table `dokter`
--
ALTER TABLE `dokter`
  ADD PRIMARY KEY (`dokter_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `hasil_reservasi`
--
ALTER TABLE `hasil_reservasi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `hasil_reservasi_email_created_at_index` (`email`,`created_at`);

--
-- Indexes for table `jadwal`
--
ALTER TABLE `jadwal`
  ADD PRIMARY KEY (`schedule_id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `reservasi`
--
ALTER TABLE `reservasi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `schedule_id` (`schedule_id`),
  ADD KEY `reservasi_patient_id_foreign` (`patient_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `nomor` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `data`
--
ALTER TABLE `data`
  MODIFY `nomor` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `dokter`
--
ALTER TABLE `dokter`
  MODIFY `dokter_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hasil_reservasi`
--
ALTER TABLE `hasil_reservasi`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `jadwal`
--
ALTER TABLE `jadwal`
  MODIFY `schedule_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reservasi`
--
ALTER TABLE `reservasi`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `reservasi`
--
ALTER TABLE `reservasi`
  ADD CONSTRAINT `reservasi_ibfk_1` FOREIGN KEY (`schedule_id`) REFERENCES `jadwal` (`schedule_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reservasi_patient_id_foreign` FOREIGN KEY (`patient_id`) REFERENCES `data` (`nomor`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
