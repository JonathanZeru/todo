import 'package:flutter/material.dart';
import 'package:flutter_todo_app/screens/login/widgets/login_footer.dart';
import 'package:flutter_todo_app/screens/login/widgets/login_form.dart';
import 'package:flutter_todo_app/screens/login/widgets/login_header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../screens/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  double _progressValue = 0.0;
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    )..addListener(() {
        setState(() {
          _progressValue = _progressAnimation.value;
        });
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _login(String email, String password) async {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate login process with progress animation
    _animationController.forward().then((_) async {
      // Save login status to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      
      // Save user email for profile
      await prefs.setString('user_email', email);
      
      setState(() {
        _isLoading = false;
      });
      
      // Navigate to home screen after successful login
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  void _skipLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const LoginHeader(
                    title: 'Welcome to Todo App',
                  ),
                  const SizedBox(height: 48),
                  LoginForm(
                    onLogin: _login,
                    isLoading: _isLoading,
                    progressValue: _progressValue,
                  ),
                  const SizedBox(height: 16),
                  LoginFooter(
                    onSkipLogin: _skipLogin,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   // Tracks if fields are valid for button state
//   bool _isFormValid = false;

//   @override
//   void initState() {
//     super.initState();
//     // Listen to text changes for real-time validation
//     _emailController.addListener(_validateForm);
//     _passwordController.addListener(_validateForm);
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _validateForm() {
//     final isValid = _formKey.currentState?.validate() ?? false;
//     if (_isFormValid != isValid) {
//       setState(() {
//         _isFormValid = isValid;
//       });
//     }
//   }

//   void _handleLogin() {
//     if (_formKey.currentState!.validate()) {
//       // Form is valid - proceed with login
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Processing login...')),
//       );
//       // Here you'd call your authentication API
//       debugPrint('Email: ${_emailController.text}');
//       debugPrint('Password: ${_passwordController.text}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text('Login', style: TextStyle(fontSize: 24),),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   hintText: 'Enter your email',
//                   prefixIcon: Icon(Icons.email),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//                       .hasMatch(value)) {
//                     return 'Please enter a valid email';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: const InputDecoration(
//                   labelText: 'Password',
//                   hintText: 'Enter your password',
//                   prefixIcon: Icon(Icons.lock),
//                 ),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your password';
//                   }
//                   if (value.length < 6) {
//                     return 'Password must be at least 6 characters';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _isFormValid ? _handleLogin : null,
//                   child: const Text('Login'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

