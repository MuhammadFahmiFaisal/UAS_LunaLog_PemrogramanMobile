import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/models.dart';

class QuickSummaryRow extends StatelessWidget {
  final List<Period> periods;

  const QuickSummaryRow({super.key, required this.periods});

  int get _averageCycleLength {
    if (periods.length >= 2) {
      final sortedPeriods = List<Period>.from(periods)
        ..sort((a, b) => a.startDate.compareTo(b.startDate));
      int totalCycleLength = 0;
      for (int i = 1; i < sortedPeriods.length; i++) {
        totalCycleLength += sortedPeriods[i].startDate
            .difference(sortedPeriods[i - 1].startDate)
            .inDays;
      }
      return (totalCycleLength / (sortedPeriods.length - 1)).round();
    }
    return 28;
  }

  @override
  Widget build(BuildContext context) {
    String avgCycle = '-';
    String avgDuration = '-';
    if (periods.length >= 2) {
      avgCycle = '$_averageCycleLength';
    }
    if (periods.isNotEmpty) {
      final periodsWithDuration = periods.where((p) => p.dayCount > 0).toList();
      if (periodsWithDuration.isNotEmpty) {
        final totalDuration = periodsWithDuration.fold(0, (sum, p) => sum + p.dayCount);
        avgDuration = '${(totalDuration / periodsWithDuration.length).round()}';
      }
    }

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            label: 'Rata-rata Siklus',
            value: avgCycle,
            unit: avgCycle != '-' ? 'hari' : '',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            label: 'Durasi',
            value: avgDuration,
            unit: avgDuration != '-' ? 'hari' : '',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            label: 'Total Siklus',
            value: '${periods.length}',
            unit: '',
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String label,
    required String value,
    required String unit,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppTheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
              children: [
                TextSpan(text: value),
                if (unit.isNotEmpty)
                  TextSpan(
                    text: ' $unit',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
