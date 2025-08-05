class AuthValidators {
  // Validasi email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email harus diisi';
    }

    // Regex untuk validasi email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  // Validasi password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password harus diisi';
    }

    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }

    return null;
  }

  // Validasi nama
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama harus diisi';
    }

    if (value.length < 2) {
      return 'Nama minimal 2 karakter';
    }

    return null;
  }

  // Validasi umur
  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Umur harus diisi';
    }

    int? age = int.tryParse(value);
    if (age == null) {
      return 'Umur harus berupa angka';
    }

    if (age < 1 || age > 120) {
      return 'Umur harus antara 1-120 tahun';
    }

    return null;
  }

  // Validasi nomor HP
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor HP harus diisi';
    }

    // Hapus spasi dan karakter khusus
    String cleanNumber = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanNumber.length < 10 || cleanNumber.length > 13) {
      return 'Nomor HP harus 10-13 digit';
    }

    // Validasi format nomor Indonesia
    if (!cleanNumber.startsWith('08') && !cleanNumber.startsWith('628')) {
      return 'Format nomor HP tidak valid';
    }

    return null;
  }

  // Validasi alamat
  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Alamat harus diisi';
    }

    if (value.length < 10) {
      return 'Alamat minimal 10 karakter';
    }

    return null;
  }

  // Validasi jenis kelamin
  static String? validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Jenis kelamin harus dipilih';
    }

    return null;
  }

  // Cek kekuatan password
  static int checkPasswordStrength(String password) {
    int strength = 0;

    // Minimal 8 karakter
    if (password.length >= 8) strength++;

    // Mengandung huruf kecil
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;

    // Mengandung huruf besar
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;

    // Mengandung angka
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;

    // Mengandung karakter khusus
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) strength++;

    return strength;
  }

  // Dapatkan teks kekuatan password
  static String getPasswordStrengthText(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return 'Sangat Lemah';
      case 2:
        return 'Lemah';
      case 3:
        return 'Sedang';
      case 4:
      case 5:
        return 'Kuat';
      default:
        return 'Kekuatan password';
    }
  }

  // Dapatkan warna kekuatan password
  static String getPasswordStrengthColor(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return 'red';
      case 2:
        return 'orange';
      case 3:
        return 'yellow';
      case 4:
      case 5:
        return 'green';
      default:
        return 'grey';
    }
  }

  // Validasi form login
  static Map<String, String?> validateLoginForm({
    required String email,
    required String password,
  }) {
    return {
      'email': validateEmail(email),
      'password': validatePassword(password),
    };
  }

  // Validasi form register
  static Map<String, String?> validateRegisterForm({
    required String email,
    required String nama,
    required String umur,
    required String nomorHp,
    required String alamat,
    required String password,
    required String kelamin,
  }) {
    return {
      'email': validateEmail(email),
      'nama': validateName(nama),
      'umur': validateAge(umur),
      'nomorHp': validatePhoneNumber(nomorHp),
      'alamat': validateAddress(alamat),
      'password': validatePassword(password),
      'kelamin': validateGender(kelamin),
    };
  }

  // Cek apakah form valid
  static bool isFormValid(Map<String, String?> validations) {
    return !validations.values.any((error) => error != null);
  }

  // Dapatkan pesan error pertama
  static String? getFirstError(Map<String, String?> validations) {
    for (String? error in validations.values) {
      if (error != null) {
        return error;
      }
    }
    return null;
  }
}
