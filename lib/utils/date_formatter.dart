import 'package:intl/intl.dart';
class DateFormatter {
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
  static String formatStandardDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  static String formatMonthYear(DateTime date) {
    return DateFormat('MMM yyyy').format(date);
  }

  static String formatMonth(DateTime date) {
    return DateFormat('MMMM').format(date);
  }

  static DateTime? tryParsePeriodLabel(String rawLabel) {
    final cleaned = rawLabel.trim();
    if (cleaned.isEmpty) {
      return null;
    }

    final direct = DateTime.tryParse(cleaned);
    if (direct != null) {
      return direct;
    }

    final yearMonthMatch = RegExp(r'^(\d{4})[-/](\d{1,2})$').firstMatch(cleaned);
    if (yearMonthMatch != null) {
      final year = int.tryParse(yearMonthMatch.group(1)!);
      final month = int.tryParse(yearMonthMatch.group(2)!);
      if (year != null && month != null) {
        return DateTime(year, month);
      }
    }

    final yearOnlyMatch = RegExp(r'^(\d{4})$').firstMatch(cleaned);
    if (yearOnlyMatch != null) {
      final year = int.tryParse(yearOnlyMatch.group(1)!);
      if (year != null) {
        return DateTime(year);
      }
    }

    return null;
  }
}
