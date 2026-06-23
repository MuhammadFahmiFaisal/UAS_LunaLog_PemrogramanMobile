import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/models.dart';
import '../../../core/services/supabase_service.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/cycle_ring_section.dart';
import '../widgets/home_cta_buttons.dart';
import '../widgets/insight_card.dart';
import '../widgets/stats_row.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserProfile? _profile;
  DailyLog? _todayLog;
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
      DailyLog? todayLog;

      if (profile != null) {
        final logs = await SupabaseService.getDailyLogs();
        final today = DateTime.now();
        todayLog = logs.where((l) =>
          l.date.year == today.year &&
          l.date.month == today.month &&
          l.date.day == today.day
        ).firstOrNull;
      }

      if (mounted) {
        setState(() {
          _profile = profile;
          _todayLog = todayLog;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppTheme.primary),
              )
            : RefreshIndicator(
                onRefresh: _loadData,
                color: AppTheme.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      const HomeTopBar(),
                      const SizedBox(height: 8),
                      CycleRingSection(profile: _profile),
                      const SizedBox(height: 24),
                      HomeCTAButtons(onActionCompleted: _loadData),
                      const SizedBox(height: 24),
                      InsightCard(profile: _profile),
                      const SizedBox(height: 24),
                      StatsRow(todayLog: _todayLog),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
