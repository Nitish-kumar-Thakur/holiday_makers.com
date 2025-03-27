import 'package:HolidayMakers/pages/login&signup/Test.dart';
import 'package:flutter/material.dart';
import 'package:HolidayMakers/pages/homePages/introPage.dart';
import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:HolidayMakers/utils/shared_preferences_handler.dart';
import 'package:HolidayMakers/widgets/appText.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _message = "";

  bool _isOldPasswordObscure = true;
  bool _isNewPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;
  bool _isLoading = false;

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    final regex = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    if (!regex.hasMatch(password)) {
      return 'Password must contain:\n'
          '- At least 8 characters\n'
          '- One uppercase letter\n'
          '- One lowercase letter\n'
          '- One number\n'
          '- One special character';
    }
    return null;
  }

  String? _validateConfirmPassword(String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (confirmPassword != _newPasswordController.text) {
      return 'New password and confirm password do not match';
    }
    return null;
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return; // Stop execution if validation fails
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await APIHandler.changePassword(
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      setState(() {
        _message = response["message"];
      });

      // Reset the message after 3 seconds
      Future.delayed(Duration(seconds: 5), () {
        setState(() {
          _message = ""; // Clear the message after 3 seconds
        });
      });

      if (response["status"] == true) {
        _oldPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();

        // Redirect to login page after successful password change
        Future.delayed(Duration(seconds: 2), () {
          SharedPreferencesHandler.signOut(); // Close the dialog
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) =>
                  LoginPage())); // Replace with your login screen route
        });
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
        print("chl raha h");
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      }
    } catch (error) {
      setState(() {
        _message = '$error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildTopCurve() {
    return Padding(
      padding: const EdgeInsets.only(top: 50), // 20% of the screen height
      child: CustomPaint(
        size: Size(double.infinity, 0), // Height of the curved area
        painter: CirclePainter(radius: 200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //       icon: Icon(Icons.arrow_back)),
      // ),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopCurve(),
              const SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: CircleAvatar(
                      backgroundColor: Colors.grey.withOpacity(0.6),  // Transparent grey background
                      child: Text(
                        '<',  // Use "<" symbol
                        style: TextStyle(
                          color: Colors.white,  // White text color
                          fontSize: 24,  // Adjust font size as needed
                          fontWeight: FontWeight.bold,  // Make the "<" bold if needed
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('CHANGE PASSWORD',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)
                  )
                ],
              ),
              const SizedBox(height: 50),
              // Old Password
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 620, // Adjust the height as needed
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('img/fitFormBG.png'), // Background image
                      fit: BoxFit.cover, // Ensures the image covers the container
                    ),
                    borderRadius: BorderRadius.circular(20), // Rounded corners for the container
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5), // Shadow color
                        offset: Offset(0, 4), // Shadow offset (vertical displacement)
                        blurRadius: 20, // Softens the shadow
                        spreadRadius: 1, // Extends the shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15), // Padding around the content
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        // Existing Password Field
                        _buildPasswordField(
                          label: "Existing Password",
                          controller: _oldPasswordController,
                          isObscure: _isOldPasswordObscure,
                          onToggleVisibility: () {
                            setState(() {
                              _isOldPasswordObscure = !_isOldPasswordObscure;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your old password!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 40),

                        // New Password Field
                        _buildPasswordField(
                          label: "New Password",
                          controller: _newPasswordController,
                          isObscure: _isNewPasswordObscure,
                          onToggleVisibility: () {
                            setState(() {
                              _isNewPasswordObscure = !_isNewPasswordObscure;
                            });
                          },
                          validator: _validatePassword,
                        ),
                        const SizedBox(height: 40),

                        // Confirm Password Field
                        _buildPasswordField(
                          label: "Confirm Password",
                          controller: _confirmPasswordController,
                          isObscure: _isConfirmPasswordObscure,
                          onToggleVisibility: () {
                            setState(() {
                              _isConfirmPasswordObscure = !_isConfirmPasswordObscure;
                            });
                          },
                          validator: _validateConfirmPassword,
                        ),
                        const SizedBox(height: 40),

                        // Save Changes Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _changePassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0071BC),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            child: _isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : const Text(
                              "Save Changes",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Cancel Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                              _oldPasswordController.clear();
                              _newPasswordController.clear();
                              _confirmPasswordController.clear();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Message Display (e.g., success or error message)
                        Center(
                          child: AppText(text: _message),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isObscure,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const Text(
              "*",
              style: TextStyle(color: Colors.red, fontSize: 20),
            ),
          ],
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: isObscure,
          decoration: InputDecoration(
            filled: true, // Enable background fill color
            fillColor: Colors.white, // Set background color to white
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white), // Default border color (white)
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue), // Border color when focused (blue)
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white), // Border color when not focused (white)
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
            suffixIcon: IconButton(
              onPressed: onToggleVisibility,
              icon: Icon(
                isObscure ? Icons.visibility_off : Icons.visibility,
              ),
            ),
          ),
          validator: validator,
        )
      ],
    );
  }
}

class CirclePainter extends CustomPainter {
  final double radius;

  CirclePainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..style = PaintingStyle.fill;

    // We can use FontAwesome icon positioning logic here.
    double centerX = size.width / 2;

    // Draw the largest circle (dark blue)
    paint.color = Color(0xFF0D939E); // Dark blue
    canvas.drawCircle(Offset(centerX, radius - 600), radius + 400, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}