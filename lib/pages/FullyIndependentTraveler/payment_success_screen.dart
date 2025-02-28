import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/homePages/mainPage.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();

    // Redirect after 900 milliseconds
    Future.delayed(const Duration(milliseconds: 2500), () {
       Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Mainpage()), // Replace `HomePage` with your actual home page widget.
      ); // Replace '/home' with the actual route for your home page.
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
                padding: const EdgeInsets.all(5),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 120, // Increased size for bold effect
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Payment Successful',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
