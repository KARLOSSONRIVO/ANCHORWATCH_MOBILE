import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/faq/faq.dart';
import '../widgets/loading_widget.dart';
import '../models/faq_models.dart';

/// FAQ screen with BLoC architecture
class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FaqBloc()..add(const FaqLoadRequested()),
      child: const _FaqView(),
    );
  }
}

class _FaqView extends StatelessWidget {
  const _FaqView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        foregroundColor: Colors.white,
        title: const Text(
          'FAQS',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<FaqBloc, FaqState>(
        builder: (context, state) {
          switch (state.status) {
            case FaqStatus.loading:
              return const Center(child: LoadingWidget());
            case FaqStatus.failure:
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${state.errorMessage}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontFamily: 'Inter',
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<FaqBloc>().add(const FaqRefreshRequested());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00BCD4),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            case FaqStatus.success:
              return _buildFaqList(context, state.categories);
            case FaqStatus.initial:
              return const Center(child: LoadingWidget());
          }
        },
      ),
    );
  }

  Widget _buildFaqList(BuildContext context, List<FaqCategory> categories) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildFaqCategory(context, category);
      },
    );
  }

  Widget _buildFaqCategory(BuildContext context, FaqCategory category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Category Header
          InkWell(
            onTap: () {
              context.read<FaqBloc>().add(FaqCategoryToggled(category.id));
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      category.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    category.isExpanded ? Icons.remove : Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          // Category Content
          if (category.isExpanded) ...[
            const Divider(
              color: Color(0xFF2D2D2D),
              height: 1,
              thickness: 1,
            ),
            ...category.questions.map((question) => _buildFaqItem(context, category.id, question)),
          ],
        ],
      ),
    );
  }

  Widget _buildFaqItem(BuildContext context, String categoryId, FaqItem item) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
      ),
      child: Column(
        children: [
          // Question Header
          InkWell(
            onTap: () {
              context.read<FaqBloc>().add(FaqItemToggled(categoryId, item.id));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.question,
                      style: const TextStyle(
                        color: Color(0xFFB0B0B0),
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Icon(
                    item.isExpanded ? Icons.remove : Icons.add,
                    color: const Color(0xFFB0B0B0),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          // Answer Content
          if (item.isExpanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                item.answer,
                style: const TextStyle(
                  color: Color(0xFF909090),
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
            ),

        ],
      ),
    );
  }
}