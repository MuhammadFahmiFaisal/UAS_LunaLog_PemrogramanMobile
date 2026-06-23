# Dokumentasi Integrasi Backend LunaLog (Supabase)

Dokumen ini berisi catatan mengenai langkah-langkah integrasi backend menggunakan Supabase pada proyek Flutter LunaLog, mulai dari apa yang sudah diselesaikan hingga rencana langkah selanjutnya.

---

## 1. Konfigurasi Awal

### A. Dependensi (`pubspec.yaml`)
Package yang digunakan:
| Package | Versi | Kegunaan |
|---|---|---|
| `supabase_flutter` | ^2.15.0 | SDK resmi Supabase (auth, database, storage) |
| `flutter_dotenv` | ^6.0.1 | Membaca `.env` agar kredensial tidak di-hardcode |
| `shared_preferences` | ^2.2.0 | Menyimpan status setup lokal (onboarding selesai, dll) |
| `image_picker` | ^1.1.2 | Memilih foto profil dari kamera atau galeri |

### B. Environment Variables (`.env`)
```
SUPABASE_URL=https://<project-id>.supabase.co
SUPABASE_ANON_KEY=<anon-key>
```
> File `.env` sudah masuk ke `.gitignore` dan didaftarkan di `assets` pada `pubspec.yaml`.

### C. Inisialisasi (`lib/main.dart`)
```dart
await dotenv.load(fileName: '.env');
await Supabase.initialize(
  url: dotenv.env['SUPABASE_URL']!,
  anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
);
```

---

## 2. Model Data

Semua model di `lib/core/models/` sudah memiliki `fromJson` dan `toJson`:

| Model | Tabel Supabase | Kolom Utama |
|---|---|---|
| `UserProfile` | `user_profiles` | `id`, `name`, `email`, `avatar_url`, `cycle_length`, `period_duration`, `last_period_date` |
| `Period` | `periods` | `id`, `user_profile_id`, `start_date`, `end_date`, `duration_days` |
| `DailyLog` | `daily_logs` | `id`, `user_profile_id`, `log_date`, `flow`, `symptoms`, `mood`, `sexual_activity`, `notes` |
| `Article` | `articles` | `id`, `title`, `content`, `category`, `image_url` |

---

## 3. Service Layer (`lib/core/services/supabase_service.dart`)

Semua interaksi database terpusat di satu file:

```dart
class SupabaseService {
  // Profil User
  static Future<UserProfile?> getUserProfile()
  static Future<void> updateUserProfile(UserProfile profile)
  
  // Upload foto profil ke Supabase Storage
  static Future<String?> uploadAvatar(File imageFile)

  // Data Periode Haid
  static Future<List<Period>> getPeriods(String userProfileId)
  static Future<void> addPeriod(String userProfileId, Period period)

  // Log Harian
  static Future<List<DailyLog>> getDailyLogs(String userProfileId)
  static Future<void> addDailyLog(String userProfileId, DailyLog log)

  // Artikel
  static Future<List<Article>> getArticles()
}
```

---

## 4. Autentikasi (Auth)

### A. Registrasi & Login Email/Password
- **`RegisterScreen`**: Memanggil `signUp()` → auto-insert ke tabel `user_profiles` (via Supabase trigger atau kode Flutter).
- **`LoginScreen`**: Memanggil `signInWithPassword()`.

### B. OAuth Login (Google & Facebook)

#### Perubahan di Flutter
- `lib/features/auth/screens/login_screen.dart` → tambah `_handleOAuthLogin()`
- `lib/features/auth/screens/register_screen.dart` → tambah `_handleOAuthLogin()`
- `android/app/src/main/AndroidManifest.xml` → tambah intent filter deep link

```dart
await Supabase.instance.client.auth.signInWithOAuth(
  provider,
  redirectTo: 'io.lunalog.app://login-callback',
);
```

Listener `onAuthStateChange` di `initState()` mendeteksi sign-in dan navigasi otomatis ke halaman utama.

#### Intent Filter AndroidManifest.xml
```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW"/>
    <category android:name="android.intent.category.DEFAULT"/>
    <category android:name="android.intent.category.BROWSABLE"/>
    <data android:scheme="io.lunalog.app" android:host="login-callback"/>
</intent-filter>
```

