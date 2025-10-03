import 'package:flutter_bloc/flutter_bloc.dart';
import 'anchorwise_event.dart';
import 'anchorwise_state.dart';

/// BLoC for managing AnchorWise chat functionality
class AnchorWiseBloc extends Bloc<AnchorWiseEvent, AnchorWiseState> {
  AnchorWiseBloc() : super(const AnchorWiseState()) {
    on<AnchorWiseSendMessage>(_onSendMessage);
    on<AnchorWiseLoadHistory>(_onLoadHistory);
    on<AnchorWiseClearConversation>(_onClearConversation);
    on<AnchorWiseToggleTyping>(_onToggleTyping);
  }

  /// Send message and get AI response
  void _onSendMessage(
    AnchorWiseSendMessage event,
    Emitter<AnchorWiseState> emit,
  ) async {
    if (event.message.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: event.message,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );

    final updatedMessages = [...state.messages, userMessage];
    emit(state.copyWith(
      messages: updatedMessages,
      status: AnchorWiseStatus.sending,
    ));

    // Show typing indicator
    emit(state.copyWith(isTyping: true));

    try {
      // Simulate AI processing delay
      await Future.delayed(const Duration(seconds: 2));

      // Generate AI response based on user input
      final aiResponse = _generateAIResponse(event.message);
      
      final aiMessage = ChatMessage(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        content: aiResponse,
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
      );

      final finalMessages = [...updatedMessages, aiMessage];
      
      emit(state.copyWith(
        status: AnchorWiseStatus.idle,
        messages: finalMessages,
        isTyping: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AnchorWiseStatus.error,
        error: 'Failed to send message: $e',
        isTyping: false,
      ));
    }
  }

  /// Load conversation history
  void _onLoadHistory(
    AnchorWiseLoadHistory event,
    Emitter<AnchorWiseState> emit,
  ) async {
    emit(state.copyWith(status: AnchorWiseStatus.loading));

    try {
      // Simulate loading delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock conversation history
      final welcomeMessage = ChatMessage(
        id: 'welcome',
        content: 'Hello! I\'m AnchorWise, your AI assistant for financial insights and market analysis. How can I help you today?',
        sender: MessageSender.ai,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      );

      emit(state.copyWith(
        status: AnchorWiseStatus.idle,
        messages: [welcomeMessage],
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AnchorWiseStatus.error,
        error: 'Failed to load history: $e',
      ));
    }
  }

  /// Clear conversation
  void _onClearConversation(
    AnchorWiseClearConversation event,
    Emitter<AnchorWiseState> emit,
  ) {
    emit(const AnchorWiseState());
    // Reload welcome message
    add(const AnchorWiseLoadHistory());
  }

  /// Toggle typing indicator
  void _onToggleTyping(
    AnchorWiseToggleTyping event,
    Emitter<AnchorWiseState> emit,
  ) {
    emit(state.copyWith(isTyping: event.isTyping));
  }

  /// Generate AI response based on user input
  String _generateAIResponse(String userMessage) {
    final message = userMessage.toLowerCase();

    // Market analysis responses
    if (message.contains('bitcoin') || message.contains('btc')) {
      return 'Bitcoin is currently showing interesting market dynamics. Based on recent on-chain data and trading patterns, I\'m seeing increased institutional interest. The fundamentals remain strong with growing adoption and limited supply. Would you like me to analyze specific metrics?';
    }
    
    if (message.contains('ethereum') || message.contains('eth')) {
      return 'Ethereum continues to evolve with its transition to Proof-of-Stake. The network activity shows healthy DeFi usage and NFT transactions. Layer 2 solutions are gaining traction, which could impact ETH\'s value proposition. What aspect of Ethereum interests you most?';
    }
    
    if (message.contains('usdc') || message.contains('stablecoin')) {
      return 'USDC flows are a key indicator I monitor closely. Recent data shows interesting patterns in institutional adoption and cross-chain movements. Stablecoin market cap changes often precede major market movements. Are you tracking specific USDC metrics?';
    }
    
    if (message.contains('inflation') || message.contains('fed') || message.contains('interest')) {
      return 'Federal Reserve policies and inflation data are crucial macro factors affecting crypto markets. Recent CPI data and Fed communications suggest a complex economic environment. I can help analyze how traditional financial indicators correlate with crypto price movements.';
    }
    
    if (message.contains('market') || message.contains('price') || message.contains('analysis')) {
      return 'Market analysis requires looking at multiple data points: on-chain metrics, sentiment indicators, technical patterns, and macro factors. I can help you understand correlations between different assets and identify potential opportunities. What specific market aspect would you like to explore?';
    }
    
    if (message.contains('defi') || message.contains('yield')) {
      return 'DeFi markets are showing interesting yield opportunities across different protocols. TVL movements and yield farming dynamics create complex risk-reward scenarios. I can help analyze protocol fundamentals and risk factors. Are you looking at specific DeFi opportunities?';
    }
    
    if (message.contains('risk') || message.contains('portfolio')) {
      return 'Risk management is crucial in crypto markets. I recommend diversification across different asset classes and timeframes. Portfolio allocation should consider correlation patterns and volatility metrics. Would you like me to help analyze your risk exposure?';
    }

    // Greeting responses
    if (message.contains('hello') || message.contains('hi') || message.contains('hey')) {
      return 'Hello! I\'m here to help you navigate the complex world of digital assets and traditional finance. I can analyze market trends, explain DeFi protocols, discuss macro factors, and help with investment insights. What would you like to explore?';
    }

    // Help responses
    if (message.contains('help') || message.contains('what can you do')) {
      return 'I can help you with:\n\n• Market analysis and price predictions\n• On-chain data interpretation\n• DeFi protocol analysis\n• Risk assessment and portfolio strategies\n• Macro economic factor analysis\n• Stablecoin flow monitoring\n• Technical indicator insights\n\nJust ask me about any financial topic you\'re curious about!';
    }

    // Default responses
    final defaultResponses = [
      'That\'s an interesting question! Based on current market data and trends, I\'d suggest looking at multiple factors including on-chain metrics, sentiment indicators, and macro economic conditions. Could you provide more specific details about what you\'d like to analyze?',
      'Great question! The crypto markets are influenced by many variables. I can help analyze technical indicators, fundamental metrics, and market sentiment to provide insights. What specific aspect interests you most?',
      'I see you\'re exploring market dynamics. Let me help you understand the interconnections between different factors that drive price movements and market trends. What particular scenario are you considering?',
      'That\'s a complex topic that requires analyzing multiple data streams. I can break down the key factors and help you understand the relationships between different market indicators. Would you like to focus on a specific timeframe or asset?',
    ];

    return defaultResponses[DateTime.now().millisecond % defaultResponses.length];
  }
}