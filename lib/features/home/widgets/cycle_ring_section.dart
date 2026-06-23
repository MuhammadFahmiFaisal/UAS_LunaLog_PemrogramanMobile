import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/models.dart';

class CycleRingSection extends StatelessWidget {
  final UserProfile? profile;

  const CycleRingSection({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    final cycleLength = profile?.cycleLength ?? 28;
    final lastDate = profile?.lastPeriodDate ??
        DateTime.now().subtract(const Duration(days: 14));
    final daysSinceLastPeriod = DateTime.now().difference(lastDate).inDays;
    final daysUntilNextPeriod = cycleLength - daysSinceLastPeriod;

    // Tentukan fase siklus
    String cyclePhase;
    if (daysSinceLastPeriod <= (profile?.periodDuration ?? 5)) {
      cyclePhase = 'Fase Menstruasi';
    } else if (daysSinceLastPeriod <= 13) {
      cyclePhase = 'Fase Folikular';
    } else if (daysSinceLastPeriod <= 16) {
      cyclePhase = 'Fase Ovulasi';
    } else {
      cyclePhase = 'Fase Luteal';
    }

    return Column(
      children: [
        SizedBox(
          width: 240,
          height: 240,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 240,
                height: 240,
                child: CustomPaint(
                  painter: _CycleRingPainter(
                    progress: (daysSinceLastPeriod / cycleLength).clamp(0.0, 1.0),
                    backgroundColor: AppTheme.outlineVariant.withValues(alpha: 0.3),
                    progressColor1: AppTheme.primary,
                    progressColor2: AppTheme.statusMedium,
                  ),
                ),
              ),
              Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.surfaceWhite,
                  border: Border.all(
                    color: AppTheme.outlineAccent.withValues(alpha: 0.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.08),
                      blurRadius: 30,
                      spreadRadius: -5,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'HARI',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.onSurfaceVariant,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$daysSinceLastPeriod',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 56,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            AppTheme.primaryContainer.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        cyclePhase,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      daysUntilNextPeriod > 0
                          ? '$daysUntilNextPeriod hari lagi periode'
                          : 'Periode mungkin sudah dimulai',
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
          ),
        ),
      ],
    );
  }
}

class _CycleRingPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor1;
  final Color progressColor2;

  _CycleRingPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor1,
    required this.progressColor2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 12) / 2;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius, bgPaint);

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius);
    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress.clamp(0.0, 1.0);

    final gradient = LinearGradient(
      colors: [progressColor1, progressColor2],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    progressPaint.shader = gradient.createShader(rect);

    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
