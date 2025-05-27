import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final bool backbutton;
  const ProfilePage({super.key, this.backbutton = false});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String profileImg = '';
  String firstname = "";
  String lastname = "";
  String email = "";
  String mobileNum = "";
  String address = "";
  String countryCode = "";
  String fullName = "";
  String phone = '';
  bool isProfileEmpty = false;

  bool _isEditing = false;
  File? _profileImage; 
  final ImagePicker _picker = ImagePicker();
  final _addressController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _ProfileDetails();
  }

  Future<void> _ProfileDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      profileImg = prefs.getString("profileImg") ?? "";
      firstname = prefs.getString("first_name") ?? "";
      lastname = prefs.getString("last_name") ?? "";
      email = prefs.getString("email_org") ?? "";
      address = prefs.getString("address") ?? "";
      countryCode = prefs.getString("country_code") ?? "";
      mobileNum = prefs.getString("phone") ?? "";
      fullName = "$firstname $lastname";
      phone = "$countryCode $mobileNum";
      _addressController.text = address;
      isProfileEmpty = email.trim().isEmpty;
    });
  }

  Widget _buildTopCurve() {
    return Padding(
      padding: const EdgeInsets.only(top: 0), // 20% of the screen height
      child: CustomPaint(
        size: Size(double.infinity, 0), // Height of the curved area
        painter: CirclePainter(radius: 200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopCurve(),
            widget.backbutton
                ? Container()
                : Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: CircleAvatar(
                          backgroundColor: Colors.grey
                              .withOpacity(0.6), // Transparent grey background
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
            // Title Container
            Container(
              width: screenWidth,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Profile",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          _isEditing ? 'Save' : 'Edit Profile',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          _isEditing ? Icons.check : Icons.edit,
                          color: Colors.white,
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
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!)
                                : profileImg.trim().isEmpty
                                    ? AssetImage("img/placeholder.png")
                                    : NetworkImage(profileImg) as ImageProvider,
                          ),
                          if (_isEditing)
                            GestureDetector(
                              onTap: _pickImage,
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.red,
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Name TextField
                    ProfileField(
                      label: "Name",
                      hintText: fullName,
                      isPassword: false,
                      isEditable: _isEditing,
                    ),

                    // Email TextField
                    ProfileField(
                      label: "Email",
                      hintText: email,
                      isPassword: false,
                      isEditable: _isEditing,
                    ),

                    // Mobile Number TextField
                    ProfileField(
                      label: "Mobile Number",
                      hintText: phone,
                      isPassword: false,
                      isEditable: _isEditing,
                    ),

                    // Address Text Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Text(
                          "Address",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: _addressController,
                          enabled: _isEditing,
                          decoration: InputDecoration(
                            hintText: "Enter address",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable TextField Widget for Profile Fields
class ProfileField extends StatelessWidget {
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
        TextField(
          enabled: isEditable,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
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
