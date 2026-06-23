import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/models.dart';

class StatsRow extends StatelessWidget {
  final DailyLog? todayLog;

  const StatsRow({super.key, this.todayLog});

  @override
  Widget build(BuildContext context) {
    final moodLabel = todayLog?.mood != null
        ? _moodToString(todayLog!.mood)
        : '-';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.favorite_outline,
              iconColor: AppTheme.primary,
              label: 'Mood Hari Ini',
              value: moodLabel,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              icon: Icons.water_drop_outlined,
              iconColor: AppTheme.secondary,
              label: 'Aliran',
              value: todayLog?.flow != null
                  ? _flowToString(todayLog!.flow)
                  : '-',
            ),
          ),
        ],
      ),
    );
  }

  String _moodToString(Mood? mood) {
    switch (mood) {
      case Mood.happy: return 'Senang 😊';
      case Mood.calm: return 'Tenang 😌';
      case Mood.sad: return 'Sedih 😢';
      case Mood.anxious: return 'Cemas 😰';
      case Mood.angry: return 'Marah 😡';
      case Mood.tired: return 'Lelah 😴';
      default: return '-';
    }
  }

  String _flowToString(FlowLevel flow) {
    switch (flow) {
      case FlowLevel.light: return 'Ringan';
      case FlowLevel.medium: return 'Sedang';
      case FlowLevel.heavy: return 'Deras';
      case FlowLevel.none: return 'Tidak ada';
    }
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppTheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
