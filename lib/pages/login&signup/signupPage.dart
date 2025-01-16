import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/mainPage.dart';
import 'package:holdidaymakers/pages/introPage.dart';
import 'package:holdidaymakers/pages/login&signup/loginPage.dart';
import 'package:holdidaymakers/utils/api_handler.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/appText.dart';
import 'package:holdidaymakers/widgets/loginButton.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  final APIHandler _apiHandler = APIHandler();
  bool _obscureText = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  String _errorMessage = '';
  String _countryCode = "+91";
  bool _isLoading = false; // Default country code

  void _validateAndSignUp() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final phone = _phoneController.text.trim();

    setState(() {
      _errorMessage = '';
      _isLoading = true;
    });

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        phone.isEmpty) {
      setState(() => _errorMessage = 'All fields are required');
      setState(() => _isLoading = false);
      return;
    }

    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      setState(() => _errorMessage = 'Invalid email format');
      setState(() => _isLoading = false);
      return;
    }

    if (password.length < 6) {
      setState(() => _errorMessage = 'Password must be at least 6 characters');
      setState(() => _isLoading = false);
      return;
    }

    try {
      final result = await _apiHandler.registerUser(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        phone: phone,
        countryCode: _countryCode, // Pass selected country code
      );

      if (result['status'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Mainpage()),
        );
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Registration failed';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double paddingValue = screenSize.width * 0.06;
    final double textScaleFactor = screenSize.width < 600 ? 1.0 : 1.2;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const IntroPage())),
        ),
        elevation: 0, // Remove shadow to reduce space
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(paddingValue),
          height: screenSize.height,
          width: screenSize.width,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppLargeText(text: 'Sign up'),
                SizedBox(height: screenSize.height * 0.02), // Reduced space
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
                SizedBox(height: screenSize.height * 0.02),
                const Center(
                    child:
                        AppText(text: 'Or Sign up using', color: Colors.black)),
                SizedBox(height: screenSize.height * 0.02),
                if (_errorMessage.isNotEmpty)
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                SizedBox(height: screenSize.height * 0.02),
                _buildInputField(
                    controller: _firstNameController, hintText: 'First Name'),
                SizedBox(height: screenSize.height * 0.02),
                _buildInputField(
                    controller: _lastNameController, hintText: 'Last Name'),
                SizedBox(height: screenSize.height * 0.02),
                // Phone Input with Country Code
                _buildInputField(
                    controller: _phoneController, hintText: 'Phone'),
                SizedBox(height: screenSize.height * 0.02),
                _buildInputField(
                    controller: _emailController, hintText: 'Mail'),
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
                GestureDetector(
                  onTap: _isLoading ? null : _validateAndSignUp,
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : responciveButton(text: 'signup'),
                ),
                SizedBox(height: screenSize.height * 0.07),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppText(
                        text: 'Already have an account? ', color: Colors.black),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage())),
                      child: const AppText(
                        text: 'Log in',
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
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
          ),
        ),
      ),
    );
  }
}
