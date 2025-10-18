import 'package:flutter/material.dart';
import '../../utils/time_formatter.dart';
class ChatBubbleMessage {
  final String id;
  final String content;
  final bool isUser;
  final bool isLoading;
  final DateTime timestamp;
  final bool canReceiveFeedback;
  final String? conversationId;

  ChatBubbleMessage({
    required this.id,
    required this.content,
    required this.isUser,
    this.isLoading = false,
    DateTime? timestamp,
    this.canReceiveFeedback = true,
    this.conversationId,
  }) : timestamp = timestamp ?? DateTime.now();

  ChatBubbleMessage copyWith({
    String? id,
    String? content,
    bool? isUser,
    bool? isLoading,
    DateTime? timestamp,
    bool? canReceiveFeedback,
    String? conversationId,
  }) {
    return ChatBubbleMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      isLoading: isLoading ?? this.isLoading,
      timestamp: timestamp ?? this.timestamp,
      canReceiveFeedback: canReceiveFeedback ?? this.canReceiveFeedback,
      conversationId: conversationId ?? this.conversationId,
    );
  }
}
class ChatBubbleWidget extends StatefulWidget {
  final ChatBubbleMessage message;
  final Function(ChatBubbleMessage)? onPositiveFeedback;
  final Function(ChatBubbleMessage)? onNegativeFeedback;
  final String? aiName;
  final String? aiLogoPath;
  final Color? userBubbleColor;
  final Color? aiBubbleColor;
  final Color? positiveColor;
  final Color? negativeColor;
  final bool showTimestamp;
  final bool showFeedbackButtons;

  const ChatBubbleWidget({
    super.key,
    required this.message,
    this.onPositiveFeedback,
    this.onNegativeFeedback,
    this.aiName = 'AnchorWise',
    this.aiLogoPath = 'assets/images/LOGO.png',
    this.userBubbleColor,
    this.aiBubbleColor,
    this.positiveColor,
    this.negativeColor,
    this.showTimestamp = false,
    this.showFeedbackButtons = true,
  });

  @override
  State<ChatBubbleWidget> createState() => _ChatBubbleWidgetState();
}

class _ChatBubbleWidgetState extends State<ChatBubbleWidget>
    with SingleTickerProviderStateMixin {
  bool _feedbackSent = false;
  String? _selectedFeedback; // 'positive' or 'negative'
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: widget.message.isUser ? _buildUserMessage() : _buildAIMessage(),
    );
  }

  Widget _buildUserMessage() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bubbleColor = widget.userBubbleColor ??
        (isDark ? const Color(0xFF2F3136) : const Color(0xFFEBECEC));

    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 50, top: 8, bottom: 4, right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              widget.message.content,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
          if (widget.showTimestamp) _buildTimestamp(isUser: true),
        ],
      ),
    );
  }

  Widget _buildAIMessage() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bubbleColor = widget.aiBubbleColor ??
        (isDark ? const Color(0xFF25272B) : const Color(0xFFF0F2F5));

    return Container(
      margin: const EdgeInsets.only(right: 50, top: 8, bottom: 4, left: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAILogo(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAINameLabel(),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _buildMessageContent(),
                ),
                if (widget.showTimestamp) _buildTimestamp(isUser: false),
                if (!widget.message.isLoading &&
                    widget.message.canReceiveFeedback &&
                    widget.showFeedbackButtons) ...[
                  const SizedBox(height: 8),
                  _buildFeedbackButtons(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAILogo() {
    return Container(
      width: 50,
      height: 50,
      margin: const EdgeInsets.only(right: 12, top: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Image.asset(
            widget.aiLogoPath!,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(21),
                ),
                child: Icon(
                  Icons.smart_toy,
                  color: Colors.white,
                  size: 24,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAINameLabel() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      widget.aiName!,
      style: TextStyle(
        color: isDark ? const Color(0xFF9CA3AF) : Colors.grey[700],
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildMessageContent() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (widget.message.isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? const Color(0xFF9CA3AF) : Colors.grey[600]!,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            widget.message.content,
            style: TextStyle(
              color: isDark ? const Color(0xFF9CA3AF) : Colors.grey[700],
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      );
    }

    return Text(
      widget.message.content,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black,
        fontSize: 15,
        height: 1.4,
      ),
    );
  }

  Widget _buildTimestamp({required bool isUser}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.only(
        right: isUser ? 16 : 0,
        left: isUser ? 0 : 62,
        top: 4,
        bottom: 4,
      ),
      child: Text(
        _formatTimestamp(widget.message.timestamp),
        style: TextStyle(
          color: isDark ? const Color(0xFF6B7280) : Colors.grey[500],
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildFeedbackButtons() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final positiveColor = widget.positiveColor ?? const Color(0xFF10B981);
    final negativeColor = widget.negativeColor ?? const Color(0xFFEF4444);
    final borderColor = isDark ? const Color(0xFF4A5568) : Colors.grey[300]!;
    final iconColor = isDark ? const Color(0xFF9CA3AF) : Colors.grey[600]!;

    return Row(
      children: [
        _buildFeedbackButton(
          icon: Icons.thumb_up_outlined,
          feedbackType: 'positive',
          selectedColor: positiveColor,
          borderColor: borderColor,
          iconColor: iconColor,
          onTap: () => _sendFeedback('positive'),
        ),
        const SizedBox(width: 8),
        _buildFeedbackButton(
          icon: Icons.thumb_down_outlined,
          feedbackType: 'negative',
          selectedColor: negativeColor,
          borderColor: borderColor,
          iconColor: iconColor,
          onTap: () => _sendFeedback('negative'),
        ),
        if (_feedbackSent) ...[
          const SizedBox(width: 12),
          Text(
            'Thank you for your feedback!',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF9CA3AF)
                  : Colors.grey[600],
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFeedbackButton({
    required IconData icon,
    required String feedbackType,
    required Color selectedColor,
    required Color borderColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    final isSelected = _selectedFeedback == feedbackType;
    
    return GestureDetector(
      onTap: _feedbackSent ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? selectedColor : borderColor,
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isSelected ? selectedColor : iconColor,
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return TimeFormatter.formatTimestamp(timestamp);
  }

  void _sendFeedback(String feedbackType) async {
    if (_feedbackSent || !widget.message.canReceiveFeedback) return;

    setState(() {
      _selectedFeedback = feedbackType;
    });

    bool success = false;
    try {
      if (feedbackType == 'positive' && widget.onPositiveFeedback != null) {
        await widget.onPositiveFeedback!(widget.message);
        success = true;
      } else if (feedbackType == 'negative' && widget.onNegativeFeedback != null) {
        await widget.onNegativeFeedback!(widget.message);
        success = true;
      }
    } catch (e) {
      success = false;    }

    if (mounted) {
      setState(() {
        _feedbackSent = success;
        if (!success) {
          _selectedFeedback = null; // Reset selection if failed
        }
      });
      final snackBar = SnackBar(
        content: Text(
          success
              ? 'Feedback sent successfully!'
              : 'Failed to send feedback. Please try again.',
        ),
        duration: Duration(seconds: success ? 2 : 3),
        backgroundColor: success
            ? (widget.positiveColor ?? const Color(0xFF10B981))
            : (widget.negativeColor ?? const Color(0xFFEF4444)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

