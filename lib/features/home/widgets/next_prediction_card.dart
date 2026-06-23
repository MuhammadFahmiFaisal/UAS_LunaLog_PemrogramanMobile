import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class NextPredictionCard extends StatelessWidget {
  final int cycleLength;
  final DateTime? lastPeriodDate;

  const NextPredictionCard({
    super.key,
    required this.cycleLength,
    this.lastPeriodDate,
  });

  @override
  Widget build(BuildContext context) {
    final lastDate = lastPeriodDate ?? DateTime.now().subtract(const Duration(days: 14));
    final daysUntilNext = cycleLength -
        DateTime.now().difference(lastDate).inDays;
    final progress = (cycleLength - daysUntilNext) / cycleLength;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.primaryContainer.withValues(alpha: 0.2),
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A6F3347),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PREDIKSI BERIKUTNYA',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryContainer,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatNextPeriodDate(daysUntilNext),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.calendar_month,
                color: AppTheme.primaryContainer.withValues(alpha: 0.4),
                size: 40,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: AppTheme.surfaceContainerLow,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sekitar $daysUntilNext hari lagi sebelum siklus berikutnya dimulai.',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNextPeriodDate(int daysUntilNext) {
    final nextDate = DateTime.now().add(Duration(days: daysUntilNext));
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${nextDate.day} ${months[nextDate.month - 1]} ${nextDate.year}';
  }
}
