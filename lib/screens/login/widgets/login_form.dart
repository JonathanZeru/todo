import 'package:flutter/material.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_progress_bar.dart';

class LoginForm extends StatefulWidget {
  final Function(String email, String password) onLogin;
  final bool isLoading;
  final double progressValue;

  const LoginForm({
    Key? key,
    required this.onLogin,
    this.isLoading = false,
    this.progressValue = 0.0,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateFormValidity);
    _passwordController.addListener(_updateFormValidity);
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateFormValidity);
    _passwordController.removeListener(_updateFormValidity);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateFormValidity() {
    final emailValid = _emailController.text.isNotEmpty &&
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text);
    final passwordValid = _passwordController.text.isNotEmpty &&
        _passwordController.text.length >= 6;

    setState(() {
      _isFormValid = emailValid && passwordValid;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.onLogin(_emailController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            controller: _emailController,
            labelText: 'Email',
            prefixIcon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _passwordController,
            labelText: 'Password',
            prefixIcon: Icons.lock,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          widget.isLoading
              ? CustomProgressBar(
                  value: widget.progressValue,
                  height: 10,
                )
              : CustomButton(
                  text: 'Login',
                  onPressed: _isFormValid ? _submitForm : null,
                ),
        ],
      ),
    );
  }
}