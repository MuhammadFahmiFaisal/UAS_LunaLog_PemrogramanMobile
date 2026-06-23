import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/models.dart';

class DailyTipCard extends StatelessWidget {
  final List<Article> articles;

  const DailyTipCard({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    // Default values (fallback)
    String tipTitle = 'REKOMENDASI';
    String tipText = 'Minum air hangat dengan jahe dapat membantu merelaksasi otot rahim yang tegang.';

    // Find the first article that has tips
    if (articles.isNotEmpty) {
      try {
        final articleWithTips = articles.firstWhere(
          (a) => a.tips.isNotEmpty,
          orElse: () => const Article(id: '', title: '', category: '', content: ''),
        );

        if (articleWithTips.id.isNotEmpty && articleWithTips.tips.isNotEmpty) {
          final firstTip = articleWithTips.tips.first;
          tipTitle = firstTip.title.toUpperCase();
          tipText = firstTip.description;
        }
      } catch (e) {
        // Safe fallback in case of errors
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tips Hari Ini',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A6F3347),
                blurRadius: 20,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -8,
                right: -8,
                child: Icon(
                  Icons.format_quote,
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  size: 96,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: AppTheme.onPrimaryContainer.withValues(alpha: 0.7),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        tipTitle,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.onPrimaryContainer.withValues(alpha: 0.8),
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '"$tipText"',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      color: AppTheme.onPrimaryContainer,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.onPrimaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
