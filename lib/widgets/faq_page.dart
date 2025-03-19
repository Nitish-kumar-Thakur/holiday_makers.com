// import 'package:flutter/material.dart';
//
// class FAQPage extends StatefulWidget {
//   const FAQPage({super.key});
//
//   @override
//   _FAQPageState createState() => _FAQPageState();
// }
//
// class _FAQPageState extends State<FAQPage> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   final Map<String, List<Map<String, String>>> faqData = {
//     "General": [
//       {"question": "What is our mission?", "answer": "Our mission is to provide excellent services."},
//       {"question": "How can I contact support?", "answer": "You can reach out via email or phone."},
//       {"question": "Do you have a mobile app?", "answer": "Yes, we offer both Android and iOS apps."},
//     ],
//     "Payments": [
//       {"question": "What payment methods are accepted?", "answer": "We accept credit cards, PayPal, and more."},
//       {"question": "Can I pay in installments?", "answer": "Yes, installment options are available."},
//     ],
//     "Shipping": [
//       {"question": "How long does shipping take?", "answer": "Shipping takes 3-5 business days on average."},
//       {"question": "Can I track my order?", "answer": "Yes, tracking is available for all orders."},
//     ],
//     "Returns": [
//       {"question": "What is the return policy?", "answer": "You can return items within 30 days."},
//       {"question": "How do I initiate a return?", "answer": "Contact support to start a return."},
//       {"question": "What is our mission?", "answer": "Our mission is to provide excellent services."},
//       {"question": "How can I contact support?", "answer": "You can reach out via email or phone."},
//       {"question": "Do you have a mobile app?", "answer": "Yes, we offer both Android and iOS apps."},
//     ],
//   };
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: faqData.keys.length, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0,),
//               child: Row(
//                 children: faqData.keys.map((key) {
//                   final isSelected = faqData.keys.toList().indexOf(key) == _tabController.index;
//                   return Expanded(
//                     child: GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _tabController.index = faqData.keys.toList().indexOf(key);
//                         });
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 10.0),
//                         decoration: BoxDecoration(
//                           color: isSelected ? Colors.red : Colors.white,
//                           border: Border.all(color: Colors.red),
//                           borderRadius: BorderRadius.circular(20.0),
//                         ),
//                         child: Center(
//                           child: Text(
//                             key,
//                             style: TextStyle(
//                               color: isSelected ? Colors.white : Colors.red,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14.0, // Adjust font size for responsiveness
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//             Expanded(
//               child: TabBarView(
//                 controller: _tabController,
//                 physics: const NeverScrollableScrollPhysics(),
//                 children: faqData.keys.map((key) {
//                   return ListView(
//                     padding: const EdgeInsets.all(12.0),
//                     children: faqData[key]!
//                         .map((faq) => FAQItem(question: faq['question']!, answer: faq['answer']))
//                         .toList(),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class FAQItem extends StatefulWidget {
//   final String question;
//   final String? answer;
//
//   const FAQItem({
//     required this.question,
//     this.answer,
//   });
//
//   @override
//   _FAQItemState createState() => _FAQItemState();
// }
//
// class _FAQItemState extends State<FAQItem> with SingleTickerProviderStateMixin {
//   bool isExpanded = false;
//   late final AnimationController _controller;
//   late final Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 150),
//       vsync: this,
//     );
//     _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ListTile(
//           title: Text(
//             widget.question,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
//           onTap: () {
//             setState(() {
//               isExpanded = !isExpanded;
//               if (isExpanded) {
//                 _controller.forward();
//               } else {
//                 _controller.reverse();
//               }
//             });
//           },
//         ),
//         SizeTransition(
//           sizeFactor: _animation,
//           child: widget.answer != null
//               ? Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Text(
//               widget.answer!,
//               style: TextStyle(
//                 color: Colors.grey[700],
//               ),
//               textAlign: TextAlign.justify,
//             ),
//           )
//               : const SizedBox.shrink(),
//         ),
//         const Divider(),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  int? _expandedIndex;

  final List<Map<String, String>> faqData = const [
    {"question": "What services does Holiday Makers offer?", "answer": "Holidaymakers.com provides holiday packages, tours, hotel bookings etc."},
    {"question": "How can I book a holiday package?", "answer": "You can book a holiday package directly on the Holiday Makers website by selecting your destination, dates, and preferences."},
    {"question": "Are there any special deals or discounts available?", "answer": "Yes, Holiday Makers often has special deals and discounts on various holiday packages, flights, and hotels. Check our social media & website for the latest offers."},
    {"question": "What payment methods are accepted?", "answer": "Holiday Makers accepts various payment methods, including credit/debit cards, bank transfers, and sometimes even installment plans."},
    {"question": "Can I customize my holiday package?", "answer": "Yes, you can customize your holiday package according to your preferences. Contact our customer support for assistance."},
    {"question": "What is the cancellation policy?", "answer": "The cancellation policy varies depending on the service booked. It's best to review the specific terms and conditions provided during the booking process."},
    {"question": "How do I apply for a visa through Holiday Makers?", "answer": "We only offer visa services as part of their holiday packages, not as a standalone service. If you need a visa without booking a package, you can connect our customer support."},
    {"question": "Is travel insurance included in the holiday packages?", "answer": "Travel insurance is always included. It's recommended to check the details when booking."},
    {"question": "How can I contact customer support?", "answer": "You can contact our customer support via phone, WhatsApp, email, or live chat on our website."},
    {"question": "Are there any reviews or testimonials from previous customers?", "answer": "Yes, you can find customer reviews and testimonials on our website, which can help you gauge the quality of our services."},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: faqData.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, String> faq = entry.value;
          return FAQItem(
            question: faq['question']!,
            answer: faq['answer']!,
            isExpanded: _expandedIndex == index,
            onTap: () {
              setState(() {
                _expandedIndex = _expandedIndex == index ? null : index;
              });
            },
          );
        }).toList(),
      ),
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;
  final bool isExpanded;
  final VoidCallback onTap;

  const FAQItem({
    required this.question,
    required this.answer,
    required this.isExpanded,
    required this.onTap,
    super.key,
  });

  @override
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void didUpdateWidget(covariant FAQItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            widget.question,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Icon(widget.isExpanded ? Icons.expand_less : Icons.expand_more),
          onTap: widget.onTap,
        ),
        SizeTransition(
          sizeFactor: _animation,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 24),
            child: Text(
              widget.answer,
              style: TextStyle(
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
