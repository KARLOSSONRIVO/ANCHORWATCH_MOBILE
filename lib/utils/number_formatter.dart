class NumberFormatter {
  static String formatNumber(double number) {
    if (number.isNaN || number.isInfinite) {
      return '0';
    }

    final isNegative = number < 0;
    final absoluteNumber = number.abs();
    String result;

    if (absoluteNumber >= 1e9) {
      final value = absoluteNumber / 1e9;
      result = '${_formatValue(value)}B';
    } else if (absoluteNumber >= 1e6) {
      final value = absoluteNumber / 1e6;
      result = '${_formatValue(value)}M';
    } else if (absoluteNumber >= 1e3) {
      final value = absoluteNumber / 1e3;
      result = '${_formatValue(value)}K';
    } else {
      result = _formatValue(absoluteNumber);
    }

    return isNegative ? '-$result' : result;
  }

  static String formatCurrency(double value) {
    if (value.isNaN || value.isInfinite) {
      return '\$0';
    }

    final isNegative = value < 0;
    final absoluteValue = value.abs();
    String formattedNumber;

    if (absoluteValue >= 1e9) {
      final scaledValue = absoluteValue / 1e9;
      formattedNumber = '${_formatValue(scaledValue)}B';
    } else if (absoluteValue >= 1e6) {
      final scaledValue = absoluteValue / 1e6;
      formattedNumber = '${_formatValue(scaledValue)}M';
    } else if (absoluteValue >= 1e3) {
      final scaledValue = absoluteValue / 1e3;
      formattedNumber = '${_formatValue(scaledValue)}K';
    } else if (absoluteValue >= 1) {
      formattedNumber = _formatValue(absoluteValue);
    } else {
      // For values less than 1, show more decimal places for precision
      formattedNumber = absoluteValue.toStringAsFixed(4);
      // Remove trailing zeros
      formattedNumber = formattedNumber.replaceAll(RegExp(r'\.?0*$'), '');
      if (formattedNumber.isEmpty) formattedNumber = '0';
    }

    final result = isNegative ? '-\$$formattedNumber' : '\$$formattedNumber';
    return result;
  }

  static String formatPercentage(double value) {
    if (value.isNaN || value.isInfinite) {
      return '0%';
    }

    final formattedValue = _formatValue(value);
    return '$formattedValue%';
  }

  static String formatSupplyInMillions(double value) {
    if (value.isNaN || value.isInfinite) {
      return '0M';
    }

    final isNegative = value < 0;
    final absoluteValue = value.abs();
    final millionValue = absoluteValue / 1e6;
    
    final result = '${_formatValue(millionValue)}M';
    return isNegative ? '-$result' : result;
  }

  /// Removes .00 when appropriate and limits decimal places
  static String _formatValue(double value) {
    if (value == value.truncateToDouble()) {
      // Value is a whole number
      return value.truncate().toString();
    }
    
    // For decimal values, show up to 2 decimal places
    String result = value.toStringAsFixed(2);
    
    // Remove trailing zeros
    result = result.replaceAll(RegExp(r'\.?0*$'), '');
    
    // If we removed everything after the decimal, it means it was .00
    if (result.endsWith('.')) {
      result = result.substring(0, result.length - 1);
    }
    
    return result;
  }

  /// Formats a large number for display in data tables
  /// Similar to formatNumber but with slightly different rules for readability
  static String formatTableValue(double value) {
    if (value.isNaN || value.isInfinite) {
      return '-';
    }

    if (value == 0) {
      return '0';
    }

    return formatNumber(value);
  }

  /// Formats inflation or other macro indicators that might be NaN
  static String formatMacroIndicator(double value) {
    if (value.isNaN || value.isInfinite) {
      return '-';
    }

    return formatPercentage(value);
  }
}