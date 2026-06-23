import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/models/models.dart';
import '../../../core/services/supabase_service.dart';
import '../widgets/history_welcome_banner.dart';
import '../widgets/quick_summary_row.dart';
import '../widgets/period_calendar.dart';
import '../widgets/history_list.dart';
import '../widgets/daily_detail_sheet.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Period> _periods = [];
  List<DailyLog> _dailyLogs = [];
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
      if (profile != null) {
        final periods = await SupabaseService.getPeriods();
        final logs = await SupabaseService.getDailyLogs();
        if (mounted) {
          setState(() {
            _periods = periods;
            _dailyLogs = logs;
          });
        }
      }
    } catch (e) {
      // tampilkan data kosong jika gagal
    } finally {
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const HistoryWelcomeBanner(),
                      const SizedBox(height: 20),
                      QuickSummaryRow(periods: _periods),
                      const SizedBox(height: 24),
                      PeriodCalendar(
                        periods: _periods,
                        onDayTap: (day, currentMonth) {
                          DailyDetailSheet.show(
                            context: context,
                            day: day,
                            currentMonth: currentMonth,
                            dailyLogs: _dailyLogs,
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildAddDataButton(),
                      const SizedBox(height: 32),
                      HistoryList(periods: _periods),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildAddDataButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, AppRoutes.logHarian);
      },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.secondaryContainer,
          foregroundColor: AppTheme.onSecondaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit_calendar, size: 24),
            SizedBox(width: 12),
            Text(
              'Tambah / Ubah Data',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
