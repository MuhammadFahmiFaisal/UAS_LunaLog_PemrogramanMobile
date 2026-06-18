class Article {
  final String id;
  final String title;
  final String category;
  final String content;
  final String? imageUrl;
  final int readTimeMinutes;
  final List<TipItem> tips;

  const Article({
    required this.id,
    required this.title,
    required this.category,
    required this.content,
    this.imageUrl,
    this.readTimeMinutes = 5,
    this.tips = const [],
  });
}

class TipItem {
  final String title;
  final String description;
  final String? icon;

  const TipItem({
    required this.title,
    required this.description,
    this.icon,
  });
}
