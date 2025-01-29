import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class SnowPainter extends CustomPainter {
  final List<Snowflake> snowflakes;
  final double progress;

  SnowPainter({required this.snowflakes, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var snowflake in snowflakes) {
      paint.color = snowflake.color;
      double y = (snowflake.startY + (snowflake.speed * progress)) % size.height;
      canvas.drawCircle(Offset(snowflake.x, y), snowflake.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Snowflake {
  final double x;
  final double startY;
  final double size;
  final double speed;
  final Color color;

  Snowflake({
    required this.x,
    required this.startY,
    required this.size,
    required this.speed,
    required this.color,
  });
}

class SnowEffect extends StatefulWidget {
  final Widget child;

  const SnowEffect({Key? key, required this.child}) : super(key: key);

  @override
  State<SnowEffect> createState() => _SnowEffectState();
}

class _SnowEffectState extends State<SnowEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Snowflake> _snowflakes;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _snowflakes = List.generate(100, (index) {
      final random = Random();
      return Snowflake(
        x: random.nextDouble() * 400, // Adjust width
        startY: random.nextDouble() * 600, // Adjust height
        size: random.nextDouble() * 0, // Random size for snowflakes
        speed: 5, // Random speed for snowflakes
        color: Colors.white.withOpacity(0.8), // Slightly transparent snowflakes
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            CustomPaint(
              painter: SnowPainter(
                snowflakes: _snowflakes,
                progress: _controller.value * 600, // Update snow animation
              ),
              child: Container(),
            ),
          ],
        );
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
