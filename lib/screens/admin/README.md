# Halaman Admin - Klinik SerbaBisa

Dokumentasi untuk halaman admin aplikasi Klinik SerbaBisa.

## Struktur File

```
lib/screens/admin/
├── admin_login_screen.dart    # Halaman login admin
├── admin_routes.dart          # Definisi routes admin
└── README.md                  # Dokumentasi ini
```

## Fitur

### Admin Login Screen (`admin_login_screen.dart`)

**Fitur Utama:**

- Form login khusus administrator
- Validasi email dan password
- Toggle visibility password
- Loading state saat proses login
- Desain responsif (mobile & desktop)
- Background image dengan gradient overlay
- Icon admin panel yang khas
- Info box khusus admin
- Link navigasi ke user login

**Desain:**

- **Desktop**: Split screen dengan gambar background di kiri dan form di kanan
- **Mobile**: Background image dengan gradient overlay, form di tengah
- Warna tema: Emerald green (#10B981, #059669)
- Typography: Poppins font family
- Shadow dan border radius yang konsisten

**Validasi:**

- Email: Format email yang valid
- Password: Minimal 8 karakter
- Form validation dengan error messages

**State Management:**

- `_isPasswordVisible`: Kontrol visibility password
- `_isLoading`: Loading state saat login
- Form controllers untuk email dan password

## Routes

### Admin Routes (`admin_routes.dart`)

**Routes yang tersedia:**

- `/admin/login` - Halaman login admin

**Metode:**

- `getRoutes()`: Mengembalikan Map<String, WidgetBuilder>
- `onGenerateRoute()`: Handler untuk route generation

## Integrasi

### Main App (`main.dart`)

- Import `AdminRoutes`
- Gabungkan routes admin dengan routes auth
- Handler onGenerateRoute untuk admin routes

### Navigation

- Dari user login: Link "Login sebagai Admin?"
- Dari admin login: Link "Login sebagai User?"
- Menggunakan `Navigator.pushReplacementNamed()`

## Penggunaan

### Akses Halaman Admin

1. Buka aplikasi (default ke user login)
2. Klik "Login sebagai Admin?" di halaman user login
3. Atau akses langsung ke `/admin/login`

### Navigasi

- **User Login** → **Admin Login**: Klik "Login sebagai Admin?"
- **Admin Login** → **User Login**: Klik "Login sebagai User?"

## Customization

### Warna

- Primary: `AuthTheme.primaryColor` (#10B981)
- Mobile overlay: `Color(0xFF059669)` dengan opacity
- Text colors: Menggunakan `AuthTheme.getTextColor()`

### Layout

- Breakpoint responsive: 768px
- Desktop: Split screen layout
- Mobile: Full screen dengan gradient overlay

### Assets

- Background image: `Assets.posterLogin`
- Logo placeholder: `PlaceholderWidgets.buildLogoPlaceholder()`

## Dependencies

### Internal Dependencies

- `../../theme/auth_theme.dart` - Tema dan styling
- `../../widgets/auth/auth_widgets.dart` - Widget komponen
- `../../widgets/auth/placeholder_widgets.dart` - Placeholder widgets
- `../../utils/auth_validators.dart` - Validasi form
- `../../constants/assets.dart` - Asset paths

### External Dependencies

- `flutter/material.dart` - Flutter UI framework

## Responsive Breakpoints

- **Mobile**: < 768px

  - Background image dengan gradient overlay
  - Form container dengan opacity
  - Logo placeholder di atas form
  - Footer copyright

- **Desktop**: >= 768px
  - Split screen layout
  - Background image di kiri
  - Form container solid white
  - Tidak ada logo di atas form

## Form Validation

### Email Admin

- Required field
- Format email yang valid
- Placeholder: "admin@klinik.com"

### Password

- Required field
- Minimal 8 karakter
- Toggle visibility
- Placeholder: "Masukkan password admin"

## Error Handling

- Asset loading error: Fallback ke placeholder widgets
- Form validation: Error messages di bawah field
- Network error: Loading state dan snackbar feedback

## Security Considerations

- Password visibility toggle
- Form validation client-side
- Loading state untuk mencegah multiple submission
- Clear form data saat dispose

## Future Enhancements

- [ ] Dashboard admin setelah login
- [ ] Remember me functionality
- [ ] Biometric authentication
- [ ] Two-factor authentication
- [ ] Password reset functionality
- [ ] Session management
- [ ] Role-based access control
