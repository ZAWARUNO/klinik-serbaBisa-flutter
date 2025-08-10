import 'package:flutter/material.dart';
import '../screens/services/dashboard_service.dart';
import '../screens/services/user_service.dart';

class AppointmentDialog {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _AppointmentDialogContent(),
    );
  }
}

class _AppointmentDialogContent extends StatefulWidget {
  const _AppointmentDialogContent();

  @override
  State<_AppointmentDialogContent> createState() =>
      _AppointmentDialogContentState();
}

class _AppointmentDialogContentState extends State<_AppointmentDialogContent> {
  final _formKey = GlobalKey<FormState>();
  final _keluhanController = TextEditingController();
  String? _selectedJadwal;
  List<JadwalData> _jadwalList = [];
  bool _isLoading = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadJadwalDokter();
  }

  @override
  void dispose() {
    _keluhanController.dispose();
    super.dispose();
  }

  Future<void> _loadJadwalDokter() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await DashboardService.getJadwalDokter();
      if (result.success && result.jadwalData != null) {
        setState(() {
          _jadwalList = result.jadwalData!;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat jadwal dokter: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitAppointment() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedJadwal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih jadwal dokter terlebih dahulu'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_keluhanController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Keluhan harus diisi'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Get current user email
      final userEmail = await UserService.getUserEmail();
      if (userEmail == null) {
        throw Exception('Tidak dapat menemukan data user');
      }

      // Find selected schedule
      final selectedSchedule = _jadwalList.firstWhere(
        (jadwal) => jadwal.scheduleId.toString() == _selectedJadwal,
      );

      // Create appointment data
      final appointmentData = {
        'email': userEmail,
        'schedule_id': selectedSchedule.scheduleId,
        'keluhan': _keluhanController.text.trim(),
      };

      // Call API to create appointment
      final result = await DashboardService.createAppointment(appointmentData);

      if (result.success) {
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Janji temu berhasil dibuat dengan Dr. ${selectedSchedule.nama} pada ${selectedSchedule.hari} ${selectedSchedule.waktu}',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal membuat janji temu: ${result.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuat janji temu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.6,
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
                const Icon(Icons.calendar_today, color: Color(0xFF059669)),
                const SizedBox(width: 12),
                const Text(
                  'Buat Janji Temu',
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

            // Form
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pilih Dokter
                      _buildFormField(
                        'Pilih Dokter',
                        _selectedJadwal != null
                            ? _getSelectedDoctorName()
                            : 'Pilih dokter',
                        Icons.person,
                        onTap: _showDoctorSelection,
                      ),
                      const SizedBox(height: 16),

                      // Spesialisasi
                      _buildFormField(
                        'Spesialisasi',
                        _selectedJadwal != null
                            ? _getSelectedDoctorPoli()
                            : 'Pilih dokter terlebih dahulu',
                        Icons.medical_services,
                      ),
                      const SizedBox(height: 16),

                      // Hari
                      _buildFormField(
                        'Hari',
                        _selectedJadwal != null
                            ? _getSelectedDoctorHari()
                            : 'Pilih dokter terlebih dahulu',
                        Icons.calendar_today,
                      ),
                      const SizedBox(height: 16),

                      // Waktu
                      _buildFormField(
                        'Waktu',
                        _selectedJadwal != null
                            ? _getSelectedDoctorWaktu()
                            : 'Pilih dokter terlebih dahulu',
                        Icons.access_time,
                      ),
                      const SizedBox(height: 16),

                      // Keluhan
                      _buildFormField(
                        'Keluhan',
                        _keluhanController.text.isEmpty
                            ? 'Masukkan keluhan Anda'
                            : _keluhanController.text,
                        Icons.note,
                        onTap: _showKeluhanInput,
                      ),
                      const SizedBox(height: 24),

                      // Action buttons
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
                                  vertical: 16,
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
                              onPressed: _isSubmitting
                                  ? null
                                  : _submitAppointment,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF059669),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isSubmitting
                                  ? const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text('Membuat...'),
                                      ],
                                    )
                                  : const Text(
                                      'Buat Janji',
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
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(
    String label,
    String value,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF059669), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: onTap != null
                          ? const Color(0xFF374151)
                          : Colors.grey[600],
                    ),
                  ),
                ),
                if (onTap != null)
                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getSelectedDoctorName() {
    if (_selectedJadwal == null) return '';
    final selectedJadwal = _jadwalList.firstWhere(
      (jadwal) => jadwal.scheduleId.toString() == _selectedJadwal,
    );
    return selectedJadwal.nama;
  }

  String _getSelectedDoctorPoli() {
    if (_selectedJadwal == null) return '';
    final selectedJadwal = _jadwalList.firstWhere(
      (jadwal) => jadwal.scheduleId.toString() == _selectedJadwal,
    );
    return selectedJadwal.poli;
  }

  String _getSelectedDoctorHari() {
    if (_selectedJadwal == null) return '';
    final selectedJadwal = _jadwalList.firstWhere(
      (jadwal) => jadwal.scheduleId.toString() == _selectedJadwal,
    );
    return selectedJadwal.hari;
  }

  String _getSelectedDoctorWaktu() {
    if (_selectedJadwal == null) return '';
    final selectedJadwal = _jadwalList.firstWhere(
      (jadwal) => jadwal.scheduleId.toString() == _selectedJadwal,
    );
    return selectedJadwal.waktu;
  }

  void _showDoctorSelection() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Dokter'),
        content: SizedBox(
          width: double.maxFinite,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _jadwalList.length,
                  itemBuilder: (context, index) {
                    final jadwal = _jadwalList[index];
                    return ListTile(
                      title: Text(jadwal.nama),
                      subtitle: Text(
                        '${jadwal.poli} - ${jadwal.hari} ${jadwal.waktu}',
                      ),
                      onTap: () {
                        setState(() {
                          _selectedJadwal = jadwal.scheduleId.toString();
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  void _showKeluhanInput() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Masukkan Keluhan'),
        content: TextField(
          controller: _keluhanController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Jelaskan keluhan Anda...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {}); // Refresh UI
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
