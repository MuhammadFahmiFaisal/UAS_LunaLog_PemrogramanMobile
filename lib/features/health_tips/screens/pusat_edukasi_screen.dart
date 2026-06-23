import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/models.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/supabase_service.dart';
import '../../../core/data/dummy_data.dart';
import '../widgets/hero_article_card.dart';
import '../widgets/category_section.dart';
import '../widgets/daily_tip_card.dart';
import '../widgets/reading_list_section.dart';

class PusatEdukasiScreen extends StatefulWidget {
  const PusatEdukasiScreen({super.key});

  @override
  State<PusatEdukasiScreen> createState() => _PusatEdukasiScreenState();
}

class _PusatEdukasiScreenState extends State<PusatEdukasiScreen> {
  List<Article> _articles = [];
  List<Article> _filteredArticles = [];
  String? _selectedCategory;
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      List<Article> articles = [];
      try {
        articles = await SupabaseService.getArticles();
        if (articles.isEmpty) {
          // Seeding database with DummyData.articles
          for (var article in DummyData.articles) {
            await SupabaseService.client.from('articles').upsert(article.toJson());
          }
          articles = await SupabaseService.getArticles();
        }
      } catch (e) {
        // Fallback to local dummy data if database is offline or unreachable
        articles = DummyData.articles;
      }
      
      if (mounted) {
        setState(() {
          _articles = articles;
          _filteredArticles = articles;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat artikel: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _applyFilter() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredArticles = _articles.where((article) {
        final matchesSearch = query.isEmpty ||
            article.title.toLowerCase().contains(query) ||
            article.content.toLowerCase().contains(query);
        final matchesCategory = _selectedCategory == null ||
            article.category.toLowerCase().trim() == _selectedCategory!.toLowerCase().trim();
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    _applyFilter();
  }

  void _onCategorySelected(String? category) {
    setState(() {
      _selectedCategory = category;
    });
    _applyFilter();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(child: CircularProgressIndicator(color: AppTheme.primary)),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildSearchBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_searchController.text.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildSearchResults(),
                    ] else ...[
                      const SizedBox(height: 16),
                      HeroArticleCard(articles: _articles),
                      const SizedBox(height: 24),
                      CategorySection(
                        selectedCategory: _selectedCategory,
                        onCategorySelected: _onCategorySelected,
                        articles: _articles,
                      ),
                      const SizedBox(height: 24),
                      DailyTipCard(articles: _articles),
                      const SizedBox(height: 24),
                      ReadingListSection(
                        articles: _selectedCategory == null ? _articles : _filteredArticles,
                      ),
                    ],
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 64,
      color: AppTheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft,
      child: const Text(
        'Pusat Edukasi',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppTheme.primary,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: const InputDecoration(
          icon: Icon(Icons.search, color: AppTheme.outlineVariant),
          hintText: 'Cari artikel kesehatan...',
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontFamily: 'Inter',
            color: AppTheme.outlineVariant,
          ),
        ),
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          color: AppTheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_filteredArticles.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        alignment: Alignment.center,
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppTheme.outlineVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada artikel yang cocok dengan pencarian Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hasil Pencarian (${_filteredArticles.length})',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        ..._filteredArticles.map((article) {
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
