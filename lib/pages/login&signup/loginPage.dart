import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/homePage.dart';
import 'package:holdidaymakers/pages/introPage.dart';
import 'package:holdidaymakers/pages/login&signup/signupPage.dart';
import 'package:holdidaymakers/widgets/appEditField.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/appText.dart';
import 'package:holdidaymakers/widgets/loginButton.dart';
import 'package:holdidaymakers/widgets/passwordField.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  void navigateToIntroPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const IntroPage()),
    );
  }

  void navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void navigateToSignUpPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Signuppage()),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // Perform login logic
      navigateToHomePage();
    }
  }
  

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: screenSize.height,
          width: screenSize.width,
          margin: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: navigateToIntroPage,
                ),
                const SizedBox(height: 23),
                AppLargeText(text: 'Log in'),
                const SizedBox(height: 23),
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
                const SizedBox(height: 23),
                const Center(child: AppText(text: 'Or log in using', color: Colors.black)),
                const SizedBox(height: 23),
                AppEditField(
                  labeltext: 'Email',
                  controller: emailController,
                  focusNode: emailFocusNode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {

                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 23),
                PasswordField(
                  controller: passwordController,
                  focusNode: passwordFocusNode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 23),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    AppText(text: 'Forgot your password?', color: Colors.black),
                  ],
                ),
                const SizedBox(height: 23),
                GestureDetector(
                  onTap: _submitForm,
                  child: responciveButton(text: 'Login'),
                ),
                const SizedBox(height: 220,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppText(text: 'Don’t have an account yet? ', color: Colors.black),
                    GestureDetector(
                      onTap: navigateToSignUpPage,
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
}
