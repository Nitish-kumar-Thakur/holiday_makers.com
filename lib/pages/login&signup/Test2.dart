import 'package:HolidayMakers/pages/login&signup/Test.dart';
import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:HolidayMakers/widgets/terms_and_conditions_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class Signuppage extends StatefulWidget {
  // final bool backbutton;
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
  bool _isAgreed = false;
  String _errorMessage = '';
  String _countryCode = "";
  bool _isLoading = false; // Default country code

  void _validateAndSignUp() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final phone = _phoneController.text.trim();
    _countryCode = _countryCode.trim();
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    print(_countryCode);
    print(phone);
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@");

    setState(() {
      _errorMessage = '';
      _isLoading = true;
    });

    // Validate form fields
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        phone.isEmpty) {
      Fluttertoast.showToast(msg: 'All fields are required');
      setState(() => _isLoading = false);
      return;
    }

    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      Fluttertoast.showToast(msg: 'Invalid email format');
      setState(() => _isLoading = false);
      return;
    }

    if (password.length < 6) {
      Fluttertoast.showToast(msg: 'Password must be at least 6 characters');
      setState(() => _isLoading = false);
      return;
    }

    // Check if the terms and conditions are agreed
    if (!_isAgreed) {
      Fluttertoast.showToast(msg: 'You must agree to the terms and conditions');
      setState(() {
        _isLoading = false;
      });
      return; // Prevent further execution if checkbox is not checked
    }

    // If all fields are valid and checkbox is checked, proceed with sign-up
    try {
      final result = await _apiHandler.registerUser(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        phone: phone,
        countryCode: _countryCode,
      );

      if (result['status'] == true) {
        // Fluttertoast.showToast(msg: result['message'] ?? "Registered successfully.");
        _isLoading = false;
        showSuccessDialog(context, result['message'] ?? "Registered successfully.");
        
      } else {
        Fluttertoast.showToast(msg: result['message'] ?? 'Registration failed.');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showSuccessDialog(BuildContext context, String htmlMessage) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedScale(
                  scale: 1.0,
                  duration: Duration(milliseconds: 500),
                  child: Icon(Icons.check_circle, color: Colors.green, size: 80),
                ),
                SizedBox(height: 10),
                Text(
                  "Success",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Html(
                  data: htmlMessage,
                  // style: {
                  //   "h1": Style(
                  //     // fontSize: FontSize.medium, // Smaller for dialog readability
                  //     fontWeight: FontWeight.w900,
                  //     textAlign: TextAlign.center,
                  //     margin: Margins.only(bottom: 10),
                  //   ),
                  //   "h2": Style(
                  //     fontSize: FontSize.medium,
                  //     fontWeight: FontWeight.w700,
                  //     textAlign: TextAlign.center,
                  //     margin: Margins.only(bottom: 10),
                  //   ),
                  //   "span": Style(
                  //     color: Color(0xFFFBC400),
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  //   "body": Style(
                  //      padding: HtmlPaddings.zero,
                  //     margin: Margins.zero,
                  //   )
                  // },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text("Continue"),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}


void newFunction() {
  final plainMessage = stripHtmlTags("<h1>Registered successfully. Please check your email for verification </h1> <br/> <h2>Please enter blow voucher code to avail 100 AED discount <br/> <span style='color:#fbc400;'>AHPFOUC</span></h2>");
  showSuccessDialog(context, "<h1>Registered successfully. Please check your email for verification </h1> <br/> <h2>Please enter blow voucher code to avail 100 AED discount <br/> <span style='color:#fbc400;'>AHPFOUC</span></h2>");
}
String stripHtmlTags(String htmlText) {
  final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
  return htmlText.replaceAll(regex, '').trim();
}


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('img/departureDealsBG.png'), fit: BoxFit.fill)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          body: Column(
            children: [
              const SizedBox(height: 50),
               Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: CircleAvatar(
                            backgroundColor: Colors.grey.withOpacity(
                                0.6), // Transparent grey background
                            child: Text(
                              '<', // Use "<" symbol
                              style: TextStyle(
                                color: Colors.white, // White text color
                                fontSize: 24, // Adjust font size as needed
                                fontWeight: FontWeight
                                    .bold, // Make the "<" bold if needed
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
                  child: Container(
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
                            SizedBox(height: 20),
                            _buildInputField(
                                controller: _firstNameController,
                                hintText: 'First Name'),
                            SizedBox(height: 10),
                            _buildInputField(
                                controller: _lastNameController,
                                hintText: 'Last Name'),
                            SizedBox(height: 10),
                            // Phone Input with Country Code
                            IntlPhoneField(
                              controller: _phoneController,
                              initialCountryCode: 'AE',
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                ),
                                labelText: 'Phone Number',
                                labelStyle: TextStyle(color: Colors.blue),
                              ),
                              onChanged: (phone) {
                                setState(() {
                                  _countryCode = phone.countryCode;
                                });
                              },
                              validator: (phone) {
                                if (phone == null || phone.number.isEmpty) {
                                  return 'Phone number is required';
                                }
                                if (!RegExp(r'^\d+\$').hasMatch(phone.number)) {
                                  return 'Enter only numbers';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 10),
                            _buildInputField(
                                controller: _emailController, hintText: 'Mail'),
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
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: _isAgreed,
                                  onChanged: (value) {
                                    setState(() {
                                      _isAgreed = value!;
                                    });
                                  },
                                ),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      text: 'I agree to the ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'Terms and Conditions',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => TermsAndConditionsPage(),
                                                ),
                                              );
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Align(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: _isAgreed &&
                                        !_isLoading &&
                                        _formKey.currentState?.validate() ==
                                            true
                                    ? _validateAndSignUp
                                    : null, // Disable if form is invalid or checkbox is not checked
                                child: AnimatedContainer(
                                  width: 300,
                                  duration: Duration(
                                      milliseconds:
                                          300), // Duration of the fade effect
                                  curve: Curves.easeInOut,
                                  decoration: BoxDecoration(
                                    color: _isAgreed &&
                                            !_isLoading &&
                                            _formKey.currentState?.validate() ==
                                                true
                                        ? Color(
                                            0xFF3498DB) // Active button color
                                        : Colors.grey, // Disabled button color
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 20),
                                  child: Center(
                                    child: _isLoading
                                        ? CircularProgressIndicator()
                                        : Text(
                                            'Sign Up',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 20),
                          ],
                        ),
                      )),
                )),
              )
            ],
          )),
    );
  }

  Widget _buildInputField(
      {required TextEditingController controller,
      required String hintText,
      bool obscureText = false,
      Widget? suffixIcon}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
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
}
