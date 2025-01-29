import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Text(
                      "Terms & Conditions",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 48.0), // To balance the Row's layout
                ],
              ),
            ),
            // Custom App Bar

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    termsCard(
                      "1. Terms",
                      "Tellus at sit ante rutrum suspendisse pretium, vitae vel dignissim. "
                          "Nunc, scelerisque adipiscing condimentum massa dignissim tortor leo lacus. "
                          "Sapien felis ultrices fringilla nisi sit nibh. Etiam volutpat nisl ornare lorem mus at a, et pulvinar.",
                    ),
                    SizedBox(height: 16.0),
                    termsCard(
                      "2. Use License",
                      "Fermentum erat nisl duis varius risus. Augue ac facilisi porta metus enim. "
                          "Ullamcorper lacus praesent rhoncus, sapien rutrum nulla mattis vitae ultrices. "
                          "Aliquam eget purus ut malesuada tempor euismod.",
                    ),
                    SizedBox(height: 16.0),
                    termsCardWithBullets(
                      "3. Use Guidelines",
                      "Below are the guidelines:",
                      [
                        "Fermentum erat nisl duis varius risus.",
                        "Augue ac facilisi porta metus enim.",
                        "Ullamcorper lacus praesent rhoncus, sapien rutrum nulla mattis vitae ultrices.",
                        "Nunc, scelerisque adipiscing condimentum massa dignissim tortor leo lacus.",
                      ],
                    ),
                    SizedBox(height: 16.0),
                    termsCard(
                      "4. Termination",
                      "Tellus at sit ante rutrum suspendisse pretium, vitae vel dignissim. "
                          "Nunc, scelerisque adipiscing condimentum massa dignissim tortor leo lacus. "
                          "Sapien felis ultrices fringilla nisi sit nibh. Etiam volutpat nisl ornare lorem mus at a, et pulvinar.",
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

  Widget termsCard(String title, String content) {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              content,
              style: TextStyle(fontSize: 16.0, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget termsCardWithBullets(String title, String description, List<String> items) {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              description,
              style: TextStyle(fontSize: 16.0, height: 1.5),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items
                    .map(
                      (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("• ", style: TextStyle(fontSize: 16.0)),
                        Expanded(
                          child: Text(
                            item,
                            style: TextStyle(fontSize: 16.0, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
