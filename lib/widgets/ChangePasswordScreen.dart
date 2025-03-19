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
                  IntroPage())); // Replace with your login screen route
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Navigation Button
              // Header
              Container(
                margin: const EdgeInsets.only(left: 0),
                child: Text(
                  "Change Password",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              // Old Password
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
              // New Password
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
              // Confirm Password
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
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: AppText(text: _message),
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
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              onPressed: onToggleVisibility,
              icon: Icon(
                isObscure ? Icons.visibility_off : Icons.visibility,
              ),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
