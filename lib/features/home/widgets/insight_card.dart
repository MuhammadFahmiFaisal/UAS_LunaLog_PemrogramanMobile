import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/models/models.dart';

class InsightCard extends StatelessWidget {
  final UserProfile? profile;

  const InsightCard({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    // Menghitung fase siklus
    final lastDate = profile?.lastPeriodDate ??
        DateTime.now().subtract(const Duration(days: 14));
    final daysSinceLastPeriod = DateTime.now().difference(lastDate).inDays;

    String phaseTitle;
    String phaseDescription;

    if (daysSinceLastPeriod <= (profile?.periodDuration ?? 5)) {
      phaseTitle = 'Fase Menstruasi';
      phaseDescription = 'Tubuh sedang melepaskan lapisan rahim. Beristirahatlah yang cukup dan konsumsi cairan hangat.';
    } else if (daysSinceLastPeriod <= 13) {
      phaseTitle = 'Fase Folikular';
      phaseDescription = 'Kadar estrogen sedang meningkat. Ini adalah waktu yang tepat untuk berolahraga dan mencoba hal baru.';
    } else if (daysSinceLastPeriod <= 16) {
      phaseTitle = 'Fase Ovulasi';
      phaseDescription = 'Energi Anda mungkin sedang berada di puncaknya! Waktu yang baik untuk bersosialisasi.';
    } else {
      phaseTitle = 'Fase Luteal';
      phaseDescription = 'Tubuh bersiap untuk siklus berikutnya. Kurangi kafein jika Anda merasa mudah lelah atau kram.';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.outlineAccent.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.08),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryFixed,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline,
                    color: AppTheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Insight Hari Ini',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            color: AppTheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text: '$phaseTitle: ',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            TextSpan(
                              text: phaseDescription,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.wawasanLaporan);
                        },
                        child: const Row(
                          children: [
                            Text(
                              'Baca selengkapnya',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.primary,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward,
                              size: 14,
                              color: AppTheme.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppTheme.primaryFixed,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.self_improvement,
                      color: AppTheme.onPrimaryContainer,
                      size: 48,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
