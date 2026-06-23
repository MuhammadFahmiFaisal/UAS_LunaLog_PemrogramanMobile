import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/models.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/services/notification_service.dart';
import '../widgets/welcome_banner.dart';
import '../widgets/cycle_analysis_section.dart';
import '../widgets/next_prediction_card.dart';
import '../widgets/notification_settings_section.dart';
import '../widgets/export_section.dart';

class WawasanLaporanScreen extends StatefulWidget {
  const WawasanLaporanScreen({super.key});

  @override
  State<WawasanLaporanScreen> createState() => _WawasanLaporanScreenState();
}

class _WawasanLaporanScreenState extends State<WawasanLaporanScreen> {
  bool _pengingatHaid = true;
  bool _masaSubur = false;
  UserProfile? _userProfile;
  List<DailyLog> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final profile = await SupabaseService.getUserProfile();
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);
      final logs = await SupabaseService.getDailyLogsByDateRange(startOfMonth, endOfMonth);
      
      final periodPref = await NotificationService().getPeriodReminderPref();
      final fertilityPref = await NotificationService().getFertilityReminderPref();

      if (mounted) {
        setState(() {
          _userProfile = profile;
          _logs = logs;
          _pengingatHaid = periodPref;
          _masaSubur = fertilityPref;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat profil: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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

    if (_userProfile == null) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(child: Text('Gagal memuat data profil')),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const WelcomeBanner(),
                    const SizedBox(height: 24),
                    CycleAnalysisSection(
                      cycleLength: _userProfile!.cycleLength,
                      periodDuration: _userProfile!.periodDuration,
                    ),
                    const SizedBox(height: 24),
                    NextPredictionCard(
                      cycleLength: _userProfile!.cycleLength,
                      lastPeriodDate: _userProfile!.lastPeriodDate,
                    ),
                    const SizedBox(height: 24),
                    NotificationSettingsSection(
                      pengingatHaid: _pengingatHaid,
                      masaSubur: _masaSubur,
                      onPengingatHaidChanged: (value) async {
                        setState(() => _pengingatHaid = value);
                        if (_userProfile != null) {
                          final nextDate = _userProfile!.lastPeriodDate?.add(Duration(days: _userProfile!.cycleLength)) ?? DateTime.now();
                          await NotificationService().schedulePeriodReminder(nextDate, value);
                        }
                      },
                      onMasaSuburChanged: (value) async {
                        setState(() => _masaSubur = value);
                        if (_userProfile != null) {
                          final nextDate = _userProfile!.lastPeriodDate?.add(Duration(days: _userProfile!.cycleLength)) ?? DateTime.now();
                          await NotificationService().scheduleFertilityReminder(nextDate, value);
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    ExportSection(
                      profile: _userProfile!,
                      logs: _logs,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 64,
      color: AppTheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            color: AppTheme.primary,
          ),
          const Expanded(
            child: Text(
              'Wawasan & Laporan',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
