import 'package:flutter/material.dart';

class BlogDetailsPage extends StatelessWidget {
  final String? image; // Nullable image
  final String title;
  final String description;

  const BlogDetailsPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Blog Details',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blog image or fallback
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: image != null && image!.isNotEmpty
                    ? Image.network(
                  image!, // Display the image
                  width: double.infinity,
                  height: 200.0,
                  fit: BoxFit.cover,
                )
                    : Container(
                  width: double.infinity,
                  height: 200.0,
                  color: Colors.grey[300], // Grey background as fallback
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey[600],
                    size: 60.0,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              // Blog title
              Text(
                title, // Dynamic title
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              // Blog description
              Text(
                description, // Full description
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
