import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/models/models.dart';

class ReadingListSection extends StatefulWidget {
  final List<Article> articles;

  const ReadingListSection({super.key, required this.articles});

  @override
  State<ReadingListSection> createState() => _ReadingListSectionState();
}

class _ReadingListSectionState extends State<ReadingListSection> {
  bool _showAllArticles = false;

  @override
  Widget build(BuildContext context) {
    if (widget.articles.isEmpty) {
      return const SizedBox.shrink();
    }
    
    final displayArticles = _showAllArticles ? widget.articles : widget.articles.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Lanjut Membaca',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppTheme.primary,
              ),
            ),
            if (widget.articles.length > 3)
              TextButton(
                onPressed: () {
                  setState(() {
                    _showAllArticles = !_showAllArticles;
                  });
                },
                child: Text(
                  _showAllArticles ? 'Tampilkan Sedikit' : 'Lihat Semua',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ...displayArticles.map((article) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildReadingItem(context, article),
          );
        }),
      ],
    );
  }

  Widget _buildReadingItem(BuildContext context, Article article) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.detailTips, arguments: article);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppTheme.surfaceWhite,
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A6F3347),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
                color: AppTheme.surfaceContainerLow,
                child: article.imageUrl != null
                    ? Image.network(
                        article.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.article,
                            color: AppTheme.onSurfaceVariant,
                          );
                        },
                      )
                    : const Icon(
                        Icons.article,
                        color: AppTheme.onSurfaceVariant,
                      ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    article.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: AppTheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
