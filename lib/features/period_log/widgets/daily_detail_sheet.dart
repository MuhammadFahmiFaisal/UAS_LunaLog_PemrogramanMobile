import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/models.dart';

class DailyDetailSheet {
  static void show({
    required BuildContext context,
    required int day,
    required DateTime currentMonth,
    required List<DailyLog> dailyLogs,
  }) {
    final date = DateTime(currentMonth.year, currentMonth.month, day);
    final log = dailyLogs.where((l) =>
        l.date.year == date.year &&
        l.date.month == date.month &&
        l.date.day == date.day).firstOrNull;

    final flowLabels = {
      FlowLevel.light: 'Ringan',
      FlowLevel.medium: 'Sedang',
      FlowLevel.heavy: 'Deras',
    };

    final moodEmojis = {
      Mood.happy: '\u{1F60A}',
      Mood.calm: '\u{1F60C}',
      Mood.sad: '\u{1F61E}',
      Mood.anxious: '\u{1F61F}',
      Mood.angry: '\u{1F621}',
      Mood.tired: '\u{1F634}',
    };

    const monthNames = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '$day ${monthNames[currentMonth.month - 1]} ${currentMonth.year}',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            if (log != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          log.flow == FlowLevel.heavy
                              ? Icons.water_drop
                              : Icons.water_drop_outlined,
                          color: AppTheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Aliran: ${flowLabels[log.flow] ?? 'Tidak ada'}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: AppTheme.onSurface,
                          ),
                        ),
                        if (log.mood != null) ...[
                          const Spacer(),
                          Text(
                            moodEmojis[log.mood] ?? '',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ],
                    ),
                    if (log.symptoms.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: log.symptoms.map((s) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryFixed,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              s,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: AppTheme.primary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    if (log.notes != null && log.notes!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        '"${log.notes}"',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.event_note,
                      color: AppTheme.outline,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Belum ada catatan untuk hari ini',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
