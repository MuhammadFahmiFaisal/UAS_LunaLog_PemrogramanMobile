import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/models.dart';

class CategorySection extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;
  final List<Article> articles;

  const CategorySection({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.articles,
  });

  @override
  Widget build(BuildContext context) {
    final dietCount = articles.where((a) =>
        a.category.toLowerCase().contains('nutrisi') ||
        a.category.toLowerCase().contains('diet')).length;
    final sleepCount = articles.where((a) => a.category.toLowerCase().contains('tidur')).length;
    final mentalCount = articles.where((a) => a.category.toLowerCase().contains('mental')).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Kategori Topik',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppTheme.primary,
              ),
            ),
            if (selectedCategory != null)
              TextButton(
                onPressed: () => onCategorySelected(null),
                child: const Text(
                  'Bersihkan Filter',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildCategoryCard(
                categoryName: 'Nutrisi & Diet',
                icon: Icons.restaurant,
                iconBg: AppTheme.secondaryContainer,
                iconColor: AppTheme.onSecondaryContainer,
                title: 'Nutrisi & Diet',
                subtitle: '$dietCount Artikel',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCategoryCard(
                categoryName: 'Kesehatan Tidur',
                icon: Icons.bedtime,
                iconBg: AppTheme.primaryFixed,
                iconColor: AppTheme.onPrimaryContainer,
                title: 'Kesehatan Tidur',
                subtitle: '$sleepCount Artikel',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildCategoryCard(
          categoryName: 'Kesehatan Mental',
          icon: Icons.favorite,
          iconBg: AppTheme.tertiaryContainer,
          iconColor: AppTheme.onTertiaryContainer,
          title: 'Kesehatan Mental',
          subtitle: 'Menjaga ketenangan pikiran ($mentalCount Artikel).',
          isWide: true,
        ),
      ],
    );
  }

  Widget _buildCategoryCard({
    required String categoryName,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    bool isWide = false,
  }) {
    final isSelected = selectedCategory?.toLowerCase().trim() == categoryName.toLowerCase().trim();

    return GestureDetector(
      onTap: () {
        if (isSelected) {
          onCategorySelected(null);
        } else {
          onCategorySelected(categoryName);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryContainer.withValues(alpha: 0.1)
              : AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primary : Colors.transparent,
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
        child: isWide
            ? Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: iconBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: AppTheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppTheme.outlineVariant,
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.outline,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
