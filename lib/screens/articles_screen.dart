import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

/// Articles screen for news and articles content
class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  String _dateFilter = 'Newest First';
  String _topicFilter = 'All Topics';
  bool _isLoading = false;

  final List<Article> _articles = [
    Article(
      title: 'Understanding Maritime Anchor Systems: A Complete Guide',
      source: 'Marine Technology',
      publishedAt: DateTime.now().subtract(const Duration(days: 1)),
      summary: 'Comprehensive overview of modern anchor technologies and their applications in various maritime conditions.',
      keyTopics: ['Marine Technology', 'Safety', 'Equipment'],
      url: 'https://example.com/article1',
    ),
    Article(
      title: 'Weather Patterns and Anchoring Safety',
      source: 'Sailing World',
      publishedAt: DateTime.now().subtract(const Duration(days: 3)),
      summary: 'How to read weather patterns and adjust your anchoring strategy for maximum safety.',
      keyTopics: ['Weather', 'Safety', 'Navigation'],
      url: 'https://example.com/article2',
    ),
    Article(
      title: 'Digital Monitoring Systems for Boats',
      source: 'Tech Marine',
      publishedAt: DateTime.now().subtract(const Duration(days: 5)),
      summary: 'Latest innovations in boat monitoring technology and their impact on maritime safety.',
      keyTopics: ['Technology', 'Innovation', 'Safety'],
      url: 'https://example.com/article3',
    ),
  ];

  List<Article> get _filteredArticles {
    List<Article> filtered = List.from(_articles);
    
    // Filter by topic
    if (_topicFilter != 'All Topics') {
      filtered = filtered.where((article) => 
        article.keyTopics.contains(_topicFilter)).toList();
    }
    
    // Sort by date
    if (_dateFilter == 'Newest First') {
      filtered.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    } else {
      filtered.sort((a, b) => a.publishedAt.compareTo(b.publishedAt));
    }
    
    return filtered;
  }

  List<String> get _uniqueTopics {
    final topics = <String>{'All Topics'};
    for (final article in _articles) {
      topics.addAll(article.keyTopics);
    }
    return topics.toList();
  }

  void _refreshArticles() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      SnackBarHelper.showSuccess(context, 'Articles refreshed');
    }
  }

  void _launchUrl(String url) {
    SnackBarHelper.showInfo(context, 'Opening article...');
    // In a real app, you would use url_launcher package
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF8F8F8) // Softer off-white for light mode
          : const Color(0xFF1E1E1E), // Softer dark gray for dark mode
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? const Color(0xFFF8F8F8) // Softer off-white for light mode
            : const Color(0xFF1E1E1E), // Softer dark gray for dark mode
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        title: const Text(
          'Articles',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Theme.of(context).iconTheme.color),
            onPressed: _refreshArticles,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00D4AA)))
          : Column(
              children: [
                // Filter Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      // Date Filter
                      Expanded(
                        child: _buildFilterButton(
                          label: 'Sort: $_dateFilter',
                          items: const ['Newest First', 'Oldest First'],
                          onSelected: (value) {
                            setState(() {
                              _dateFilter = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Topic Filter
                      Expanded(
                        child: _buildFilterButton(
                          label: 'Topic: $_topicFilter',
                          items: _uniqueTopics,
                          onSelected: (value) {
                            setState(() {
                              _topicFilter = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Articles List
                Expanded(
                  child: RefreshIndicator(
                    color: const Color(0xFF00D4AA),
                    onRefresh: () async => _refreshArticles(),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredArticles.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final article = _filteredArticles[index];
                        return _buildArticleCard(article);
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildFilterButton({
    required String label,
    required List<String> items,
    required void Function(String) onSelected,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: Theme.of(context).brightness == Brightness.dark
              ? [const Color(0xFF2A2A2A), const Color(0xFF3A3A3A)]
              : [const Color(0xFFFFFFFF), const Color(0xFFF5F5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.25)
                : Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: PopupMenuButton<String>(
        onSelected: onSelected,
        itemBuilder: (context) => items
            .map((item) => PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : const Color(0xFF1A1A1A),
                    fontFamily: 'Inter',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.expand_more,
                size: 22,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : const Color(0xFF1A1A1A),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleCard(Article article) {
    final dateStr = '${article.publishedAt.day}/${article.publishedAt.month}/${article.publishedAt.year}';
    
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _launchUrl(article.url),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : const Color(0xFF2A2A2A),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${article.source} • $dateStr',
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF9CA3AF)
                      : Colors.grey[600],
                  fontFamily: 'Inter',
                ),
              ),
              if (article.summary.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  article.summary,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFFE5E7EB)
                        : Colors.grey[800],
                    fontFamily: 'Inter',
                  ),
                ),
              ],
              if (article.keyTopics.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: article.keyTopics.map((topic) => _buildTopicChip(topic)).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopicChip(String topic) {
    final colors = {
      'Marine Technology': Colors.blue,
      'Safety': Colors.red,
      'Equipment': Colors.orange,
      'Weather': Colors.green,
      'Navigation': Colors.purple,
      'Technology': Colors.cyan,
      'Innovation': Colors.pink,
    };
    
    final color = colors[topic] ?? Colors.grey;
    
    return Chip(
      label: Text(
        topic,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontFamily: 'Inter',
        ),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide.none,
      ),
    );
  }
}

/// Data model for articles
class Article {
  final String title;
  final String source;
  final DateTime publishedAt;
  final String summary;
  final List<String> keyTopics;
  final String url;

  Article({
    required this.title,
    required this.source,
    required this.publishedAt,
    required this.summary,
    required this.keyTopics,
    required this.url,
  });
}