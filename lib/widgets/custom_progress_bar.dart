
import 'package:flutter/material.dart';

class ProgressBarExample extends StatefulWidget {
  const ProgressBarExample({Key? key}) : super(key: key);

  @override
  State<ProgressBarExample> createState() => _ProgressBarExampleState();
}

class _ProgressBarExampleState extends State<ProgressBarExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() => setState(() {}));
  }

  void _startAnimation() {
    _controller.forward();
  }

void _restartAnimation() {
  _controller.reset();
}
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomProgressBar(value: _animation.value),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startAnimation,
              child: const Text('Start Progress'),
            ),
    const SizedBox(width: 10),
    ElevatedButton(
      onPressed: _restartAnimation,
      child: const Text('Restart'),
    ),
          ],
        ),
      );
  }
}

class CustomProgressBar extends StatelessWidget {
  final double value; // value between 0.0 and 1.0
  final double height;

  const CustomProgressBar({
    Key? key,
    required this.value,
    this.height = 10,
  }) : super(key: key);

  Color _getColorBasedOnProgress(double value) {
    if (value < 0.5) {
        return Colors.red;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColorBasedOnProgress(value);
    final percent = (value * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(height / 2),
              ),
              child: CustomPaint(
                painter: _ProgressBarPainter(
                  value: value,
                  color: color,
                ),
              ),
            ),Text(
                '$percent%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
      ],
    );
  }
}

class _ProgressBarPainter extends CustomPainter {
  final double value;
  final Color color;

  _ProgressBarPainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width * value, size.height),
      Radius.circular(size.height / 2),
    );

    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _ProgressBarPainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}