#### Konfigurasi Supabase Dashboard
- **Authentication → Providers** → aktifkan Google & Facebook, isi Client ID & Secret.
- **Authentication → URL Configuration** → tambahkan:
  ```
  io.lunalog.app://login-callback
  ```

#### Alur OAuth
```
User tekan tombol Google/Facebook
  → Browser dibuka (halaman login penyedia)
  → User memilih/login akun
  → Penyedia redirect ke Supabase callback
  → Supabase redirect ke io.lunalog.app://login-callback
  → Android mendeteksi URL scheme → aplikasi dibuka kembali
  → onAuthStateChange listener mendeteksi AuthChangeEvent.signedIn
  → Navigasi otomatis ke halaman utama ✅
```

---

## 5. Integrasi Fitur Utama ke Supabase

### A. HomeScreen (`lib/features/home/screens/home_screen.dart`)
- Diubah dari `StatelessWidget` → `StatefulWidget`.
- Method `_loadData()` dipanggil di `initState()`, mengambil:
  - `UserProfile` → untuk menampilkan panjang siklus & tanggal haid terakhir.
  - `DailyLog` hari ini → untuk menampilkan mood & aliran di kartu statistik.
- Menampilkan **fase siklus** (Menstruasi/Folikular/Ovulasi/Luteal) berdasarkan data nyata.
- Ada `RefreshIndicator` — tarik ke bawah untuk refresh data.
- Tombol "Log Gejala Harian" dan "Catatan Periode" akan memanggil `_loadData()` ulang setelah kembali dari halaman input.

### B. HistoryScreen (`lib/features/period_log/screens/history_screen.dart`)
- Semua `DummyData` dihapus dan diganti dengan data dari Supabase.
- `_loadData()` mengambil `periods` dan `dailyLogs` berdasarkan `userProfileId`.
- Kalender mewarnai hari-hari haid berdasarkan `startDate`–`endDate` dari setiap `Period`.
- Statistik (rata-rata siklus, durasi) dihitung secara dinamis dari data nyata.
- Tampilkan *empty state* "Belum ada riwayat haid" jika data masih kosong.
- Klik hari di kalender → bottom sheet menampilkan detail log harian dari Supabase.
- Ada `RefreshIndicator` — tarik ke bawah untuk refresh.

### C. LogHarianScreen (`lib/features/period_log/screens/log_harian_screen.dart`)
- Tombol "Simpan Log" sekarang memanggil `SupabaseService.addDailyLog()`.
- Mapping string UI → enum model:
  ```dart
  'Ringan' → FlowLevel.light
  'Sedang' → FlowLevel.medium
  'Deras' / 'Sangat Deras' → FlowLevel.heavy

  'tenang' → Mood.calm
  'senang' → Mood.happy
  'cemas'  → Mood.anxious
  'sedih'  → Mood.sad
  ```
- Menggunakan `upsert` dengan constraint `(user_profile_id, log_date)` — sehingga satu hari hanya punya satu log dan update otomatis jika diisi ulang.
- Error handling lengkap: cek sesi, catch exception, tampilkan SnackBar.

### D. TambahPeriodeScreen (`lib/features/period_log/screens/tambah_periode_screen.dart`)
- Tombol "Simpan Catatan" sekarang memanggil `SupabaseService.addPeriod()`.
- Field `duration_days` dihitung otomatis dari selisih `endDate - startDate + 1`.
- Validasi: tanggal mulai wajib diisi, validasi flow wajib dipilih, validasi end date > start date.
- Error handling lengkap: cek sesi, catch exception.

### E. PusatEdukasiScreen (`lib/features/health_tips/screens/pusat_edukasi_screen.dart`)
- Semua dummy data artikel digantikan dengan query dinamis ke tabel `articles` Supabase (`SupabaseService.getArticles()`).
- **Auto-Seeding**: Jika tabel `articles` di Supabase kosong, aplikasi akan meng-upsert data artikel default secara otomatis sehingga database selalu terisi.
- **Pencarian & Penyaringan Kategori**: Kolom pencarian disinkronkan dengan filter kategori secara interaktif (Nutrisi & Diet, Kesehatan Tidur, Kesehatan Mental).
- Komponen pendukung (`HeroArticleCard`, `CategorySection`, `DailyTipCard`) sepenuhnya menggunakan data dinamis yang ditarik dari database.
- **Bagikan (Sharing)** pada `DetailTipsScreen`: Memanfaatkan package `share_plus` untuk berbagi detail artikel (judul, isi, dan poin tips) secara langsung ke aplikasi sosial pihak ketiga (WhatsApp, Telegram, dll.).

