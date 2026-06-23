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

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Tanpa Judul',
      category: json['category']?.toString() ?? 'Umum',
      content: json['content']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
      readTimeMinutes: json['read_time_minutes'] as int? ?? 5,
      tips: (json['tips'] as List<dynamic>?)
              ?.map((e) => TipItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'content': content,
      'image_url': imageUrl,
      'read_time_minutes': readTimeMinutes,
      'tips': tips.map((e) => e.toJson()).toList(),
    };
  }
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

  factory TipItem.fromJson(Map<String, dynamic> json) {
    return TipItem(
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      icon: json['icon']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'icon': icon,
    };
  }
}
