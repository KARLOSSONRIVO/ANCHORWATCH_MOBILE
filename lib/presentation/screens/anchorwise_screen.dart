import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/anchorwise/anchorwise.dart';
import '../widgets/widgets.dart';
import '../themes/app_theme.dart';

/// AnchorWise AI chat screen using AnchorWiseBloc
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AnchorWiseBloc, AnchorWiseState>(
      listener: (context, state) {
        if (state.error != null) {
          SnackBarHelper.showError(context, state.error!);
        }
        // Auto-scroll to bottom when new messages arrive
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
          return _buildTypingIndicator();
        }
        
        final message = state.messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildWelcomeArea(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Large Logo
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

            // Main title
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

            // Subtitle
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

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.sender == MessageSender.user;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.getCardBackgroundColor(context),
              backgroundImage: const AssetImage('assets/images/LOGO.png'),
              
            ),
            const SizedBox(width: 8),
          ],
          
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: isUser 
                    ? AppTheme.primaryColor
                    : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isUser ? Colors.black : Colors.white,
                      fontFamily: 'Inter',
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: isUser 
                          ? Colors.black.withOpacity(0.6)
                          : Colors.grey.shade400,
                      fontSize: 10,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey.shade700,
              child: const Icon(
                Icons.person,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.getCardBackgroundColor(context),
            backgroundImage: const AssetImage('assets/images/LOGO.png'),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(16).copyWith(
                bottomLeft: const Radius.circular(4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(3, (index) {
                      return TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 600),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, -4 * (0.5 - (0.5 - value).abs())),
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
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
            // Cancel button when sending
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
            // Send button when not sending
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


  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      // Format as HH:mm for recent messages
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}