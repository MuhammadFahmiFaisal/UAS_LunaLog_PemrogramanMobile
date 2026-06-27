import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routes/app_routes.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  String _enteredPin = '';
  String _correctPin = '';
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _correctPin = prefs.getString('security_pin') ?? '';
      _isLoading = false;
    });

    final biometricEnabled = prefs.getBool('is_biometric_enabled') ?? false;

    if (_correctPin.isEmpty && !biometricEnabled) {
      // Jika ternyata tidak ada PIN dan biometrik mati, langsung lanjut
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.main);
      }
    } else if (biometricEnabled) {
      _authenticateBiometric();
    }
  }

  Future<void> _authenticateBiometric() async {
    final LocalAuthentication auth = LocalAuthentication();
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Gunakan sidik jari atau Face ID untuk membuka LunaLog',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
      if (didAuthenticate) {
        final prefs = await SharedPreferences.getInstance();
        final hasCompletedSetup = prefs.getBool('hasCompletedSetup') ?? false;
        
        if (!mounted) return;

        if (hasCompletedSetup) {
          Navigator.pushReplacementNamed(context, AppRoutes.main);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.onboardingSetup);
        }
      }
    } catch (e) {
      // Fallback ke PIN jika biometrik gagal
    }
  }

  void _onKeypadPressed(String value) {
    if (_enteredPin.length < 6) {
      setState(() {
        _enteredPin += value;
        _hasError = false;
      });

      if (_enteredPin.length == _correctPin.length) {
        _verifyPin();
      }
    }
  }

  void _onDeletePressed() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _hasError = false;
      });
    }
  }

  Future<void> _verifyPin() async {
    if (_enteredPin == _correctPin) {
      final prefs = await SharedPreferences.getInstance();
      final hasCompletedSetup = prefs.getBool('hasCompletedSetup') ?? false;
      
      if (!mounted) return;
      if (hasCompletedSetup) {
        Navigator.pushReplacementNamed(context, AppRoutes.main);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.onboardingSetup);
      }
    } else {
      setState(() {
        _hasError = true;
        _enteredPin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(child: CircularProgressIndicator(color: AppTheme.primary)),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            const Icon(
              Icons.lock_outline,
              size: 48,
              color: AppTheme.primary,
            ),
            const SizedBox(height: 24),
            const Text(
              'Masukkan PIN Keamanan',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Silakan masukkan PIN LunaLog Anda',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppTheme.onSurfaceVariant.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 32),
            _buildPinDots(),
            if (_hasError) ...[
              const SizedBox(height: 16),
              const Text(
                'PIN salah. Silakan coba lagi.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: AppTheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            const Spacer(),
            _buildKeypad(),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildPinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_correctPin.isNotEmpty ? _correctPin.length : 4, (index) {
        bool isActive = index < _enteredPin.length;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppTheme.primary : AppTheme.surfaceContainerHighest,
            border: Border.all(
              color: isActive ? AppTheme.primary : AppTheme.outlineVariant,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildKeypad() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildKeypadButton('1'),
              _buildKeypadButton('2'),
              _buildKeypadButton('3'),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildKeypadButton('4'),
              _buildKeypadButton('5'),
              _buildKeypadButton('6'),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildKeypadButton('7'),
              _buildKeypadButton('8'),
              _buildKeypadButton('9'),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 64), // Empty space
              _buildKeypadButton('0'),
              _buildDeleteButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadButton(String number) {
    return InkWell(
      onTap: () => _onKeypadPressed(number),
      borderRadius: BorderRadius.circular(32),
      child: Container(
        width: 64,
        height: 64,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.surfaceWhite,
          boxShadow: [
            BoxShadow(
              color: const Color(0x0F8B4A5F),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          number,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return InkWell(
      onTap: _onDeletePressed,
      borderRadius: BorderRadius.circular(32),
      child: Container(
        width: 64,
        height: 64,
        alignment: Alignment.center,
        child: const Icon(
          Icons.backspace_outlined,
          color: AppTheme.onSurfaceVariant,
          size: 24,
        ),
      ),
    );
  }
}
