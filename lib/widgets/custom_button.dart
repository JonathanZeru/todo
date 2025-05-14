import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? loadingWidget;
  final double height;
  final double? width;
  final TextStyle? textStyle;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.loadingWidget,
    this.height = 50,
    this.width,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: isLoading
          ? loadingWidget ?? const Center(child: CircularProgressIndicator())
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Theme.of(context).primaryColor,
                // disabledBackgroundColor: Colors.grey.shade300,
                // disabledForegroundColor: Colors.grey.shade600,
              ),
              child: Text(
                text,
                style: textStyle ?? const TextStyle(
                  fontSize: 16,
                  color: Colors.white)
              )
            )
    );
  }
}