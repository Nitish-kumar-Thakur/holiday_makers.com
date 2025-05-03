import 'package:HolidayMakers/pages/homePages/mainPage.dart';
import 'package:HolidayMakers/pages/login&signup/Test2.dart';
import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:HolidayMakers/utils/shared_preferences_handler.dart';
import 'package:HolidayMakers/widgets/responciveButton.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  final Widget redirectTo;
  final bool backbutton;
  final bool canSkip;
  const LoginPage({super.key, this.backbutton = false, this.redirectTo= const Mainpage(), this.canSkip = false});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';
  bool _isForgetLoading = false;
  bool _isLoading = false;

  void _completeLogin(Map<String, dynamic> responseData) async {
    await SharedPreferencesHandler.saveLoginData(responseData);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => widget.redirectTo),
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
        Fluttertoast.showToast(msg: "Login Succesfully");
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
      Fluttertoast.showToast(msg: "Please enter your email");
      return;
    }

    setState(() {
      _isForgetLoading = true;
    });

    try {
      final response = await APIHandler.forgotPassword(email);
      if (response['status'] == true) {
        Fluttertoast.showToast(msg: response['message'] ?? "Password reset link sent to your email");
      } else {
        Fluttertoast.showToast(msg: response['message'] ?? 'Failed to send reset link');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'An error occurred. Please try again.');
    } finally {
      setState(() {
        _isForgetLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('img/departureDealsBG.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            body: Column(
              children: [
                const SizedBox(height: 50),
                widget.backbutton
                    ? Container()
                    : Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: CircleAvatar(
                        backgroundColor: Colors.grey.withOpacity(0.6),
                        child: Text(
                          '<',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            width: screenWidth * 0.93,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.poppins(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: [
                                        TextSpan(
                                            text: "Let's ",
                                            style: TextStyle(color: Colors.red)),
                                        TextSpan(
                                            text: "Travel ",
                                            style:
                                            TextStyle(color: Color(0xFF007A8C))),
                                        TextSpan(
                                            text: "you ",
                                            style: TextStyle(color: Colors.red)),
                                        TextSpan(
                                            text: "in.",
                                            style:
                                            TextStyle(color: Color(0xFF007A8C))),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: [
                                        TextSpan(
                                            text: "Discover the World with Every ",
                                            style: TextStyle(color: Colors.black54)),
                                        TextSpan(
                                            text: "Sign In",
                                            style: TextStyle(color: Colors.blue)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  _buildInputField(
                                    controller: _emailController,
                                    hintText: 'Mail',
                                    icon: Icons.email,
                                  ),
                                  SizedBox(height: 10),
                                  _buildInputField(
                                    controller: _passwordController,
                                    hintText: 'Password',
                                    obscureText: _obscureText,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureText
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: _obscureText
                                            ? Colors.black54
                                            : const Color(0xFF3498DB),
                                        size: 24,
                                      ),
                                      onPressed: () => setState(
                                              () => _obscureText = !_obscureText),
                                    ),
                                    icon: Icons.lock,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        _validateAndForgetPassword();
                                      },
                                      child: Text(
                                        "Forgot your password?",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: _isLoading ? null : _validateAndLogin,
                                      child: _isLoading
                                          ? const Center(
                                          child: CircularProgressIndicator())
                                          : responciveButton(text: 'Login'),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  _buildSocialButtons(),
                                  SizedBox(height: 20),
                                  _buildSignUpOption(),
                                ],
                              ),
                            ),
                          ),
                          if(widget.canSkip)
                            Column(
                              children: [
                                SizedBox(height: 20),
                                Text("OR", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                // "Skip For Now" button right after white container
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => widget.redirectTo),
                                    );
                                    // Handle skip logic
                                    // print("Skipped for now");
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF007BFF), // Blue background
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      "Continue as Guest",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isForgetLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }




  Widget _buildInputField(
      {required TextEditingController controller,
        required String hintText,
        bool obscureText = false,
        Widget? suffixIcon,
        required IconData icon}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        labelText: hintText,
        labelStyle: TextStyle(color: Colors.blue),
      ),
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialButton(FontAwesomeIcons.google, Colors.white, "img/google.png"),
        SizedBox(width: 10),
        _socialButton(
            FontAwesomeIcons.facebook, Colors.white, "img/facebook.png"),
        SizedBox(width: 10),
        _socialButton(FontAwesomeIcons.apple, Colors.white, "img/apple.png"),
      ],
    );
  }

  Widget _socialButton(IconData icon, Color color, String imagePath) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 5)
        ],
      ),
      child: Center(
        child: Image.asset(imagePath, width: 25, height: 25),
      ),
    );
  }

  Widget _buildSignUpOption() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have an account?",
                style: TextStyle(color: Colors.black54)),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Signuppage(
                        backbutton: widget.backbutton,
                      )),
                );
              },
              child: Text("Register Now",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF0071BC))),
            ),
          ],
        ),
        // TextButton(
        //   onPressed: () {},
        //   child: Text("I don’t have a account?",
        //       style: TextStyle(color: Colors.black54)),
        // ),
      ],
    );
  }
}
