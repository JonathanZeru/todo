import 'package:flutter/material.dart';
import 'package:flutter_todo_app/screens/home/home_screen.dart';
import 'package:flutter_todo_app/screens/login/login_screen.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/task_provider.dart';
import 'providers/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Flutter Todo App',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const AuthenticationWrapper(),
          );
        },
      ),
    );
  }
}

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  final Logger _logger = Logger();
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      
      setState(() {
        _isLoggedIn = isLoggedIn;
        _isLoading = false;
      });
      
      _logger.i('User login status: ${_isLoggedIn ? 'Logged in' : 'Not logged in'}');
    } catch (e) {
      _logger.e('Error checking login status: $e');
      setState(() {
        _isLoading = false;
        _isLoggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (_isLoggedIn) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
