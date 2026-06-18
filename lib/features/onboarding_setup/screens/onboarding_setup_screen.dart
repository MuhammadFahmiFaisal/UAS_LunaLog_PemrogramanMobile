import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/routes/app_routes.dart';
import 'step1_tanggal_haid.dart';
import 'step2_durasi_haid.dart';
import 'step3_jarak_siklus.dart';
import 'step4_pilih_tujuan.dart';

class OnboardingSetupScreen extends StatefulWidget {
  const OnboardingSetupScreen({super.key});

  @override
  State<OnboardingSetupScreen> createState() => _OnboardingSetupScreenState();
}

class _OnboardingSetupScreenState extends State<OnboardingSetupScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false;

  // Setup data
  DateTime? _selectedDate;
  int _durationDays = 5;
  int _cycleLength = 28;
  String? _selectedGoal;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeSetup();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeSetup() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedSetup', true);

    // Save setup data
    if (_selectedDate != null) {
      await prefs.setString('lastPeriodDate', _selectedDate!.toIso8601String());
    }
    await prefs.setInt('periodDuration', _durationDays);
    await prefs.setInt('cycleLength', _cycleLength);
    if (_selectedGoal != null) {
      await prefs.setString('userGoal', _selectedGoal!);
    }

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushReplacementNamed(context, AppRoutes.main);
    }
  }

  bool _canProceed() {
    switch (_currentPage) {
      case 0:
        return _selectedDate != null;
      case 1:
        return true;
      case 2:
        return true;
      case 3:
        return _selectedGoal != null;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F7),
      body: Stack(
        children: [
          // Decorative Background Blur Circles
          Positioned(
            top: -MediaQuery.of(context).size.height * 0.1,
            right: -MediaQuery.of(context).size.width * 0.1,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFD9E2).withValues(alpha: 0.3),
              ),
            ),
          ),
          Positioned(
            bottom: -MediaQuery.of(context).size.height * 0.05,
            left: -MediaQuery.of(context).size.width * 0.1,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFD0BF).withValues(alpha: 0.2),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(),

                // Progress Indicator
                _buildProgressIndicator(),

                // PageView
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    children: [
                      Step1TanggalHaid(
                        selectedDate: _selectedDate,
                        onDateSelected: (date) {
                          setState(() => _selectedDate = date);
                        },
                      ),
                      Step2DurasiHaid(
                        durationDays: _durationDays,
                        onDurationChanged: (days) {
                          setState(() => _durationDays = days);
                        },
                      ),
                      Step3JarakSiklus(
                        cycleLength: _cycleLength,
                        onCycleLengthChanged: (length) {
                          setState(() => _cycleLength = length);
                        },
                      ),
                      Step4PilihTujuan(
                        selectedGoal: _selectedGoal,
                        onGoalSelected: (goal) {
                          setState(() => _selectedGoal = goal);
                        },
                      ),
                    ],
                  ),
                ),

                // Footer
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: _currentPage > 0 ? _previousPage : null,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage > 0
                    ? const Color(0xFFFFF0F1)
                    : Colors.transparent,
              ),
              child: Icon(
                Icons.arrow_back,
                color: _currentPage > 0
                    ? const Color(0xFF524346)
                    : Colors.transparent,
                size: 24,
              ),
            ),
          ),

          // Center Title
          const Expanded(
            child: Center(
              child: Text(
                'LunaLog',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6f3347),
                ),
              ),
            ),
          ),

          // Spacer
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Step Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${_currentPage + 1} of 4',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF524346),
                  letterSpacing: 0.05,
                ),
              ),
              Text(
                '${((_currentPage + 1) / 4 * 100).toInt()}%',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6f3347),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 8,
              child: Row(
                children: List.generate(4, (index) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: index <= _currentPage
                            ? const Color(0xFF6f3347)
                            : const Color(0xFFE5D1D0),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        children: [
          // Primary Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: (_canProceed() && !_isLoading) ? _nextPage : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6f3347),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFF6f3347).withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 4,
                shadowColor: const Color(0xFF6f3347).withValues(alpha: 0.2),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentPage == 3 ? 'Selesai' : 'Lanjut',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (_currentPage < 3) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 20),
                        ],
                      ],
                    ),
            ),
          ),

          // Back Button (Ghost)
          if (_currentPage > 0) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: TextButton(
                onPressed: _previousPage,
                child: const Text(
                  'Kembali',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF7A5649),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
