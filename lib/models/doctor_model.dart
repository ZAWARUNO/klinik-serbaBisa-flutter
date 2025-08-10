class Doctor {
  final String nama;
  final String specialty;
  final Map<String, String?> schedule;
  final int maxReservasi;
  final String experience;
  final String colorHex;
  final String image;

  Doctor({
    required this.nama,
    required this.specialty,
    required this.schedule,
    required this.maxReservasi,
    required this.experience,
    required this.colorHex,
    required this.image,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      nama: json['nama'],
      specialty: json['specialty'],
      schedule: Map<String, String?>.from(json['schedule']),
      maxReservasi: json['max_reservasi'],
      experience: json['experience'],
      colorHex: json['color'],
      image: json['image'],
    );
  }
}