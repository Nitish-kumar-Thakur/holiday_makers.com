import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {Navigator.pop(context);},
        ),
        title: Text(
          "Terms & Conditions",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle("1. Terms"),
            SizedBox(height: 5.0),
            sectionContent(
              "Tellus at sit ante rutrum suspendisse pretium, vitae vel dignissim. "
                  "Nunc, scelerisque adipiscing condimentum massa dignissim tortor leo lacus. "
                  "Sapien felis ultrices fringilla nisi sit nibh. Etiam volutpat nisl ornare lorem mus at a, et pulvinar.",
            ),
            SizedBox(height: 20.0),
            sectionTitle("2. Use License"),
            SizedBox(height: 5.0),
            sectionContent(
              "Fermentum erat nisl duis varius risus. Augue ac facilisi porta metus enim. "
                  "Ullamcorper lacus praesent rhoncus, sapien rutrum nulla mattis vitae ultrices.",
            ),
            bulletList([
              "Fermentum erat nisl duis varius risus.",
              "Augue ac facilisi porta metus enim.",
              "Ullamcorper lacus praesent rhoncus, sapien rutrum nulla mattis vitae ultrices.",
              "Nunc, scelerisque adipiscing condimentum massa dignissim tortor leo lacus.",
            ]),
            sectionContent(
              "Aliquam eget purus ut malesuada tempor euismod. Eget commodo ultricies et elit hendrerit risus. "
                  "Elementum tellus nisi luctus bibendum malesuada orci dui. Nunc pharetra.",
            ),
            SizedBox(height: 20.0),
            sectionTitle("3. Terms"),
            SizedBox(height: 5.0),
            sectionContent(
              "Tellus at sit ante rutrum suspendisse pretium, vitae vel dignissim. "
                  "Nunc, scelerisque adipiscing condimentum massa dignissim tortor leo lacus. "
                  "Sapien felis ultrices fringilla nisi sit nibh. Etiam volutpat nisl ornare lorem mus at a, et pulvinar.",
            ),
            SizedBox(height: 16.0),
            sectionTitle("4. Use License"),
            SizedBox(height: 5.0),
            sectionContent(
              "Fermentum erat nisl duis varius risus. Augue ac facilisi porta metus enim. "
                  "Ullamcorper lacus praesent rhoncus, sapien rutrum nulla mattis vitae ultrices.",
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.justify,
      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
    );
  }

  Widget sectionContent(String content) {
    return Text(
      content,
      textAlign: TextAlign.justify,
      style: TextStyle(fontSize: 16.0, height: 1.5),
    );
  }

  Widget bulletList(List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map((item) => Padding(
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
        ))
            .toList(),
      ),
    );
  }
}