---

## 6. Edit Profil & Upload Foto (`lib/features/profile/screens/edit_profil_screen.dart`)

### Fitur yang Ditambahkan
- **Load data nyata**: Saat layar dibuka, langsung memuat profil dari Supabase (`getUserProfile()`).
- **Upload foto profil**: Menggunakan `image_picker` untuk memilih dari:
  - 📸 Kamera (`ImageSource.camera`)
  - 🖼️ Galeri (`ImageSource.gallery`)
- Foto yang dipilih di-*preview* langsung di layar (tanpa harus simpan dulu).
- Saat "Simpan Perubahan" ditekan:
  1. Jika ada foto baru → upload ke Supabase Storage bucket `avatars` (`uploadAvatar()`).
  2. URL foto baru disimpan ke kolom `avatar_url` di `user_profiles`.
  3. Nama, email, panjang siklus, durasi haid di-*update* ke Supabase.

### Supabase Storage Setup (Wajib)
1. Buat bucket bernama **`avatars`** (public bucket).
2. Tambahkan RLS Policy:

```sql
-- Upload: user hanya bisa upload ke folder miliknya
CREATE POLICY "Users can upload own avatar"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'avatars' AND
  auth.uid()::text = split_part(name, '/', 1)
);

-- Read: semua orang bisa baca (public bucket)
CREATE POLICY "Public read avatars"
ON storage.objects FOR SELECT
USING (bucket_id = 'avatars');

-- Update: user hanya bisa update milik sendiri
CREATE POLICY "Users can update own avatar"
ON storage.objects FOR UPDATE
USING (
  bucket_id = 'avatars' AND
  auth.uid()::text = split_part(name, '/', 1)
);
```

### Permissions Android
File `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32"/>
<uses-permission android:name="android.permission.CAMERA"/>
```

---

## 7. Ringkasan Status Integrasi

| Fitur | Status | Keterangan |
|---|---|---|
| Registrasi Email | ✅ Selesai | Data masuk ke `user_profiles` |
| Login Email | ✅ Selesai | Validasi via Supabase Auth |
| Login Google OAuth | ✅ Selesai | Deep link `io.lunalog.app://login-callback` |
| Login Facebook OAuth | ✅ Selesai | Konfigurasi di Meta for Developers |
| HomeScreen (data nyata) | ✅ Selesai | Baca profil & log harian dari Supabase |
| HistoryScreen (data nyata) | ✅ Selesai | Kalender & riwayat dari Supabase |
| LogHarianScreen → Supabase | ✅ Selesai | `addDailyLog()` dengan upsert |
| TambahPeriodeScreen → Supabase | ✅ Selesai | `addPeriod()` |
| EditProfilScreen → Supabase | ✅ Selesai | `updateUserProfile()` + `uploadAvatar()` |
| Upload Foto Profil | ✅ Selesai | Supabase Storage bucket `avatars` |
| ProfileScreen (data nyata) | ✅ Selesai | Baca dari `getUserProfile()` |
| Pusat Edukasi (Artikel) | ✅ Selesai | Artikel dinamis dari Supabase (`getArticles()`), filter kategori, pencarian, & auto-seed |
| Bagikan Tips (Sharing) | ✅ Selesai | Fungsionalitas sharing artikel ke aplikasi lain dengan `share_plus` |

---

## 8. Langkah Selanjutnya (Opsional)

- **Pengujian OAuth menyeluruh**: Verifikasi data user Google/Facebook tersimpan ke `user_profiles` (butuh database trigger di Supabase).
- **Notifikasi siklus**: Push notification saat periode diperkirakan tiba.
- **Refresh token & sesi**: Handle expired session secara graceful.
- **Pengujian keseluruhan**: End-to-end flow dari daftar → input data → lihat histori → edit profil.
