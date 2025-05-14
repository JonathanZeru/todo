import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final double iconSize;
  final Color iconColor;

  const LoginHeader({
    Key? key,
    required this.title,
    this.icon = Icons.check_circle_outline,
    this.iconSize = 80,
    this.iconColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: iconSize,
          color: iconColor,
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}