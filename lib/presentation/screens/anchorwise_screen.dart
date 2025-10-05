import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/anchorwise/anchorwise.dart';
import '../widgets/widgets.dart';

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
          color: const Color(0xFF000000),
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
      return const Center(
        child: LoadingWidget(
          size: 48.0,
          color: Color(0xFF00D4AA),
          strokeWidth: 3.0,
          text: 'Loading conversation...',
          textStyle: TextStyle(
            color: Colors.white,
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
            // AI Avatar
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF00D4AA),
                    const Color(0xFF00D4AA).withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(
                Icons.psychology,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            // Welcome text
            const Text(
              'Welcome to AnchorWise',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            const Text(
              'Your AI-powered financial assistant',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Quick action buttons
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildQuickActionChip(
                  'Market Analysis',
                  Icons.trending_up,
                  () => _sendQuickMessage('Can you provide a market analysis?'),
                ),
                _buildQuickActionChip(
                  'DeFi Insights',
                  Icons.account_balance,
                  () => _sendQuickMessage('Tell me about current DeFi opportunities'),
                ),
                _buildQuickActionChip(
                  'Risk Assessment',
                  Icons.security,
                  () => _sendQuickMessage('Help me assess portfolio risks'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              'Ask me anything about crypto markets, DeFi, traditional finance, or investment strategies.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionChip(String label, IconData icon, VoidCallback onTap) {
    return ActionChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 12,
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF00D4AA).withOpacity(0.2),
      side: const BorderSide(color: Color(0xFF00D4AA)),
      onPressed: onTap,
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
              backgroundColor: const Color(0xFF00D4AA),
              child: const Icon(
                Icons.psychology,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
          ],
          
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: isUser 
                    ? const Color(0xFF00D4AA)
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
            backgroundColor: const Color(0xFF00D4AA),
            child: const Icon(
              Icons.psychology,
              size: 16,
              color: Colors.white,
            ),
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
                                color: Color(0xFF00D4AA),
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
        color: Colors.grey.shade900,
        border: Border(
          top: BorderSide(color: Colors.grey.shade700),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _questionController,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
              ),
              decoration: InputDecoration(
                hintText: 'Ask AnchorWise anything...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontFamily: 'Inter',
                ),
                filled: true,
                fillColor: Colors.black,
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
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF00D4AA),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: isSending ? null : () => _handleSendMessage(_questionController.text),
              icon: isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : const Icon(
                      Icons.send,
                      color: Colors.black,
                    ),
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

  void _sendQuickMessage(String message) {
    _questionController.text = message;
    _handleSendMessage(message);
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
      return 'now';
    }
  }
}