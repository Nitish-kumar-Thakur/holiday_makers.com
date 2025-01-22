import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      color: Colors.white, // Background color for Contact Us page
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: const [
            ContactItem(icon: FontAwesomeIcons.headphones, label: 'Customer Services'),
            ContactItem(icon: FontAwesomeIcons.whatsapp, label: 'WhatsApp'),
            ContactItem(icon: FontAwesomeIcons.earthAmericas, label: 'Website'),
            ContactItem(icon: FontAwesomeIcons.facebook, label: 'Facebook'),
            ContactItem(icon: FontAwesomeIcons.twitter, label: 'Twitter'),
            ContactItem(icon: FontAwesomeIcons.instagram, label: 'Instagram'),
          ],
        ),
      ),
    ),
    );
  }
}

class ContactItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const ContactItem({
    required this.icon,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        color: Colors.white,
        height: 80, // Increased height of the cards
        alignment: Alignment.center,
        child: ListTile(
          leading: Icon(icon, color: Colors.black),
          title: Text(label, textAlign: TextAlign.left),
          onTap: () {
            // Add functionality for each contact option if needed
          },
        ),
      ),
    );
  }
}
