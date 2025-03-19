import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:HolidayMakers/pages/homePages/introPage.dart';
import 'package:HolidayMakers/pages/login&signup/signupPage.dart';
import 'package:HolidayMakers/pages/homePages/mainPage.dart';
import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:HolidayMakers/utils/shared_preferences_handler.dart';
import 'package:HolidayMakers/widgets/appLargetext.dart';
import 'package:HolidayMakers/widgets/appText.dart';
import 'package:HolidayMakers/widgets/loginButton.dart';
import 'package:HolidayMakers/widgets/responciveButton.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';
  String _forgetPassword = '';
  bool _isLoading = false;

  void _completeLogin(Map<String, dynamic> responseData) async {
    await SharedPreferencesHandler.saveLoginData(responseData);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Mainpage()),
    );
  }

  Future<void> _validateAndLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _errorMessage = '';
      _isLoading = true;
    });

    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: 'Both fields are required');
      setState(() {
        // _errorMessage = 'Both fields are required';
        _isLoading = false;
      });
      return;
    }
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      // setState(() => _errorMessage = 'Invalid email format');
      Fluttertoast.showToast(msg: 'Invalid email format');
      setState(() => _isLoading = false);
      return;
    }

    if (password.length < 6) {
      // setState(() => _errorMessage = 'Password must be at least 6 characters');
      Fluttertoast.showToast(msg: 'Password must be at least 6 characters');
      setState(() => _isLoading = false);
      return;
    }

    try {
      final responseData = await APIHandler.login(email, password);
      if (responseData['status'] == true) {
        _completeLogin(responseData);
      } else {
        Fluttertoast.showToast(msg: responseData['message'] ?? 'Login failed');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future _validateAndForgetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _errorMessage = 'Please enter your email');
      return;
    }

    try {
      final response = await APIHandler.forgotPassword(email);
      if (response['status'] == true) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Password reset link sent to your email')),
        // );
        setState(() => _forgetPassword =
            response['message'] ?? "Password reset link sent to your email");
        return;
      } else {
        setState(() =>
            _errorMessage = response['message'] ?? 'Failed to send reset link');
      }
    } catch (e) {
      setState(() => _errorMessage = 'An error occurred. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double paddingValue = screenSize.width * 0.06;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const IntroPage()),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      // resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          height: screenSize.height,
          width: screenSize.width,
          margin: EdgeInsets.all(paddingValue),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppLargeText(text: 'Log in'),
                SizedBox(height: screenSize.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LoginButton(
                      text: 'Google',
                      color: Colors.white,
                      textColor: Colors.black,
                      image: 'img/googleIcon.png',
                    ),
                    LoginButton(
                      text: 'Facebook',
                      image: 'img/facebookIcon.png',
                      padding: 15,
                    ),
                  ],
                ),
                SizedBox(height: screenSize.height * 0.03),
                const Center(
                  child: AppText(text: 'Or log in using', color: Colors.black),
                ),
                SizedBox(height: screenSize.height * 0.02),
                if (_errorMessage.isNotEmpty)
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                SizedBox(height: screenSize.height * 0.01),
                _buildInputField(
                  controller: _emailController,
                  hintText: 'Mail',
                ),
                SizedBox(height: screenSize.height * 0.02),
                _buildInputField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: _obscureText,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: _obscureText
                          ? Colors.black54
                          : const Color(0xFF3498DB),
                      size: 24,
                    ),
                    onPressed: () =>
                        setState(() => _obscureText = !_obscureText),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _validateAndForgetPassword(); // Properly call the method
                      },
                      child: const AppText(
                        text: 'Forgot your password?',
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenSize.height * 0.03),
                if (_forgetPassword.isNotEmpty)
                  Center(
                    child: Text(
                      _forgetPassword,
                      style: const TextStyle(color: Colors.blue, fontSize: 14),
                    ),
                  ),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: _isLoading ? null : _validateAndLogin,
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : responciveButton(text: 'Login'),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppText(
                      text: 'Don’t have an account yet? ',
                      color: Colors.black,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Signuppage()),
                      ),
                      child: const AppText(
                        text: 'Sign up',
                        color: Color(0xFF1D9AD7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.white,
            suffixIcon: suffixIcon,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          ),
        ),
      ),
    );
  }
}
