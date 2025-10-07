class Article {
  final String title;
  final String url;
  final String source;
  final DateTime publishedAt;
  final String summary;
  final String category;
  final List<String> keyTopics;

  Article({
    required this.title,
    required this.url,
    required this.source,
    required this.publishedAt,
    required this.summary,
    required this.category,
    required this.keyTopics,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Article &&
        other.title == title &&
        other.url == url &&
        other.source == source &&
        other.publishedAt == publishedAt &&
        other.summary == summary &&
        other.category == category &&
        _listEquals(other.keyTopics, keyTopics);
  }

  @override
  int get hashCode {
    return title.hashCode ^
        url.hashCode ^
        source.hashCode ^
        publishedAt.hashCode ^
        summary.hashCode ^
        category.hashCode ^
        keyTopics.hashCode;
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    if (identical(a, b)) return true;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}