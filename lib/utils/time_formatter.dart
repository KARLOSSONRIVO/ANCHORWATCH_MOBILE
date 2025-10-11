/// Utility class for formatting time and timestamps
class TimeFormatter {
  /// Formats a timestamp relative to the current time
  /// 
  /// Returns:
  /// - "Just now" for messages less than 1 minute old
  /// - "Xm ago" for messages less than 1 hour old
  /// - "Xh ago" for messages less than 1 day old
  /// - "DD/MM/YYYY" for older messages
  static String formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  /// Formats a timestamp for chat messages
  /// 
  /// Returns:
  /// - "Xd ago" for messages older than 1 day
  /// - "Xh ago" for messages older than 1 hour
  /// - "Xm ago" for messages older than 1 minute
  /// - "HH:mm" for recent messages (less than 1 minute)
  static String formatChatTime(DateTime timestamp) {
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

  /// Formats time in HH:mm format
  static String formatTimeOnly(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  /// Formats date in DD/MM/YYYY format
  static String formatDateOnly(DateTime timestamp) {
    return '${timestamp.day.toString().padLeft(2, '0')}/${timestamp.month.toString().padLeft(2, '0')}/${timestamp.year}';
  }

  /// Formats full date and time in DD/MM/YYYY HH:mm format
  static String formatFullDateTime(DateTime timestamp) {
    return '${formatDateOnly(timestamp)} ${formatTimeOnly(timestamp)}';
  }
}