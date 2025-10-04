import 'package:flutter_bloc/flutter_bloc.dart';
import 'faq_event.dart';
import 'faq_state.dart';
import '../../models/faq_models.dart';

/// BLoC to manage FAQ screen state
class FaqBloc extends Bloc<FaqEvent, FaqState> {
  FaqBloc() : super(const FaqState()) {
    on<FaqLoadRequested>(_onFaqLoadRequested);
    on<FaqRefreshRequested>(_onFaqRefreshRequested);
    on<FaqCategoryToggled>(_onFaqCategoryToggled);
    on<FaqItemToggled>(_onFaqItemToggled);
  }

  Future<void> _onFaqLoadRequested(
    FaqLoadRequested event,
    Emitter<FaqState> emit,
  ) async {
    emit(state.copyWith(status: FaqStatus.loading));
    
    try {
      // Simulate loading FAQ information
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Load FAQ categories based on your images
      final categories = _getFaqCategories();
      
      emit(state.copyWith(
        status: FaqStatus.success,
        categories: categories,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: FaqStatus.failure,
        errorMessage: 'Failed to load FAQ information: $error',
      ));
    }
  }

  Future<void> _onFaqRefreshRequested(
    FaqRefreshRequested event,
    Emitter<FaqState> emit,
  ) async {
    emit(state.copyWith(status: FaqStatus.loading));
    
    try {
      // Simulate refreshing FAQ information
      await Future.delayed(const Duration(milliseconds: 300));
      
      final categories = _getFaqCategories();
      
      emit(state.copyWith(
        status: FaqStatus.success,
        categories: categories,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: FaqStatus.failure,
        errorMessage: 'Failed to refresh FAQ information: $error',
      ));
    }
  }

  void _onFaqCategoryToggled(
    FaqCategoryToggled event,
    Emitter<FaqState> emit,
  ) {
    final updatedCategories = state.categories.map((category) {
      if (category.id == event.categoryId) {
        return category.copyWith(isExpanded: !category.isExpanded);
      }
      return category;
    }).toList();

    emit(state.copyWith(categories: updatedCategories));
  }

  void _onFaqItemToggled(
    FaqItemToggled event,
    Emitter<FaqState> emit,
  ) {
    final updatedCategories = state.categories.map((category) {
      if (category.id == event.categoryId) {
        final updatedQuestions = category.questions.map((item) {
          if (item.id == event.itemId) {
            return item.copyWith(isExpanded: !item.isExpanded);
          }
          return item;
        }).toList();
        
        return category.copyWith(questions: updatedQuestions);
      }
      return category;
    }).toList();

    emit(state.copyWith(categories: updatedCategories));
  }

