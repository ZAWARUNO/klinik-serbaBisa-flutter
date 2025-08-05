# 🔧 Troubleshooting Guide - Klinik SerbaBisa

## 🚨 Masalah Umum dan Solusinya

### **1. Asset Tidak Ditemukan**

**Gejala:**

```
Unable to load asset: "assets/images/poster-login.png"
```

**Solusi:**

1. **Periksa file asset:**

   ```bash
   dir assets\images
   ```

2. **Pastikan file ada:**

   - `poster-login.png`
   - `logo_transparant_klinik.png`
   - `logo_favicon.png`

3. **Clean dan rebuild:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

### **2. Aplikasi Kembali ke Setting Awal**

**Gejala:**

- Aplikasi tidak menyimpan perubahan
- Hot reload tidak berfungsi
- Aplikasi restart otomatis

**Solusi:**

1. **Stop aplikasi yang sedang berjalan:**

   ```bash
   # Tekan Ctrl+C di terminal
   ```

2. **Clean project:**

   ```bash
   flutter clean
   ```

3. **Get dependencies:**

   ```bash
   flutter pub get
   ```

4. **Jalankan dengan hot restart:**
   ```bash
   flutter run --debug --hot
   ```

### **3. Error Flutter SDK**

**Gejala:**

```
Error: 'VoidCallback' isn't a type.
Error: 'SemanticsAction' isn't defined.
```

**Solusi:**

1. **Update Flutter:**

   ```bash
   flutter upgrade
   ```

2. **Check Flutter version:**

   ```bash
   flutter --version
   ```

3. **Doctor check:**
   ```bash
   flutter doctor
   ```

### **4. Device Connection Lost**

**Gejala:**

```
Lost connection to device.
```

**Solusi:**

1. **Restart device/emulator**
2. **Reconnect device:**
   ```bash
   flutter devices
   flutter run -d [device_id]
   ```

### **5. Build Errors**

**Gejala:**

```
Build failed
Compilation errors
```

**Solusi:**

1. **Check syntax errors:**

   ```bash
   flutter analyze
   ```

2. **Fix linter errors:**

   ```bash
   dart fix --apply
   ```

3. **Clean build:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

## 🛠️ Langkah-langkah Debug

### **Step 1: Periksa Environment**

```bash
flutter doctor -v
```

### **Step 2: Periksa Dependencies**

```bash
flutter pub deps
```

### **Step 3: Periksa Assets**

```bash
dir assets\images
```

### **Step 4: Clean dan Rebuild**

```bash
flutter clean
flutter pub get
flutter run
```

### **Step 5: Hot Restart**

```bash
# Di terminal yang menjalankan flutter run
# Tekan 'R' untuk hot restart
# Tekan 'r' untuk hot reload
```

## 📱 Platform Specific Issues

### **Android**

- **Permission issues:** Check `android/app/src/main/AndroidManifest.xml`
- **Build errors:** Check `android/build.gradle`
- **Device not detected:** Enable USB debugging

### **iOS**

- **Simulator issues:** Reset simulator
- **Build errors:** Check `ios/Podfile`
- **Permission issues:** Check `ios/Runner/Info.plist`

### **Web**

- **CORS issues:** Check web server configuration
- **Asset loading:** Check `web/index.html`
- **Performance:** Use `flutter run -d chrome --web-renderer html`

## 🔍 Debug Tools

### **1. Flutter Inspector**

```bash
flutter run --debug
# Buka Flutter Inspector di browser
```

### **2. Performance Overlay**

```dart
// Tambahkan di MaterialApp
showPerformanceOverlay: true,
```

### **3. Debug Console**

```dart
// Tambahkan debug prints
debugPrint('Debug message');
print('Console message');
```

## 📞 Support

### **Jika masalah masih berlanjut:**

1. **Check logs:**

   ```bash
   flutter logs
   ```

2. **Create issue report:**

   - Screenshot error
   - Copy log output
   - Describe steps to reproduce

3. **Contact support:**
   - Email: support@klinikserbabisa.com
   - GitHub: https://github.com/klinikserbabisa/issues

## 🎯 Quick Fixes

### **Asset Loading Issues:**

```dart
// Gunakan errorBuilder untuk graceful fallback
Image.asset(
  'assets/images/poster-login.png',
  errorBuilder: (context, error, stackTrace) {
    return Container(
      color: Colors.grey[200],
      child: Icon(Icons.broken_image),
    );
  },
)
```

### **Hot Reload Issues:**

```bash
# Force hot restart
flutter run --hot
```

### **Memory Issues:**

```bash
# Clear cache
flutter clean
flutter pub cache clean
```

## 📋 Checklist Troubleshooting

- [ ] Flutter doctor passed
- [ ] Dependencies up to date
- [ ] Assets files exist
- [ ] Clean build completed
- [ ] Device connected
- [ ] No syntax errors
- [ ] Hot restart working
- [ ] App running properly

---

**💡 Tips:** Selalu mulai dengan `flutter clean` dan `flutter pub get` sebelum troubleshooting lebih lanjut!
