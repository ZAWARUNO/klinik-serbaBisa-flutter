import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/auth_theme.dart';
import '../../constants/assets.dart';
import '../services/dashboard_service.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../../widgets/appointment_dialog.dart';

class PatientDashboardScreen extends StatefulWidget {
  const PatientDashboardScreen({super.key});

  @override
  State<PatientDashboardScreen> createState() => _PatientDashboardScreenState();
}

class _PatientDashboardScreenState extends State<PatientDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _selectedIndex = 0;
  bool _isLoading = true;
  String _userEmail = '';

  // Notifications state
  DateTime? _notificationsLastSeenAt;
  bool _hasUnreadNotifications = false;
  List<NotificationItem> _notificationsCache = [];

  // Data from API
  List<ReservasiData> _reservasiData = [];
  // List<JadwalData> _jadwalData = [];
  List<HasilReservasiData> _hasilReservasiData = [];
  DashboardStats? _dashboardStats;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
    _animationController.forward();

    // Load dashboard data
    _loadDashboardData();
    // Load notifications state (badge)
    _loadNotificationState();
  }

  // Load dashboard data from API
  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get current user email from SharedPreferences
      final userEmail = await UserService.getUserEmail();

      if (userEmail == null) {
        setState(() {
          _errorMessage =
              'Tidak dapat menemukan data user. Silakan login ulang.';
          _isLoading = false;
        });
        return;
      }

      _userEmail = userEmail;
      print('🔍 Loading dashboard data for user: $_userEmail');

      // Load all data concurrently
      final results = await Future.wait([
        DashboardService.getReservasiData(_userEmail),
        DashboardService.getHasilReservasi(_userEmail),
        DashboardService.getDashboardStats(_userEmail),
      ]);

      if (mounted) {
        setState(() {
          if (results[0].success) {
            _reservasiData = results[0].reservasiData ?? [];
          }
          if (results[1].success) {
            _hasilReservasiData = results[1].hasilReservasiData ?? [];
          }
          if (results[2].success) {
            _dashboardStats = results[2].dashboardStats;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal memuat data: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('PatientDashboardScreen built successfully');
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(isMobile),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: _buildBody(isMobile),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isMobile) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      automaticallyImplyLeading: false, // Menghapus tombol kembali
      title: Row(
        children: [
          SizedBox(
            height: 40,
            width: 120,
            child: Image.asset(
              Assets.logoTransparant,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                    color: AuthTheme.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Klinik SerbaBisa',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          if (!isMobile) ...[
            _buildNotificationIcon(),
            const SizedBox(width: 16),
            _buildProfileSection(),
          ],
        ],
      ),
      actions: isMobile
          ? [
              _buildNotificationIcon(),
              const SizedBox(width: 8),
              _buildProfileSection(),
            ]
          : null,
    );
  }

  Widget _buildNotificationIcon() {
    return Stack(
      children: [
        IconButton(
          onPressed: () {
            _showNotifications();
          },
          icon: const Icon(Icons.notifications_outlined),
          color: Colors.grey[600],
        ),
        if (_hasUnreadNotifications)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProfileSection() {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: AuthTheme.primaryColor,
          child: const Icon(Icons.person, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Selamat Datang',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
            Text(
              _reservasiData.isNotEmpty ? _reservasiData.first.nama : 'Pasien',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            _showProfileMenu();
          },
          icon: const Icon(Icons.arrow_drop_down),
          color: Colors.grey[600],
        ),
      ],
    );
  }

  Widget _buildBody(bool isMobile) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF059669)),
            ),
            SizedBox(height: 16),
            Text(
              'Memuat data dashboard...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Gagal memuat data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadDashboardData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      color: const Color(0xFF059669),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            const SizedBox(height: 24),
            _buildQuickActions(isMobile),
            const SizedBox(height: 24),
            _buildAppointmentsSection(),
            const SizedBox(height: 24),
            _buildMedicalRecordsSection(),
            const SizedBox(height: 24),
            _buildStatisticsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF059669), Color(0xFF10B981)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.medical_services,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selamat Datang di Dashboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Kelola kesehatan Anda dengan mudah',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard(
                (_dashboardStats?.totalReservasi ?? 0).toString(),
                'Janji Temu',
                Icons.calendar_today,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                (_dashboardStats?.totalHasilReservasi ?? 0).toString(),
                'Riwayat Medis',
                Icons.medical_information,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                (_dashboardStats?.jadwalHariIni ?? 0).toString(),
                'Jadwal Hari Ini',
                Icons.schedule,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String number, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 8),
            Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(bool isMobile) {
    final actions = [
      {
        'title': 'Buat Janji',
        'icon': Icons.add_circle_outline,
        'color': Colors.blue,
        'onTap': () => _showAppointmentDialog(),
      },
      {
        'title': 'Riwayat Medis',
        'icon': Icons.history,
        'color': Colors.green,
        'onTap': () => _showMedicalHistory(initialTabIndex: 0),
      },
      {
        'title': 'Resep Obat',
        'icon': Icons.medication,
        'color': Colors.orange,
        'onTap': () => _showMedicalHistory(initialTabIndex: 1),
      },
      {
        'title': 'Konsultasi',
        'icon': Icons.chat,
        'color': Colors.purple,
        'onTap': () => _showConsultation(),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aksi Cepat',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 2 : 4,
            childAspectRatio: 1.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return _buildActionCard(action);
          },
        ),
      ],
    );
  }

  Widget _buildActionCard(Map<String, dynamic> action) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: action['onTap'],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: action['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(action['icon'], color: action['color'], size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  action['title'],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Janji Temu Terbaru',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: () => _showAllAppointments(),
              child: const Text(
                'Lihat Semua',
                style: TextStyle(
                  color: Color(0xFF059669),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_reservasiData.isEmpty)
          _buildEmptyState(
            'Belum ada janji temu',
            'Buat janji temu pertama Anda sekarang',
            Icons.calendar_today,
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _reservasiData.length,
            itemBuilder: (context, index) {
              return _buildReservasiCard(_reservasiData[index]);
            },
          ),
      ],
    );
  }

  Widget _buildReservasiCard(ReservasiData reservasi) {
    final status = reservasi.status;
    final statusColor = status == 'sudah' ? Colors.green : Colors.orange;
    final statusText = status == 'sudah' ? 'Selesai' : 'Menunggu';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AuthTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.calendar_today,
                color: AuthTheme.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reservasi.namaDokter ?? 'Dokter Umum',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reservasi.poli ?? 'Poli Umum',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${reservasi.hari ?? 'N/A'} • ${reservasi.waktu ?? 'N/A'}',
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalRecordsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Riwayat Medis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: () => _showAllMedicalRecords(),
              child: const Text(
                'Lihat Semua',
                style: TextStyle(
                  color: Color(0xFF059669),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_hasilReservasiData.isEmpty)
          _buildEmptyState(
            'Belum ada riwayat medis',
            'Riwayat medis akan muncul setelah konsultasi',
            Icons.medical_information,
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _hasilReservasiData.length,
            itemBuilder: (context, index) {
              return _buildHasilReservasiCard(_hasilReservasiData[index]);
            },
          ),
      ],
    );
  }

  Widget _buildHasilReservasiCard(HasilReservasiData hasil) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.medical_information,
                    color: Colors.blue,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasil.diagnosis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Hasil Konsultasi',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${hasil.createdAt.day}/${hasil.createdAt.month}/${hasil.createdAt.year}',
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Obat:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hasil.obat,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF334155)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistik Kesehatan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatisticItem(
                  '${_dashboardStats?.totalReservasi ?? 0}',
                  'Konsultasi',
                  Icons.medical_services,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatisticItem(
                  '${_dashboardStats?.totalHasilReservasi ?? 0}',
                  'Hasil',
                  Icons.medication,
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticItem(
    String number,
    String label,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          number,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            _handleNavigation(index);
          },
          selectedItemColor: AuthTheme.primaryColor,
          unselectedItemColor: Colors.grey[600],
          backgroundColor: Colors.white,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today),
              label: 'Janji Temu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.medical_information_outlined),
              activeIcon: Icon(Icons.medical_information),
              label: 'Riwayat Medis',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0: // Dashboard
        // Sudah di dashboard, tidak perlu navigasi
        break;
      case 1: // Janji Temu
        _showAppointmentDialog();
        break;
      case 2: // Riwayat Medis
        _showMedicalHistory();
        break;
      case 3: // Profil
        _showProfileMenu();
        break;
    }
  }

  // Action methods
  Future<void> _showNotifications() async {
    if (_userEmail.isEmpty) {
      final email = await UserService.getUserEmail();
      if (email != null) _userEmail = email;
    }

    final result = await DashboardService.getNotifications(_userEmail);
    final notifications = result.notifications ?? [];
    _notificationsCache = notifications;
    _computeUnreadFrom(notifications);

    bool showUnreadOnly = false;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => StatefulBuilder(
          builder: (context, setSheetState) {
            List<NotificationItem> filtered = notifications.where((n) {
              if (!showUnreadOnly) return true;
              return _isNotificationUnread(n);
            }).toList();

            Widget listView = filtered.isEmpty
                ? Center(
                    child: _buildEmptyState(
                      showUnreadOnly
                          ? 'Tidak ada notifikasi baru'
                          : 'Tidak ada notifikasi',
                      'Anda akan menerima info terbaru di sini',
                      Icons.notifications_off,
                    ),
                  )
                : ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final n = filtered[index];
                      IconData icon;
                      Color color;
                      switch (n.type) {
                        case 'reservation':
                          icon = Icons.check_circle;
                          color = Colors.green;
                          break;
                        case 'result':
                          icon = Icons.description;
                          color = Colors.blue;
                          break;
                        case 'reminder':
                          icon = Icons.alarm;
                          color = Colors.orange;
                          break;
                        default:
                          icon = Icons.notifications;
                          color = const Color(0xFF059669);
                      }
                      final time = _formatDateShort(n.createdAt);
                      return _buildNotificationItem(
                        icon: icon,
                        color: color,
                        title: n.title,
                        subtitle: n.subtitle,
                        time: time,
                      );
                    },
                  );

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.notifications,
                          color: Color(0xFF059669),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Notifikasi',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF059669),
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Muat ulang',
                          onPressed: () async {
                            final r = await DashboardService.getNotifications(
                              _userEmail,
                            );
                            final fresh = r.notifications ?? [];
                            setState(() {
                              _notificationsCache = fresh;
                            });
                            setSheetState(() {});
                            _computeUnreadFrom(fresh);
                          },
                          icon: const Icon(Icons.refresh),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Tutup'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        ChoiceChip(
                          label: const Text('Semua'),
                          selected: !showUnreadOnly,
                          onSelected: (_) =>
                              setSheetState(() => showUnreadOnly = false),
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Belum Dibaca'),
                          selected: showUnreadOnly,
                          onSelected: (_) =>
                              setSheetState(() => showUnreadOnly = true),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(height: 1),
                  Expanded(
                    child: RefreshIndicator(
                      color: const Color(0xFF059669),
                      onRefresh: () async {
                        final r = await DashboardService.getNotifications(
                          _userEmail,
                        );
                        final fresh = r.notifications ?? [];
                        setState(() {
                          _notificationsCache = fresh;
                        });
                        setSheetState(() {});
                        _computeUnreadFrom(fresh);
                      },
                      child: listView,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    // Mark as seen when modal closed
    await _markNotificationsAsSeen();
  }

  // Helpers for notifications state
  String get _notifLastSeenKey =>
      'notif_last_seen_${_userEmail.isEmpty ? 'guest' : _userEmail}';

  Future<void> _loadNotificationState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ts = prefs.getString(_notifLastSeenKey);
      setState(() {
        _notificationsLastSeenAt = ts != null ? DateTime.tryParse(ts) : null;
      });
      if (_userEmail.isNotEmpty) {
        final result = await DashboardService.getNotifications(_userEmail);
        _notificationsCache = result.notifications ?? [];
        _computeUnreadFrom(_notificationsCache);
      }
    } catch (_) {}
  }

  void _computeUnreadFrom(List<NotificationItem> list) {
    final lastSeen = _notificationsLastSeenAt;
    bool hasUnread = false;
    if (lastSeen == null) {
      hasUnread = list.isNotEmpty;
    } else {
      for (final n in list) {
        if (n.createdAt.isAfter(lastSeen)) {
          hasUnread = true;
          break;
        }
      }
    }
    if (mounted) {
      setState(() {
        _hasUnreadNotifications = hasUnread;
      });
    }
  }

  bool _isNotificationUnread(NotificationItem n) {
    final lastSeen = _notificationsLastSeenAt;
    if (lastSeen == null) return true;
    return n.createdAt.isAfter(lastSeen);
  }

  Future<void> _markNotificationsAsSeen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final nowIso = DateTime.now().toIso8601String();
      await prefs.setString(_notifLastSeenKey, nowIso);
      if (mounted) {
        setState(() {
          _notificationsLastSeenAt = DateTime.parse(nowIso);
          _hasUnreadNotifications = false;
        });
      }
    } catch (_) {}
  }

  String _formatDateShort(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileMenu() async {
    // Get current user data
    final userData = await UserService.getUserData();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header dengan drag indicator
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header
                  Row(
                    children: [
                      const Icon(Icons.person, color: Color(0xFF059669)),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Profil Saya',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Profile Info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: const Color(0xFF059669),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          userData?.nama ?? 'User',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF374151),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          userData?.email ?? 'user@email.com',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildProfileInfoRow(
                          'Umur',
                          '${userData?.umur ?? 0} tahun',
                        ),
                        _buildProfileInfoRow(
                          'Jenis Kelamin',
                          userData?.kelamin ?? '-',
                        ),
                        _buildProfileInfoRow(
                          'No. Telepon',
                          userData?.nomorHp ?? '-',
                        ),
                        _buildProfileInfoRow('Alamat', userData?.alamat ?? '-'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Menu Options
                  Column(
                    children: [
                      _buildProfileMenuItem(
                        icon: Icons.edit,
                        title: 'Edit Profil',
                        subtitle: 'Ubah informasi pribadi',
                        onTap: () async {
                          Navigator.pop(context);
                          await _showEditProfile();
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildProfileMenuItem(
                        icon: Icons.medical_information,
                        title: 'Riwayat Medis',
                        subtitle: 'Lihat riwayat kesehatan',
                        onTap: () {
                          Navigator.pop(context);
                          _showMedicalHistory();
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildProfileMenuItem(
                        icon: Icons.logout,
                        title: 'Keluar',
                        subtitle: 'Logout dari aplikasi',
                        onTap: () {
                          Navigator.pop(context);
                          _logout();
                        },
                        isDestructive: true,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(': ', style: TextStyle(fontSize: 14, color: Colors.grey)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF374151),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDestructive ? Colors.red[200]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDestructive
                        ? Colors.red[50]
                        : const Color(0xFF059669).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: isDestructive ? Colors.red : const Color(0xFF059669),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDestructive
                              ? Colors.red
                              : const Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDestructive
                              ? Colors.red[400]
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: isDestructive ? Colors.red[400] : Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAppointmentDialog() {
    AppointmentDialog.show(context);
  }

  // Removed unused _buildFormField

  void _showMedicalHistory({int initialTabIndex = 0}) {
    int activeTabIndex = initialTabIndex.clamp(
      0,
      1,
    ); // 0: Riwayat Medis, 1: Resep Obat
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    const Icon(
                      Icons.medical_information,
                      color: Color(0xFF059669),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Riwayat Medis',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF059669),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Tabs (hapus Hasil Lab)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTabButton(
                          'Riwayat Medis',
                          activeTabIndex == 0,
                          () => setModalState(() => activeTabIndex = 0),
                        ),
                      ),
                      Expanded(
                        child: _buildTabButton(
                          'Resep Obat',
                          activeTabIndex == 1,
                          () => setModalState(() => activeTabIndex = 1),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Content berdasarkan tab
                Expanded(
                  child: activeTabIndex == 0
                      ? ListView.builder(
                          controller: scrollController,
                          itemCount: _hasilReservasiData.length,
                          itemBuilder: (context, index) {
                            final hasil = _hasilReservasiData[index];
                            return _buildHasilReservasiCard(hasil);
                          },
                        )
                      : _buildPrescriptionsList(scrollController),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF059669) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey[600],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildPrescriptionsList(ScrollController scrollController) {
    if (_hasilReservasiData.isEmpty) {
      return ListView(
        controller: scrollController,
        children: [
          _buildEmptyState(
            'Belum ada resep obat',
            'Resep obat akan muncul setelah konsultasi',
            Icons.medication,
          ),
        ],
      );
    }

    return ListView.separated(
      controller: scrollController,
      itemCount: _hasilReservasiData.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final hasil = _hasilReservasiData[index];
        return _buildPrescriptionCard(hasil);
      },
    );
  }

  Widget _buildPrescriptionCard(HasilReservasiData hasil) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.medication,
                    color: Colors.orange,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Resep Obat',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Text(
                  '${hasil.createdAt.day}/${hasil.createdAt.month}/${hasil.createdAt.year}',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (hasil.diagnosis.isNotEmpty) ...[
              Text(
                'Diagnosis',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                hasil.diagnosis,
                style: TextStyle(fontSize: 13, color: Colors.grey[800]),
              ),
              const SizedBox(height: 12),
            ],
            Text(
              'Obat',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Text(
                hasil.obat,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[800],
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (hasil.edukasiSaran.isNotEmpty) ...[
              Text(
                'Edukasi & Saran',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                hasil.edukasiSaran,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[800],
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Removed unused _showPrescriptions (gunakan _showMedicalHistory(initialTabIndex: 1))

  void _showConsultation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Membuka konsultasi...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showAllAppointments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Color(0xFF059669)),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Semua Janji Temu',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF059669),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _reservasiData.isEmpty
                    ? ListView(
                        controller: scrollController,
                        children: [
                          _buildEmptyState(
                            'Belum ada janji temu',
                            'Buat janji temu pertama Anda sekarang',
                            Icons.calendar_today,
                          ),
                        ],
                      )
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: _reservasiData.length,
                        itemBuilder: (context, index) =>
                            _buildReservasiCard(_reservasiData[index]),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAllMedicalRecords() {
    _showMedicalHistory(initialTabIndex: 0);
  }

  void _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog

              // Clear user data
              await UserService.clearUserData();

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logout berhasil'),
                  backgroundColor: Colors.green,
                ),
              );

              // Navigate to login screen
              Navigator.pushReplacementNamed(context, '/auth/login');
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditProfile() async {
    final userData = await UserService.getUserData();
    if (userData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data pengguna tidak ditemukan')),
      );
      return;
    }

    final TextEditingController namaCtrl = TextEditingController(
      text: userData.nama,
    );
    final TextEditingController umurCtrl = TextEditingController(
      text: userData.umur.toString(),
    );
    final TextEditingController nomorHpCtrl = TextEditingController(
      text: userData.nomorHp,
    );
    final TextEditingController alamatCtrl = TextEditingController(
      text: userData.alamat,
    );
    String kelaminValue = _normalizeKelaminToShort(
      userData.kelamin,
    ); // 'L' / 'P'

    final formKey = GlobalKey<FormState>();
    bool isSubmitting = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.8,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) => SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.edit, color: Color(0xFF059669)),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Edit Profil',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF059669),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildInput(
                        'Nama Lengkap',
                        namaCtrl,
                        Icons.person,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Nama wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      _buildNumberInput(
                        'Umur',
                        umurCtrl,
                        Icons.cake,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty)
                            return 'Umur wajib diisi';
                          final n = int.tryParse(v);
                          if (n == null || n <= 0) return 'Umur tidak valid';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildKelaminPicker(
                        label: 'Jenis Kelamin',
                        value: kelaminValue,
                        onChanged: (val) =>
                            setSheetState(() => kelaminValue = val ?? 'L'),
                      ),
                      const SizedBox(height: 12),
                      _buildInput(
                        'No. Telepon',
                        nomorHpCtrl,
                        Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'No. Telepon wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      _buildMultilineInput(
                        'Alamat',
                        alamatCtrl,
                        Icons.location_on,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Alamat wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFF059669),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Batal',
                                style: TextStyle(
                                  color: Color(0xFF059669),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isSubmitting
                                  ? null
                                  : () async {
                                      if (!(formKey.currentState?.validate() ??
                                          false))
                                        return;
                                      setSheetState(() => isSubmitting = true);
                                      final update =
                                          await AuthService.updateProfile(
                                            userId: userData.id,
                                            nama: namaCtrl.text.trim(),
                                            umur: int.parse(
                                              umurCtrl.text.trim(),
                                            ),
                                            kelamin:
                                                kelaminValue, // backend terima 'L'/'P' atau mapping sendiri
                                            nomorHp: nomorHpCtrl.text.trim(),
                                            alamat: alamatCtrl.text.trim(),
                                          );
                                      setSheetState(() => isSubmitting = false);
                                      if (update.success) {
                                        // Perbarui data lokal
                                        final updated =
                                            update.user ??
                                            UserData(
                                              id: userData.id,
                                              email: userData.email,
                                              nama: namaCtrl.text.trim(),
                                              umur: int.parse(
                                                umurCtrl.text.trim(),
                                              ),
                                              kelamin: kelaminValue,
                                              nomorHp: nomorHpCtrl.text.trim(),
                                              alamat: alamatCtrl.text.trim(),
                                            );
                                        await UserService.saveUserData(updated);
                                        if (mounted) {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(update.message),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        }
                                        // Refresh dashboard ringan
                                        if (mounted) _loadDashboardData();
                                      } else {
                                        if (mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(update.message),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF059669),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: isSubmitting
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : const Text(
                                      'Simpan Perubahan',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _normalizeKelaminToShort(String value) {
    final v = value.toLowerCase();
    if (v.startsWith('l')) return 'L';
    if (v.startsWith('p')) return 'P';
    // fallback
    return (value == 'L' || value == 'P') ? value : 'L';
  }

  Widget _buildInput(
    String label,
    TextEditingController controller,
    IconData icon, {
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType ?? TextInputType.text,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF059669)),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF059669)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberInput(
    String label,
    TextEditingController controller,
    IconData icon, {
    String? Function(String?)? validator,
  }) {
    return _buildInput(
      label,
      controller,
      icon,
      validator: validator,
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildMultilineInput(
    String label,
    TextEditingController controller,
    IconData icon, {
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: 3,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF059669)),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF059669)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKelaminPicker({
    required String label,
    required String value, // 'L'/'P'
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.wc, color: Color(0xFF059669)),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF059669)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
          ),
          items: const [
            DropdownMenuItem(value: 'L', child: Text('Laki-laki')),
            DropdownMenuItem(value: 'P', child: Text('Perempuan')),
          ],
        ),
      ],
    );
  }
}
