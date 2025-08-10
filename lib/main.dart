import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/auth/auth_routes.dart';
import 'screens/patient/patient_routes.dart';
import 'theme/auth_theme.dart';
import 'widgets/doctors_section.dart';

void main() {
  runApp(const KlinikSerbaBisaApp());
}

class KlinikSerbaBisaApp extends StatelessWidget {
  const KlinikSerbaBisaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Debug: Print all routes
    final allRoutes = {...AuthRoutes.getRoutes(), ...PatientRoutes.getRoutes()};
    debugPrint('Available routes: ${allRoutes.keys.join(', ')}');

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
        ...PatientRoutes.getRoutes(),
      },
      onGenerateRoute: (settings) {
        final authRoute = AuthRoutes.onGenerateRoute(settings);
        if (authRoute != null) return authRoute;
        final patientRoute = PatientRoutes.onGenerateRoute(settings);
        return patientRoute;
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
  final GlobalKey _servicesSectionKey = GlobalKey();

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
                    _buildServicesSection(key: _servicesSectionKey),
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
              Expanded(
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
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AuthRoutes.login);
                },
                child: _buildMenuButton('Login Pasien', Colors.cyan, () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(String text, Color color, VoidCallback onTap) {
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
              ).withValues(alpha: 0.8), // Overlay untuk readability
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
                      _servicesSectionKey.currentContext!,
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeInOut,
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
                    color: Colors.cyan.withValues(
                      alpha: 0.2,
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

  Widget _buildServicesSection({Key? key}) {
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
      key: key,
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
            Colors.cyan.shade300.withValues(alpha: 0.7),
            Colors.teal.shade300.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
    return const DoctorsSection();
  }

  Widget _buildFooter() {
    return Container(
      margin: const EdgeInsets.only(top: 32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Column(
          children: [
            // Header section with logo and social icons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Text(
                            'Klinik SerbaBisa',
                            style: TextStyle(
                              color: Color(0xFF00BCD4),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildSocialIcon(Icons.facebook, 'Facebook'),
                      _buildSocialIcon(Icons.phone, 'Telepon'),
                      _buildSocialIcon(Icons.email, 'Email'),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Description text with better typography
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: const Text(
                'Klinik SerbaBisa hadir menyediakan berbagai layanan kesehatan berkualitas, lengkap, dan terstandarisasi mulai dari layanan umum, tumbuh kembang anak, hingga pengobatan psikologi.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.6,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 28),

            // Call-to-action button with enhanced design
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AuthRoutes.register);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0097A7),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person_add, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Pendaftaran Pasien',
                      style: TextStyle(
                        color: Color(0xFF0097A7),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Enhanced divider
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.white.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Copyright with better styling
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Copyright © 2025 Klinik SerbaBisa',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String tooltip) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, color: Colors.white, size: 20),
        tooltip: tooltip,
        style: IconButton.styleFrom(
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
