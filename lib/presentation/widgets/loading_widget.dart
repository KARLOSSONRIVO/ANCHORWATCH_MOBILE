import 'dart:math' as math;
import 'package:flutter/material.dart';
class LoadingWidget extends StatefulWidget {
  const LoadingWidget({
    super.key,
    this.size = 24.0,
    this.color = const Color(0xFF00D4AA),
    this.strokeWidth = 3.0,
    this.text,
    this.textStyle,
    this.animationDuration = const Duration(milliseconds: 1200),
    this.showGradient = true,
    this.pulseEffect = true,
  });

  final double size;
  final Color color;
  final double strokeWidth;
  final String? text;
  final TextStyle? textStyle;
  final Duration animationDuration;
  final bool showGradient;
  final bool pulseEffect;

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.pulseEffect) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([_rotationController, _pulseAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: widget.pulseEffect ? _pulseAnimation.value : 1.0,
              child: SizedBox(
                width: widget.size,
                height: widget.size,
                child: Transform.rotate(
                  angle: _rotationController.value * 2.0 * math.pi,
                  child: CustomPaint(
                    painter: _ModernLoadingPainter(
                      color: widget.color,
                      strokeWidth: widget.strokeWidth,
                      progress: _rotationController.value,
                      showGradient: widget.showGradient,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        if (widget.text != null) ...[
          const SizedBox(height: 12),
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Opacity(
                opacity: widget.pulseEffect 
                    ? 0.7 + (0.3 * _pulseAnimation.value / 1.2)
                    : 1.0,
                child: Text(
                  widget.text!,
                  style: widget.textStyle ??
                      TextStyle(
                        color: widget.color,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                        letterSpacing: 0.5,
                      ),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}
class _ModernLoadingPainter extends CustomPainter {
  const _ModernLoadingPainter({
    required this.color,
    required this.strokeWidth,
    required this.progress,
    required this.showGradient,
  });

  final Color color;
  final double strokeWidth;
  final double progress;
  final bool showGradient;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final trackPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..strokeWidth = strokeWidth * 0.8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, trackPaint);
    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    if (showGradient) {
      final gradient = SweepGradient(
        startAngle: 0,
        endAngle: math.pi * 2,
        colors: [
          color.withValues(alpha: 0.1),
          color.withValues(alpha: 0.3),
          color,
          color,
          color.withValues(alpha: 0.3),
          color.withValues(alpha: 0.1),
        ],
        stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
      );

      paint.shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );
    } else {
      paint.color = color;
    }
    final arcLength = math.pi * 1.5;
    final startAngle = -math.pi / 2;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      arcLength,
      false,
      paint,
    );
    final trailingPaint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..strokeWidth = strokeWidth * 0.6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.8),
      startAngle + arcLength - math.pi / 3,
      math.pi / 3,
      false,
      trailingPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ModernLoadingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.color != color ||
           oldDelegate.strokeWidth != strokeWidth;
  }
}
class DotsLoadingWidget extends StatefulWidget {
  const DotsLoadingWidget({
    super.key,
    this.size = 8.0,
    this.color = const Color(0xFF00D4AA),
    this.spacing = 4.0,
    this.animationDuration = const Duration(milliseconds: 1400),
  });

  final double size;
  final Color color;
  final double spacing;
  final Duration animationDuration;

  @override
  State<DotsLoadingWidget> createState() => _DotsLoadingWidgetState();
}

class _DotsLoadingWidgetState extends State<DotsLoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animations = List.generate(3, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.2,
            (index + 1) * 0.2 + 0.4,
            curve: Curves.elasticOut,
          ),
        ),
      );
    });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
              child: Transform.scale(
                scale: 0.5 + (_animations[index].value * 0.5),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: 
                      0.3 + (_animations[index].value * 0.7),
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.3),
                        blurRadius: widget.size * 0.5,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
class SimpleLoadingWidget extends StatelessWidget {
  const SimpleLoadingWidget({
    super.key,
    this.size = 20.0,
    this.color = const Color(0xFF00D4AA),
    this.strokeWidth = 2.5,
    this.backgroundColor,
  });

  final double size;
  final Color color;
  final double strokeWidth;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        color: color,
        backgroundColor: backgroundColor ?? color.withValues(alpha: 0.1),
        strokeCap: StrokeCap.round,
      ),
    );
  }
}
