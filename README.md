# 🌙 LunaLog: Simple Digital Period Journal

LunaLog adalah aplikasi pencatatan menstruasi digital yang sederhana dan mudah digunakan. Aplikasi ini dirancang untuk membantu pengguna melacak siklus menstruasi, mendokumentasikan gejala, dan mendapatkan tips kesehatan reproduksi yang relevan.

---

## ✨ Fitur Utama

Aplikasi ini memiliki 4 fitur inti untuk memberikan pengalaman pengguna terbaik:

1. **Pencatatan Menstruasi (Period Log)**
   Catat tanggal mulai dan selesai menstruasi dengan mudah dan cepat hanya dalam beberapa ketukan.
2. **Pelacakan Gejala (Symptom Tracking)**
   Dokumentasikan gejala seperti kram, sakit kepala, *mood*, dan lainnya setiap hari.
3. **Riwayat Siklus (Cycle History)**
   Lihat riwayat siklus secara terstruktur dan pahami pola tubuhmu dari waktu ke waktu.
4. **Tips Kesehatan (Health Tips)**
   Dapatkan informasi dan tips kesehatan reproduksi yang relevan dan terpercaya.

---

## 🎯 Ruang Lingkup Proyek (Project Scope)

Untuk menjaga fokus pada pengalaman pengguna yang sederhana dan optimal, proyek ini memiliki batasan ruang lingkup sebagai berikut:

### ✅ Termasuk dalam Proyek (In Scope)
- Autentikasi (Login & Register) menggunakan Supabase.
- Pencatatan Menstruasi.
- Riwayat Siklus.
- Tips Kesehatan.

### ❌ Di Luar Cakupan (Out of Scope)
- Prediksi AI (Artificial Intelligence).
- Konsultasi Dokter secara langsung.
- Integrasi Wearable (Smartwatch, dll).
- Prediksi Kesuburan (Fertility Prediction).

---

## 📂 Struktur Folder (Feature-First Architecture)

Proyek ini menggunakan arsitektur **Feature-First** untuk memastikan kode tetap modular, rapi, dan mudah dikolaborasikan oleh tim. Menggunakan pola arsitektur ini mencegah kode menjadi tumpang tindih ketika aplikasi bertambah kompleks.

**Mengapa menggunakan Arsitektur ini?**
1. **Mencegah *Merge Conflict*:** Anggota tim bisa mengerjakan fitur yang berbeda secara bersamaan (misal: si A di folder `auth`, si B di folder `period_log`) tanpa takut kode bentrok di Git.
2. **Mudah Mencari *Bug*:** Jika ada masalah di layar Profil, developer hanya perlu mencari di folder `features/profile` tanpa harus mengitari seluruh file proyek.
3. **Skalabilitas:** Sangat mudah jika ingin menambah fitur baru di masa depan, cukup dengan membuat folder fitur baru tanpa mengganggu fitur yang sudah jalan.

Semua kode utama berada di dalam direktori `lib/` yang dibagi menjadi `core`, `features`, dan `shared`.

```text
uas_lunalog_pemrogramanmobile/
├── assets/                  # Tempat penyimpanan aset statis
│   ├── fonts/               # Font kustom aplikasi
│   ├── icons/               # Ikon dan ilustrasi (.svg, .png)
│   └── images/              # Gambar dan logo (misal: logo LunaLog)
│
└── lib/
    ├── core/                # Inti pengaturan & konfigurasi global aplikasi
    │   ├── constants/       # Konstanta nilai statis (Warna, URL, Keys)
    │   ├── routes/          # Konfigurasi routing/navigasi (AppRoutes)
    │   ├── theme/           # Konfigurasi tema UI (Typography, Colors)
    │   └── utils/           # Fungsi helper / utilitas (Format tanggal, dll)
    │
    ├── features/            # Modul fitur-fitur utama (Isolated Features)
    │   │
    │   ├── auth/            # 🔐 Fitur Autentikasi (Login/Register)
    │   │   ├── screens/     # UI Layar Utama Auth
    │   │   └── widgets/     # Komponen UI khusus Auth (Form, dll)
    │   │
    │   ├── home/            # 🏠 Fitur Dashboard (Main Screen)
    │   │   ├── screens/     # UI Beranda & Navigasi Bawah
    │   │   └── widgets/     # Kartu ringkasan siklus
    │   │
    │   ├── period_log/      # 💧 Fitur Catatan & Riwayat
    │   │   ├── screens/     # UI Tambah Catatan & Riwayat List
    │   │   └── widgets/     # Komponen form gejala/mood
    │   │
    │   ├── health_tips/     # 💡 Fitur Tips Kesehatan
    │   │   ├── screens/     # UI Daftar Tips & Detail Tips
    │   │   └── widgets/     # Kartu artikel tips
    │   │
    │   └── profile/         # 👤 Fitur Profil Pengguna
    │       ├── screens/     # UI Pengaturan Profil
    │       └── widgets/     # Komponen profil
    │
    └── shared/              # Komponen Reusable Lintas Fitur
        └── widgets/         # (Custom Button, Custom Text Field, dll)
```

### 💡 Panduan Kolaborasi untuk Tim Developer:
1. **Isolasi Pemisahan Fitur**: Jika Anda ditugaskan mengerjakan layar *Tips Kesehatan*, pastikan semua file UI (`screens`, `widgets`), dan nantinya model data (`models`) diletakkan di dalam `lib/features/health_tips/`. Jangan mencampurnya dengan folder fitur lain.
2. **Gunakan Core untuk Global**: Hindari menulis *hardcode* warna hex (`#FF...`) atau ukuran *padding* di dalam layar. Gunakan variabel terpusat yang akan dibuat di `lib/core/theme/` atau `lib/core/constants/` agar desain tetap seragam (*Pixel Perfect*).
3. **Reusable Widgets**: Jika sebuah komponen UI (misalnya tombol utama, text field, atau dialog konfirmasi) digunakan di fitur *Auth* dan juga di fitur *Profile*, letakkan komponen tersebut di folder `lib/shared/widgets/`.

---

## 🚀 Cara Menjalankan Proyek Lokal

1. Pastikan **Flutter SDK** sudah terpasang di komputer Anda.
2. Lakukan `clone` repositori ini ke komputer lokal.
3. Buka terminal di direktori proyek dan jalankan `flutter pub get` untuk mengunduh semua dependensi paket.
4. Salin file `.env.example` menjadi `.env` di direktori utama:
   ```bash
   cp .env.example .env
   ```
   Lalu, isi nilai `SUPABASE_URL` dan `SUPABASE_ANON_KEY` sesuai dengan proyek Supabase Anda.
5. Hubungkan emulator atau *smartphone* fisik (Android/iOS).
6. Jalankan aplikasi dengan perintah `flutter run`.
