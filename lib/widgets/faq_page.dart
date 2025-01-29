import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Map<String, List<Map<String, String>>> faqData = {
    "General": [
      {"question": "What is our mission?", "answer": "Our mission is to provide excellent services."},
      {"question": "How can I contact support?", "answer": "You can reach out via email or phone."},
      {"question": "Do you have a mobile app?", "answer": "Yes, we offer both Android and iOS apps."},
    ],
    "Payments": [
      {"question": "What payment methods are accepted?", "answer": "We accept credit cards, PayPal, and more."},
      {"question": "Can I pay in installments?", "answer": "Yes, installment options are available."},
    ],
    "Shipping": [
      {"question": "How long does shipping take?", "answer": "Shipping takes 3-5 business days on average."},
      {"question": "Can I track my order?", "answer": "Yes, tracking is available for all orders."},
    ],
    "Returns": [
      {"question": "What is the return policy?", "answer": "You can return items within 30 days."},
      {"question": "How do I initiate a return?", "answer": "Contact support to start a return."},
      {"question": "What is our mission?", "answer": "Our mission is to provide excellent services."},
      {"question": "How can I contact support?", "answer": "You can reach out via email or phone."},
      {"question": "Do you have a mobile app?", "answer": "Yes, we offer both Android and iOS apps."},
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: faqData.keys.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0,),
              child: Row( 
                children: faqData.keys.map((key) {
                  final isSelected = faqData.keys.toList().indexOf(key) == _tabController.index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _tabController.index = faqData.keys.toList().indexOf(key);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.red : Colors.white,
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
                          child: Text(
                            key,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0, // Adjust font size for responsiveness
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: faqData.keys.map((key) {
                  return ListView(
                    padding: const EdgeInsets.all(12.0),
                    children: faqData[key]!
                        .map((faq) => FAQItem(question: faq['question']!, answer: faq['answer']))
                        .toList(),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String? answer;

  const FAQItem({
    required this.question,
    this.answer,
  });

  @override
  _FAQItemState createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> with SingleTickerProviderStateMixin {
  bool isExpanded = false;
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
          trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
              if (isExpanded) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            });
          },
        ),
        SizeTransition(
          sizeFactor: _animation,
          child: widget.answer != null
              ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              widget.answer!,
              style: TextStyle(
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.justify,
            ),
          )
              : const SizedBox.shrink(),
        ),
        const Divider(),
      ],
    );
  }
}
