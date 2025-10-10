import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../injection_container.dart';
import '../../../domain/entities/article.dart';
import '../../../utils/tag_colors.dart';
import '../../../utils/date_formatter.dart';
import '../../themes/app_theme.dart';
import '../../blocs/discover/articles/articles.dart';

class ArticlesView extends StatelessWidget {
  const ArticlesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ArticlesBloc>()..add(const ArticlesLoadRequested()),
      child: const _ArticlesView(),
    );
  }
}

class _ArticlesView extends StatelessWidget {
  const _ArticlesView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticlesBloc, ArticlesState>(
      builder: (context, state) {
        return Container(
          color: AppTheme.getBackgroundColor(context),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Filter Section
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterButton(
                        context: context,
                        label: 'Sort: ${state.selectedSort}',
                        items: const ['Newest First', 'Oldest First'],
                        onSelected: (value) {
                          context.read<ArticlesBloc>().add(ArticlesSortChanged(value));
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildFilterButton(
                        context: context,
                        label: 'Topic: ${state.selectedTopic}',
                        items: const ['All Topics', 'DeFi', 'Stablecoins', 'Markets', 'Analysis'],
                        onSelected: (value) {
                          context.read<ArticlesBloc>().add(ArticlesFilterByTopic(value));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Articles List
                Expanded(
                  child: _buildArticlesList(context, state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterButton({
    required BuildContext context,
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
            .map(
              (item) => PopupMenuItem<String>(
                value: item,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.getSurfaceColor(context),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item,
                    style: TextStyle(
                      color: AppTheme.getTextPrimaryColor(context),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
        offset: const Offset(0, 50),
        color: AppTheme.getSurfaceColor(context),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: AppTheme.getBorderColor(context),
            width: 1,
          ),
        ),
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
                    color: AppTheme.getTextPrimaryColor(context),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.expand_more,
                size: 22,
                color: AppTheme.getTextPrimaryColor(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticlesList(BuildContext context, ArticlesState state) {
    if (state.status == ArticlesStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF00D4AA),
        ),
      );
    }

    if (state.status == ArticlesStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.getTextSecondaryColor(context),
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading articles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppTheme.getTextSecondaryColor(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.errorMessage ?? 'Please try again',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.getTextSecondaryColor(context),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<ArticlesBloc>().add(const ArticlesRefreshRequested());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00D4AA),
              ),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    final articles = state.filteredArticles;

    if (articles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 64,
              color: AppTheme.getTextSecondaryColor(context),
            ),
            const SizedBox(height: 16),
            Text(
              'No articles found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppTheme.getTextSecondaryColor(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new content',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.getTextSecondaryColor(context),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFF00D4AA),
      onRefresh: () async {
        context.read<ArticlesBloc>().add(const ArticlesRefreshRequested());
      },
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: articles.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final article = articles[index];
          return _buildArticleCard(context, article);
        },
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, Article article) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: AppTheme.getCardBackgroundColor(context),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          // Show loading indicator
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text('Opening article...'),
                ],
              ),
              backgroundColor: AppTheme.primaryColor,
              duration: const Duration(seconds: 1),
            ),
          );
          
          await _openArticleUrl(context, article.url, article.title);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Article header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.getTextPrimaryColor(context),
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${article.source} • ${DateFormatter.formatRelativeDate(article.publishedAt)}',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.getTextSecondaryColor(context),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Article summary
              if (article.summary.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  article.summary,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.getTextSecondaryColor(context),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
              // Key Topics - using TagColors for dynamic coloring
              if (article.keyTopics.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: article.keyTopics.map((topic) {
                    final tagColor = TagColors.getTagColor(topic);
                    final textColor = TagColors.getTextColorForBg(tagColor);
                    
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: tagColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: tagColor.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        topic.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          color: textColor,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                          letterSpacing: 0.6,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }



  /// Opens article URL in external browser
  Future<void> _openArticleUrl(BuildContext context, String url, String title) async {
    try {
      final Uri uri = Uri.parse(url);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not open article: $title'),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Copy URL',
                textColor: Colors.white,
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: url));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('URL copied to clipboard'),
                      backgroundColor: Color(0xFF00D4AA),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening article: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}