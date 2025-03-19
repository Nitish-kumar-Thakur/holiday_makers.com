import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Background color for Contact Us page
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              ContactItem(icon: FontAwesomeIcons.headphones, label: 'Customer Services', url: 'tel:+91 7082661109'),       // tel:+971 45 43 8900
              ContactItem(icon: FontAwesomeIcons.whatsapp, label: 'WhatsApp', url: 'https://wa.me/+91 7082661109'),       // +971 45 43 8900
              ContactItem(icon: FontAwesomeIcons.earthAmericas, label: 'Website', url: 'https://holidaymakers.com/'),
              ContactItem(icon: FontAwesomeIcons.facebook, label: 'Facebook', url: ''),
              ContactItem(icon: FontAwesomeIcons.twitter, label: 'Twitter', url: ''),
              ContactItem(icon: FontAwesomeIcons.instagram, label: 'Instagram', url: 'https://www.instagram.com/yash_drall_'),      // holidaymakers.com_
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
  final String url;

  const ContactItem({
    required this.icon,
    required this.label,
    required this.url,
    super.key,
  });

  void _launchURL(BuildContext context) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open $label')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () => _launchURL(context),
        borderRadius: BorderRadius.circular(8.0), // Ensures ripple effect follows shape
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          height: 80, // Increased height of the cards
          alignment: Alignment.center,
          child: Row(
            children: [
              Icon(icon, color: Colors.lightBlue),
              const SizedBox(width: 16), // Space between icon and text
              Text(label, style: const TextStyle(fontSize: 16, color: Colors.blue)),
            ],
          ),
        ),
      ),
    );
  }
}







// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class ContactUsPage extends StatelessWidget {
//   const ContactUsPage({super.key});
//
//   void _launchURL(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
//       throw 'Could not launch $url';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.blueAccent, Colors.greenAccent], // Gradient background
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               const Text(
//                 "Get in Touch",
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Expanded(
//                 child: ListView(
//                   children: [
//                     ContactItem(
//                       icon: FontAwesomeIcons.headphones,
//                       label: 'Customer Services',
//                       url: 'tel:+91 7082661109',
//                       color: Colors.blueAccent,
//                     ),
//                     ContactItem(
//                       icon: FontAwesomeIcons.whatsapp,
//                       label: 'WhatsApp',
//                       url: 'https://wa.me/+91 7082661109',
//                       color: Colors.green,
//                     ),
//                     ContactItem(
//                       icon: FontAwesomeIcons.earthAmericas,
//                       label: 'Website',
//                       url: 'https://holidaymakers.com/',
//                       color: Colors.purple,
//                     ),
//                     ContactItem(
//                       icon: FontAwesomeIcons.facebook,
//                       label: 'Facebook',
//                       url: '',
//                       color: Colors.blue,
//                     ),
//                     ContactItem(
//                       icon: FontAwesomeIcons.twitter,
//                       label: 'Twitter',
//                       url: '',
//                       color: Colors.lightBlueAccent,
//                     ),
//                     ContactItem(
//                       icon: FontAwesomeIcons.instagram,
//                       label: 'Instagram',
//                       url: 'https://www.instagram.com/yash_drall_',
//                       color: Colors.pinkAccent,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class ContactItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String url;
//   final Color color;
//
//   const ContactItem({
//     required this.icon,
//     required this.label,
//     required this.url,
//     required this.color,
//     super.key,
//   });
//
//   void _launchURL(BuildContext context) async {
//     final Uri uri = Uri.parse(url);
//     if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Could not open $label')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 6,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       child: InkWell(
//         onTap: () => _launchURL(context),
//         borderRadius: BorderRadius.circular(12.0),
//         child: Container(
//           padding: const EdgeInsets.all(12.0),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12.0),
//             gradient: LinearGradient(
//               colors: [color.withOpacity(0.8), color.withOpacity(0.6)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 backgroundColor: Colors.white.withOpacity(0.3),
//                 child: Icon(icon, color: Colors.white),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Text(
//                   label,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
