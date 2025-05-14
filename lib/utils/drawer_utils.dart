import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/login/login_screen.dart';

void navigateTo(BuildContext context, Widget screen) {
  Navigator.pop(context); // Close drawer
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    ),
  );
}

/// Show a confirmation dialog before logging out
Future<void> showLogoutConfirmationDialog(BuildContext context) async {
  final shouldLogout = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirm Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => logout(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Logout'),
        ),
      ],
    ),
  );

}

/// Perform the actual logout operation
Future<void> logout(BuildContext context) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false, 
      );
    }
  } catch (e) {
    debugPrint('Error during logout: $e');
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error logging out: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

Future<bool?> showTaskDeleteConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirm Task Delete'),
      content: const Text('Are you sure you want to delete this task?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
