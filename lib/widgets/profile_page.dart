import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false; // Track if fields are editable

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Container
          Container(
            width: screenWidth,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "My Profile",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isEditing = !_isEditing; // Toggle editing state
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        _isEditing ? 'Save' : 'Edit Profile',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        _isEditing ? Icons.check : Icons.edit,
                        color: Colors.red,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  // Profile Picture
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage(
                            'https://via.placeholder.com/150',
                          ),
                        ),
                        if (_isEditing)
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Name TextField
                  ProfileField(
                    label: "Name",
                    hintText: "Melissa Peters",
                    isPassword: false,
                    isEditable: _isEditing,
                  ),

                  // Email TextField
                  ProfileField(
                    label: "Email",
                    hintText: "melpeters@gmail.com",
                    isPassword: false,
                    isEditable: _isEditing,
                  ),

                  // Mobile Number TextField
                  ProfileField(
                    label: "Mobile Number",
                    hintText: "+91 3456789878",
                    isPassword: false,
                    isEditable: _isEditing,
                  ),

                  // Address Dropdown
                  ProfileDropdownField(
                    label: "Address",
                    hintText: "test",
                    isEditable: _isEditing,
                  ),

                  // Password TextField
                  ProfileField(
                    label: "Password",
                    hintText: "**********",
                    isPassword: true,
                    isEditable: _isEditing,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),)
    );
  }
}

// TextField Widget for Standard and Password Fields
class ProfileField extends StatefulWidget {
  final String label;
  final String hintText;
  final bool isPassword;
  final bool isEditable;

  const ProfileField({
    required this.label,
    required this.hintText,
    required this.isPassword,
    required this.isEditable,
  });

  @override
  _ProfileFieldState createState() => _ProfileFieldState();
}

class _ProfileFieldState extends State<ProfileField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(
          widget.label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        TextField(
          enabled: widget.isEditable, // Enable or disable editing
          obscureText: widget.isPassword && !_isPasswordVisible,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.blue,
              ),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
              icon: Icon(
                _isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            )
                : null,
          ),
        ),
      ],
    );
  }
}

// Dropdown Widget for Address Field
class ProfileDropdownField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool isEditable;

  const ProfileDropdownField({
    required this.label,
    required this.hintText,
    required this.isEditable,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            underline: SizedBox(),
            value: hintText,
            onChanged: isEditable
                ? (String? newValue) {
              // Handle dropdown change
            }
                : null,
            items: <String>['test', 'option1', 'option2']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
