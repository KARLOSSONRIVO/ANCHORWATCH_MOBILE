import 'package:intl/intl.dart';

/// Utility class for formatting dates in the app
class DateFormatter {
  /// Formats a date to a human-readable relative time string
  /// 
  /// Returns:
  /// - "Just now" for very recent dates
  /// - "Xm ago" for minutes ago
  /// - "Xh ago" for hours ago  
  /// - "Xd ago" for days ago
  /// - "MMM d, yyyy" for dates older than 7 days
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return DateFormat('MMM d, yyyy').format(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Formats a date to a compact display format
  /// Used for dashboard cards and other compact views
  static String formatCompactDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return DateFormat('MMM d').format(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return 'Now';
    }
  }

  /// Formats a date to a standard format (MMM d, yyyy)
  static String formatStandardDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }
}