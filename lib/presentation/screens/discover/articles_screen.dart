import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../themes/app_theme.dart';
import '../../blocs/discover/articles/articles.dart';

class ArticlesView extends StatelessWidget {
  const ArticlesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArticlesBloc()..add(const ArticlesLoadRequested()),
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

    return ListView.separated(
      itemCount: articles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final article = articles[index];
        return _buildArticleCard(context, article);
      },
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
        onTap: () {
          // TODO: Implement article opening
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening: ${article.title}'),
              backgroundColor: AppTheme.primaryColor,
            ),
          );
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
                          '${article.source} • ${article.date}',
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
              // Topics
              if (article.topics.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: article.topics.map((topic) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        topic,
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
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


}