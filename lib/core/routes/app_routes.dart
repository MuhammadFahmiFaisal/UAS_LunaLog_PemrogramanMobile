import 'package:flutter/material.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/lock_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/otp_verification_screen.dart';
import '../../features/auth/screens/reset_password_screen.dart';
import '../../features/auth/screens/password_reset_success_screen.dart';
import '../../core/models/models.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/onboarding_setup/screens/onboarding_setup_screen.dart';
import '../../features/home/screens/main_screen.dart';
import '../../features/home/screens/wawasan_laporan_screen.dart';
import '../../features/period_log/screens/log_harian_screen.dart';
import '../../features/period_log/screens/tambah_periode_screen.dart';
import '../../features/period_log/screens/edit_periode_screen.dart';
import '../../features/period_log/screens/detail_riwayat_screen.dart';
import '../../features/health_tips/screens/detail_tips_screen.dart';
import '../../features/health_tips/screens/pusat_edukasi_screen.dart';
import '../../features/profile/screens/edit_profil_screen.dart';
import '../../features/profile/screens/notifikasi_screen.dart';
import '../../features/profile/screens/bantuan_screen.dart';
import '../../features/profile/screens/security_pin_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String lockScreen = '/lock-screen';
  static const String onboarding = '/onboarding';
  static const String onboardingSetup = '/onboarding-setup';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String resetPassword = '/reset-password';
  static const String passwordResetSuccess = '/password-reset-success';
  static const String main = '/main';
  static const String wawasanLaporan = '/wawasan-laporan';
  static const String logHarian = '/log-harian';
  static const String addPeriod = '/add-period';
  static const String editPeriode = '/edit-periode';
  static const String detailRiwayat = '/detail-riwayat';
  static const String detailTips = '/detail-tips';
  static const String pusatEdukasi = '/pusat-edukasi';
  static const String editProfil = '/edit-profil';
  static const String notifications = '/notifications';
  static const String helpSupport = '/help-support';
  static const String securityPin = '/security-pin';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        lockScreen: (context) => const LockScreen(),
        onboarding: (context) => const OnboardingScreen(),
        onboardingSetup: (context) => const OnboardingSetupScreen(),
        login: (context) => const LoginScreen(),
        register: (context) => const RegisterScreen(),
        forgotPassword: (context) => const ForgotPasswordScreen(),
        otpVerification: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          final email = args is String ? args : '';
          return OtpVerificationScreen(email: email);
        },
        resetPassword: (context) => const ResetPasswordScreen(),
        passwordResetSuccess: (context) => const PasswordResetSuccessScreen(),
        main: (context) => const MainScreen(),
        wawasanLaporan: (context) => const WawasanLaporanScreen(),
        logHarian: (context) => const LogHarianScreen(),
        addPeriod: (context) => const TambahPeriodeScreen(),
        editPeriode: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          final periodId = args is String ? args : '';
          if (periodId.isEmpty) return const SizedBox();
          return EditPeriodeScreen(periodId: periodId);
        },
        detailRiwayat: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          final periodId = args is String ? args : '';
          if (periodId.isEmpty) return const SizedBox();
          return DetailRiwayatScreen(periodId: periodId);
        },
        detailTips: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is Article) {
            return DetailTipsScreen(article: args);
          }
          return const DetailTipsScreen();
        },
        pusatEdukasi: (context) => const PusatEdukasiScreen(),
        editProfil: (context) => const EditProfilScreen(),
        notifications: (context) => const NotifikasiScreen(),
        helpSupport: (context) => const BantuanScreen(),
        securityPin: (context) => const SecurityPinScreen(),
      };
}
