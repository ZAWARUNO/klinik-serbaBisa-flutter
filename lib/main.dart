import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/auth/auth_routes.dart';
import 'screens/admin/admin_routes.dart';
import 'screens/auth/login_screen.dart';
import 'theme/auth_theme.dart';

void main() {
  runApp(const KlinikSerbaBisaApp());
}

class KlinikSerbaBisaApp extends StatelessWidget {
  const KlinikSerbaBisaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Klinik SerbaBisa',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        useMaterial3: true,
        fontFamily: 'Inter',

        colorScheme: ColorScheme.fromSeed(
          seedColor: AuthTheme.primaryColor,
          brightness: Brightness.light,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF374151),
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AuthTheme.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AuthTheme.borderRadius),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AuthTheme.borderRadius),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AuthTheme.borderRadius),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AuthTheme.borderRadius),
            borderSide: const BorderSide(
              color: AuthTheme.primaryColor,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        ...AuthRoutes.getRoutes(),
        ...AdminRoutes.getRoutes(),
      },
      onGenerateRoute: (settings) {
        final authRoute = AuthRoutes.onGenerateRoute(settings);
        if (authRoute != null) return authRoute;

        final adminRoute = AdminRoutes.onGenerateRoute(settings);
        if (adminRoute != null) return adminRoute;

        return MaterialPageRoute(builder: (context) => const HomePage());
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE0F7FA), // cyan-50
                Color(0xFFE3F2FD), // blue-50
              ],
            ),
          ),
          child: CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildHeroSection(),
                    _buildAboutSection(),
                    _buildServicesSection(),
                    _buildDoctorsSection(),
                    _buildFooter(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 60,
      toolbarHeight: 60,
      floating: true,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 2,
      automaticallyImplyLeading: false,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      flexibleSpace: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Logo
              Container(
                height: 40,
                width: 120,
                child: Image.asset(
                  'assets/images/logo_transparant_klinik.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 120,
                      height: 40,
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
              // Menu buttons
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AuthRoutes.login);
                    },
                    child: _buildMenuButton('Pasien', Colors.cyan, () {}),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AdminRoutes.adminLogin);
                    },
                    child: _buildMenuButton('Admin', Colors.green, () {}),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(String text, Color color, VoidCallback onPressed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          width: double.infinity,
          height: 350,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/banner.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(
                0xFF4ECDC4,
              ).withOpacity(0.8), // Overlay untuk readability
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sipaling Serba Bisa\nMelayani Kebutuhan\nKesehatanmu',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Layanan kesehatan terpadu dan terpercaya untuk Anda dan keluarga, dengan dokter profesional dan fasilitas modern.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Scroll ke section layanan
                    Scrollable.ensureVisible(
                      context
                          .findAncestorStateOfType<_HomePageState>()!
                          .context,
                      duration: const Duration(milliseconds: 500),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4ECDC4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Lihat Layanan Kami',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30),

        // Section kedua
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          child: const Column(
            children: [
              Text(
                'Sipaling Serba Bisa\nMemberi Layanan yang Kamu\nButuhkan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.teal, // Warna teal untuk section kedua
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        // Section ketiga - Kesehatan Anda Prioritas Kami
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: const Color(0xFF4ECDC4),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // Bagian gambar dengan overlay
              Container(
                width: double.infinity,
                height: 200,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/images/layanan-foto.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.cyan.withOpacity(
                      0.2,
                    ), // Overlay cyan dengan opacity 20%
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge di bagian bawah gambar
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Kesehatan Anda Prioritas Kami',
                            style: TextStyle(
                              color: Color(0xFF4ECDC4),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bagian teks di luar gambar (background teal)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Untuk Anda dan keluarga, Klinik SerbaBisa hadir memberikan solusi layanan kesehatan berkualitas, lengkap, dan terstandarisasi mulai dari layanan hingga konsultasi dengan tim pengalaman psikologi. Kami berkomitmen memberikan pelayanan terbaik untuk kesehatan optimal Anda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildServicesSection() {
    final services = [
      {'name': 'Umum', 'icon': Icons.medical_services},
      {'name': 'Gigi', 'icon': Icons.medication},
      {'name': 'Anak', 'icon': Icons.child_care},
      {'name': 'Vaksinasi', 'icon': Icons.vaccines},
      {'name': 'Kehamilan', 'icon': Icons.pregnant_woman},
      {'name': 'Laboratorium', 'icon': Icons.science},
      {'name': 'Apotek', 'icon': Icons.local_pharmacy},
      {'name': 'Psikologi', 'icon': Icons.psychology},
      {'name': 'Fisioterapi', 'icon': Icons.accessibility},
      {'name': 'Mata', 'icon': Icons.visibility},
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Layanan Kami:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return _buildServiceCard(service);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.cyan.shade300.withOpacity(0.7),
            Colors.teal.shade300.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            HapticFeedback.lightImpact();
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(service['icon'], size: 40, color: Colors.white),
                const SizedBox(height: 12),
                Text(
                  service['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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

  Widget _buildDoctorsSection() {
    final doctors = [
      {
        'name': 'DR. Tohir Arsyad Romadhon',
        'specialty': 'Dokter Umum',
        'experience': '15+ Tahun',
        'color': Colors.blue,
        'image': 'assets/images/dokter-tohir.png',

        'schedule': {
          'Minggu': '07:00',
          'Senin': null,
          'Selasa': '09:30',
          'Rabu': null,
          'Kamis': '09:30',
          'Jumat': '09:30',
          'Sabtu': '07:00',
        },
      },
      {
        'name': 'Dr. Izzati Al Fahwas',
        'specialty': 'Dokter Anak',
        'experience': '12+ Tahun',
        'color': Colors.pink,
        'image': 'assets/images/dokter-izzat.png',
        'schedule': {
          'Minggu': null,
          'Senin': '09:30',
          'Selasa': null,
          'Rabu': '07:00',
          'Kamis': null,
          'Jumat': '07:00',
          'Sabtu': null,
        },
      },
      {
        'name': 'Dr. El Prans Sakyono',
        'specialty': 'Dokter Kehamilan',
        'experience': '18+ Tahun',
        'color': Colors.red,
        'image': 'assets/images/dokter-prana.png',

        'schedule': {
          'Minggu': '09:30',
          'Senin': '09:30',
          'Selasa': '09:30',
          'Rabu': '09:30',
          'Kamis': '09:30',
          'Jumat': '09:30',
          'Sabtu': '09:30',
        },
      },
      {
        'name': 'Dr. Akhmad Akhnaf',
        'specialty': 'Psikolog',
        'experience': '10+ Tahun',
        'color': Colors.purple,
        'image': 'assets/images/dokter-ahnaf.png',

        'schedule': {
          'Minggu': '07:00',
          'Senin': null,
          'Selasa': null,
          'Rabu': null,
          'Kamis': null,
          'Jumat': null,
          'Sabtu': '07:00',
        },
      },
      {
        'name': 'Dr. Fahrel Djayantara',
        'specialty': 'Dokter Mata',
        'experience': '14+ Tahun',
        'color': Colors.green,
        'image': 'assets/images/dokter-farel.png',

        'schedule': {
          'Minggu': null,
          'Senin': '09:30',
          'Selasa': '07:00',
          'Rabu': '09:30',
          'Kamis': '07:00',
          'Jumat': null,
          'Sabtu': null,
        },
      },
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E293B), Color(0xFF1E40AF)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, color: Colors.white, size: 8),
                      SizedBox(width: 8),
                      Text(
                        'Tim Dokter Profesional',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Dokter Spesialis\nTerpercaya & Berpengalaman',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Dapatkan perawatan kesehatan terbaik dari tim dokter berpengalaman dengan teknologi modern dan jadwal praktik yang fleksibel',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                // Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStat('5+', 'Dokter Spesialis'),
                    _buildStat('24/7', 'Layanan'),
                    _buildStat('100%', 'Terpercaya'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Doctors List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              return _buildDoctorCard(doctors[index]);
            },
          ),
          const SizedBox(height: 24),
          // CTA
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E293B), Color(0xFF1E40AF)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  'Butuh Konsultasi Mendesak?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tim dokter kami siap melayani Anda 24/7 dengan teknologi modern dan peralatan terkini untuk memberikan perawatan kesehatan terbaik.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AuthRoutes.register);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Daftar Sekarang',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AuthRoutes.login);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Login Pasien',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,

          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildDoctorCard(Map<String, dynamic> doctor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
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
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [doctor['color'].withOpacity(0.8), doctor['color']],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Image.asset(
                      doctor['image'] as String,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback jika gambar tidak ditemukan
                        return Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        doctor['specialty'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          doctor['experience'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Jadwal Praktik',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildScheduleDay(
                      'SEN',
                      doctor['schedule']['Senin'],
                      doctor['color'],
                    ),
                    _buildScheduleDay(
                      'SEL',
                      doctor['schedule']['Selasa'],
                      doctor['color'],
                    ),
                    _buildScheduleDay(
                      'RAB',
                      doctor['schedule']['Rabu'],
                      doctor['color'],
                    ),
                    _buildScheduleDay(
                      'KAM',
                      doctor['schedule']['Kamis'],
                      doctor['color'],
                    ),
                    _buildScheduleDay(
                      'JUM',
                      doctor['schedule']['Jumat'],
                      doctor['color'],
                    ),
                    _buildScheduleDay(
                      'SAB',
                      doctor['schedule']['Sabtu'],
                      doctor['color'],
                    ),
                    _buildScheduleDay(
                      'MIN',
                      doctor['schedule']['Minggu'],
                      doctor['color'],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleDay(String day, String? time, Color doctorColor) {
    final bool available = time != null;

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: available ? doctorColor : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                color: available ? Colors.white : Colors.grey,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time ?? '-',
          style: TextStyle(
            fontSize: 8,
            color: available ? doctorColor : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      margin: const EdgeInsets.only(top: 32),
      decoration: const BoxDecoration(
        color: Colors.cyan,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  child: Image.asset(
                    'assets/images/logo.png', // Ganti dengan path logo Anda
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 120,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Klinik SerbaBisa',
                            style: TextStyle(
                              color: Colors.cyan,
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
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.facebook, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.call, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.email, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Klinik SerbaBisa hadir menyediakan berbagai layanan kesehatan berkualitas, lengkap, dan terstandarisasi mulai dari layanan umum, tumbuh kembang anak, hingga pengobatan psikologi.',
              style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AuthRoutes.register);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Pendaftaran Pasien',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AdminRoutes.adminLogin);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Login Admin',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(color: Colors.white24),
            const SizedBox(height: 16),
            const Text(
              'Copyright © 2025 Klinik SerbaBisa',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
