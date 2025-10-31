import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/anchorwise/anchorwise.dart';
import '../widgets/widgets.dart';
import '../widgets/chat_bubble_widget.dart';
import '../themes/app_theme.dart';
class AnchorWiseScreen extends StatefulWidget {
  const AnchorWiseScreen({super.key});

  @override
  State<AnchorWiseScreen> createState() => _AnchorWiseScreenState();
}

class _AnchorWiseScreenState extends State<AnchorWiseScreen> {
  final TextEditingController _questionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _questionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  ChatBubbleMessage _convertToChatBubbleMessage(ChatMessage message) {
    return ChatBubbleMessage(
      id: message.id,
      content: message.content,
      isUser: message.sender == MessageSender.user,
      timestamp: message.timestamp,
      canReceiveFeedback: message.sender == MessageSender.ai,
      conversationId: message.conversationId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AnchorWiseBloc, AnchorWiseState>(
      listener: (context, state) {
        if (state.error != null) {
          SnackBarHelper.showError(context, state.error!);
        }
        if (state.messages.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      },
      builder: (context, state) {
        return Container(
          color: AppTheme.getBackgroundColor(context),
          child: Column(
            children: [
              Expanded(
                child: _buildChatArea(context, state),
              ),
              _buildInputArea(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChatArea(BuildContext context, AnchorWiseState state) {
    if (state.status == AnchorWiseStatus.loading) {
      return Center(
        child: LoadingWidget(
          size: 48.0,
          color: AppTheme.primaryColor,
          strokeWidth: 3.0,
          text: 'Loading conversation...',
          textStyle: TextStyle(
            color: AppTheme.getTextPrimaryColor(context),
            fontSize: 16,
            fontFamily: 'Inter',
          ),
        ),
      );
    }

    if (state.messages.isEmpty) {
      return _buildWelcomeArea(context);
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16.0),
      itemCount: state.messages.length + (state.isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (state.isTyping && index == state.messages.length) {
          return ChatBubbleWidget(
            message: ChatBubbleMessage(
              id: 'loading',
              content: 'AnchorWise is thinking...',
              isUser: false,
              isLoading: true,
              canReceiveFeedback: false,
              conversationId: state.currentConversationId,
            ),
            showFeedbackButtons: false,
          );
        }
        
        final message = state.messages[index];
        return ChatBubbleWidget(
          message: _convertToChatBubbleMessage(message),
          showTimestamp: true,
          onPositiveFeedback: _handlePositiveFeedback,
          onNegativeFeedback: _handleNegativeFeedback,
        );
      },
    );
  }

  Widget _buildWelcomeArea(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/LOGOnoBG.png',
              width: 200,
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(
                    Icons.anchor,
                    color: Colors.white,
                    size: 100,
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            Text(
              'Your AI companion for\nstablecoin\nand macroeconomic\ninsights.',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.getTextPrimaryColor(context),
                fontFamily: 'Inter',
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              'Ask questions, explore trends, and get\ninstant summaries powered by intelligent\nfinancial analysis.',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.getTextSecondaryColor(context),
                fontFamily: 'Inter',
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }





  Widget _buildInputArea(BuildContext context, AnchorWiseState state) {
    final isSending = state.status == AnchorWiseStatus.sending;
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppTheme.getSurfaceColor(context),
        border: Border(
          top: BorderSide(color: AppTheme.getBorderColor(context)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _questionController,
              style: TextStyle(
                color: AppTheme.getTextPrimaryColor(context),
                fontFamily: 'Inter',
              ),
              decoration: InputDecoration(
                hintText: 'Ask AnchorWise anything...',
                hintStyle: TextStyle(
                  color: AppTheme.getTextSecondaryColor(context),
                  fontFamily: 'Inter',
                ),
                filled: true,
                fillColor: AppTheme.getCardBackgroundColor(context),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: isSending ? null : _handleSendMessage,
            ),
          ),
          const SizedBox(width: 12),
          if (isSending)
            Container(
              decoration: BoxDecoration(
                color: Colors.red.shade600,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _handleCancelRequest,
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                tooltip: 'Cancel request',
              ),
            )
          else
            Container(
              decoration: const BoxDecoration(
                color: AppTheme.primaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () => _handleSendMessage(_questionController.text),
                icon: Icon(
                  Icons.send,
                  color: AppTheme.getTextPrimaryColor(context),
                ),
                tooltip: 'Send message',
              ),
            ),
        ],
      ),
    );
  }

  void _handleSendMessage(String message) {
    if (message.trim().isNotEmpty) {
      context.read<AnchorWiseBloc>().add(AnchorWiseSendMessage(message));
      _questionController.clear();
    }
  }

  void _handleCancelRequest() {
    context.read<AnchorWiseBloc>().add(const AnchorWiseCancelRequest());
  }
  Future<bool> _handlePositiveFeedback(ChatBubbleMessage message) async {
    try {
      if (!message.canReceiveFeedback) {
        throw Exception('This message cannot receive feedback');
      }
      final conversationId = message.conversationId ?? 
          context.read<AnchorWiseBloc>().state.currentConversationId;

      if (conversationId == null || conversationId.isEmpty) {
        throw Exception('Cannot send feedback: No conversation ID available');
      }
      context.read<AnchorWiseBloc>().add(AnchorWiseSendPositiveFeedback(message.id));
      return true;
    } catch (e) {
      return false;
    }
  }
  Future<bool> _handleNegativeFeedback(ChatBubbleMessage message) async {
    try {
      if (!message.canReceiveFeedback) {
        throw Exception('This message cannot receive feedback');
      }
      final conversationId = message.conversationId ?? 
          context.read<AnchorWiseBloc>().state.currentConversationId;

      if (conversationId == null || conversationId.isEmpty) {
        throw Exception('Cannot send feedback: No conversation ID available');
      }
      context.read<AnchorWiseBloc>().add(AnchorWiseSendNegativeFeedback(message.id));
      return true;
    } catch (e) {
      return false;
    }
  }



}

