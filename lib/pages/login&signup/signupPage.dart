import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/introPage.dart';
import 'package:holdidaymakers/pages/login&signup/loginPage.dart';
import 'package:holdidaymakers/widgets/appEditField.dart';
import 'package:holdidaymakers/widgets/appLargetext.dart';
import 'package:holdidaymakers/widgets/appText.dart';
import 'package:holdidaymakers/widgets/loginButton.dart';
import 'package:holdidaymakers/widgets/passwordField.dart';
import 'package:holdidaymakers/widgets/responciveButton.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 30, left: 25, right: 25, bottom: 25),
          height: screenSize.height,
          width: screenSize.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const IntroPage()),
                  );
                },
                child: const BackButton(),
              ),
              const SizedBox(height: 23),
              AppLargeText(text: 'Sign up'),
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(text: 'Or Sign up using', color: Colors.black),
                ],
              ),
              const SizedBox(height: 23),
              AppEditField(
                labeltext: 'First Name',
                controller: firstNameController,
                focusNode: firstNameFocusNode,
              ),
              const SizedBox(height: 23),
              AppEditField(
                labeltext: 'Last Name',
                controller: lastNameController,
                focusNode: lastNameFocusNode,
              ),
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
              responciveButton(text: 'Sign up'),
              const SizedBox(height: 120),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const AppText(text: 'Already have an account? ', color: Colors.black),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
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
    );
  }
}
