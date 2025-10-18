import 'package:flutter/material.dart';
class CustomSnackBar extends SnackBar {
  CustomSnackBar({
    super.key,
    required String message,
    SnackBarType type = SnackBarType.info,
    super.duration = const Duration(seconds: 3),
    VoidCallback? onActionPressed,
    String? actionLabel,
  }) : super(
          content: _SnackBarContent(
            message: message,
            type: type,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          action: onActionPressed != null && actionLabel != null
              ? SnackBarAction(
                  label: actionLabel,
                  onPressed: onActionPressed,
                  textColor: _getActionColor(type),
                )
              : null,
        );

  static Color _getActionColor(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return Colors.white;
      case SnackBarType.error:
        return Colors.white;
      case SnackBarType.warning:
        return Colors.black;
      case SnackBarType.info:
        return Colors.white;
    }
  }
}
class _SnackBarContent extends StatelessWidget {
  const _SnackBarContent({
    required this.message,
    required this.type,
  });

  final String message;
  final SnackBarType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: _getGradient(type),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: _getColor(type).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            _getIcon(type),
            color: _getIconColor(type),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: _getTextColor(type),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return Icons.check_circle_outline;
      case SnackBarType.error:
        return Icons.error_outline;
      case SnackBarType.warning:
        return Icons.warning_amber_outlined;
      case SnackBarType.info:
        return Icons.info_outline;
    }
  }

  Color _getColor(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return const Color(0xFF00D4AA); // Teal brand color
      case SnackBarType.error:
        return const Color(0xFFE53E3E);
      case SnackBarType.warning:
        return const Color(0xFFF59E0B);
      case SnackBarType.info:
        return const Color(0xFF3B82F6);
    }
  }

  Gradient _getGradient(SnackBarType type) {
    final color = _getColor(type);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        color,
        color.withValues(alpha: 0.8),
      ],
    );
  }

  Color _getTextColor(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
      case SnackBarType.error:
      case SnackBarType.info:
        return Colors.white;
      case SnackBarType.warning:
        return Colors.black87;
    }
  }

  Color _getIconColor(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
      case SnackBarType.error:
      case SnackBarType.info:
        return Colors.white;
      case SnackBarType.warning:
        return Colors.black87;
    }
  }
}
enum SnackBarType {
  success,
  error,
  warning,
  info,
}
class SnackBarHelper {
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration? duration,
    VoidCallback? onActionPressed,
    String? actionLabel,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar(
        message: message,
        type: SnackBarType.success,
        duration: duration ?? const Duration(seconds: 3),
        onActionPressed: onActionPressed,
        actionLabel: actionLabel,
      ),
    );
  }
  static void showError(
    BuildContext context,
    String message, {
    Duration? duration,
    VoidCallback? onActionPressed,
    String? actionLabel,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar(
        message: message,
        type: SnackBarType.error,
        duration: duration ?? const Duration(seconds: 4),
        onActionPressed: onActionPressed,
        actionLabel: actionLabel,
      ),
    );
  }
  static void showWarning(
    BuildContext context,
    String message, {
    Duration? duration,
    VoidCallback? onActionPressed,
    String? actionLabel,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar(
        message: message,
        type: SnackBarType.warning,
        duration: duration ?? const Duration(seconds: 3),
        onActionPressed: onActionPressed,
        actionLabel: actionLabel,
      ),
    );
  }
  static void showInfo(
    BuildContext context,
    String message, {
    Duration? duration,
    VoidCallback? onActionPressed,
    String? actionLabel,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar(
        message: message,
        type: SnackBarType.info,
        duration: duration ?? const Duration(seconds: 3),
        onActionPressed: onActionPressed,
        actionLabel: actionLabel,
      ),
    );
  }
  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
    Duration? duration,
    VoidCallback? onActionPressed,
    String? actionLabel,
  }) {
    if (isError) {
      showError(
        context,
        message,
        duration: duration,
        onActionPressed: onActionPressed,
        actionLabel: actionLabel,
      );
    } else {
      showSuccess(
        context,
        message,
        duration: duration,
        onActionPressed: onActionPressed,
        actionLabel: actionLabel,
      );
    }
  }
}
