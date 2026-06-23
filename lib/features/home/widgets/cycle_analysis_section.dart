import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class CycleAnalysisSection extends StatelessWidget {
  final int cycleLength;
  final int periodDuration;

  const CycleAnalysisSection({
    super.key,
    required this.cycleLength,
    required this.periodDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.analytics,
              color: AppTheme.statusMedium,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Analisis Siklus',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppTheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildAnalysisCard(
                label: 'Rata-rata Siklus',
                value: '$cycleLength',
                unit: 'hari',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildAnalysisCard(
                label: 'Rata-rata Durasi',
                value: '$periodDuration',
                unit: 'hari',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnalysisCard({
    required String label,
    required String value,
    required String unit,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineAccent),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A6F3347),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            unit,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