  List<FaqCategory> _getFaqCategories() {
    return [
      FaqCategory(
        id: 'about',
        title: 'About AnchorWatch',
        questions: [
          const FaqItem(
            id: 'what-is',
            question: 'What is AnchorWatch?',
            answer: 'AnchorWatch is an AI-powered financial platform that monitors stablecoin flows and macroeconomic indicators, helping users understand digital asset trends in a global economic context.',
          ),
          const FaqItem(
            id: 'who-can-use',
            question: 'Who can use AnchorWatch?',
            answer: 'Financial analysts, crypto developers, researchers, and general users interested in blockchain activity and macro trends can use AnchorWatch.',
          ),
          const FaqItem(
            id: 'support-decision-making',
            question: 'How does AnchorWatch support economic decision-making?',
            answer: 'It provides interactive dashboards, real-time alerts, and AI-generated insights to help users detect patterns, anomalies, and correlations between stablecoins and economic indicators.',
          ),
        ],
      ),
      FaqCategory(
        id: 'mobile-app',
        title: 'Using the Mobile App',
        questions: [
          const FaqItem(
            id: 'features-available',
            question: 'What features are available on the AnchorWatch mobile app?',
            answer: 'Users can view live stablecoin data, visualize regional trends, compare blockchain activity with inflation/GDP, and read AI-generated summaries.',
          ),
          const FaqItem(
            id: 'customize-dashboard',
            question: 'Can I customize my dashboard?',
            answer: 'Yes, users can filter data by region, stablecoin, and timeframe, and toggle between different economic indicators.',
          ),
          const FaqItem(
            id: 'mobile-available',
            question: 'Is the mobile app available for both Android and iOS?',
            answer: 'Yes, the AnchorWatch app is developed with Flutter and available on both platforms.',
          ),
        ],
      ),
      FaqCategory(
        id: 'data-sources',
        title: 'Data Sources and Insights',
        questions: [
          const FaqItem(
            id: 'where-data-from',
            question: 'Where does AnchorWatch get its data?',
            answer: 'It pulls blockchain data from Dune Analytics and CoinGecko APIs, and economic data from sources like the World Bank, IMF, and FRED.',
          ),
          const FaqItem(
            id: 'data-updated',
            question: 'How often is the data updated?',
            answer: 'Data is refreshed based on scheduled ETL jobs managed through Celery. Most updates occur hourly or daily, depending on the data source.',
          ),
          const FaqItem(
            id: 'ai-insights-reliable',
            question: 'Are the AI-generated insights reliable?',
            answer: 'AnchorWatch uses LLMs (via LangChain) for summarization. While useful for trend detection, users should still validate critical financial decisions independently.',
          ),
        ],
      ),
      FaqCategory(
        id: 'technical-security',
        title: 'Technical and Security',
        questions: [
          const FaqItem(
            id: 'data-secure',
            question: 'Is my data secure on AnchorWatch?',
            answer: 'Yes. User data is encrypted and stored securely in MongoDB Atlas. Secrets and credentials are managed via AWS Secrets Manager.',
          ),
          const FaqItem(
            id: 'personal-data-shared',
            question: 'Will my personal data be shared?',
            answer: 'No, personal data is not shared with third parties. Usage data may be anonymized for platform improvements.',
          ),
          const FaqItem(
            id: 'app-cloud-hosted',
            question: 'Is the app cloud-hosted?',
            answer: 'Yes, AnchorWatch runs on AWS infrastructure using containerized deployments for scalability and reliability.',
          ),
        ],
      ),
      FaqCategory(
        id: 'eligibility-requirements',
        title: 'Eligibility and Requirements',
        questions: [
          const FaqItem(
            id: 'financial-background-needed',
            question: 'Do I need a financial background to use the app?',
            answer: 'No. The mobile app is designed with a minimalist UI and AI summaries to help users of all experience levels interpret complex data.',
          ),
          const FaqItem(
            id: 'account-needed',
            question: 'Do I need an account to use AnchorWatch?',
            answer: 'Yes, registration is required. Admins manage user profiles and permissions via the web panel.',
          ),
          const FaqItem(
            id: 'anchorwatch-free',
            question: 'Is AnchorWatch free to use?',
            answer: 'Currently, the platform is in development/testing phase. Future versions may introduce subscription tiers or institutional pricing.',
          ),
        ],
      ),
      FaqCategory(
        id: 'data-analysis-alerts',
        title: 'Data Analysis and Alerts',
        questions: [
          const FaqItem(
            id: 'detect-stablecoin-depegging',
            question: 'Can AnchorWatch detect stablecoin depegging?',
            answer: 'Yes, the app highlights mint/burn anomalies and depegging risks using rule-based alerts and AI-assisted detection.',
          ),
          const FaqItem(
            id: 'llm-summaries',
            question: 'What are LLM summaries?',
            answer: 'These are AI-generated text summaries that explain market shifts or anomalies in simple language, filterable by asset or time range.',
          ),
          const FaqItem(
            id: 'receive-alerts',
            question: 'Can I receive alerts for unusual activity?',
            answer: 'Yes, users can opt in to receive alerts for major mint/burn events, volatility, or macro shifts.',
          ),
        ],
      ),
    ];
  }
}