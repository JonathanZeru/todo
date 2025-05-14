import 'package:flutter/material.dart';

class LoginFooter extends StatelessWidget {
  final VoidCallback onSkipLogin;
  final String skipText;

  const LoginFooter({
    Key? key,
    required this.onSkipLogin,
    this.skipText = 'Skip Login (Demo)',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onSkipLogin,
      child: Text(skipText),
    );
  }
}