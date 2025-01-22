import 'package:flutter/material.dart';
import 'faq_page.dart';
import 'contact_us_page.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {Navigator.pop(context);},
          ),
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Help Center',
              style: TextStyle(color: Colors.black),
            ),
          ),
          elevation: 0,
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: "FAQ"),
              Tab(text: "Contact Us"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            FAQPage(),
            ContactUsPage(),
          ],
        ),
      ),
    );
  }
}
