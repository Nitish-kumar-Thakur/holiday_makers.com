import 'package:flutter/material.dart';
import 'add_payment_method.dart'; // Import the AddPaymentMethod file

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back, color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Text(
              'Payment Methods',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 50),
          Expanded(
            child: ListView(
              children: [
                buildPaymentOption(
                  context,
                  'img/visa.png',
                  'Visa',
                ),
                buildPaymentOption(
                  context,
                  'img/mastercard.png',
                  'MasterCard',
                ),
                buildPaymentOption(
                  context,
                  'img/amex.png',
                  'American Express',
                ),
                buildPaymentOption(
                  context,
                  'img/paypal.png',
                  'PayPal',
                ),
                buildPaymentOption(
                  context,
                  'img/diners.png',
                  'Diners',
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget buildPaymentOption(BuildContext context, String iconPath, String title) {
    return GestureDetector(
      onTap: () {
        // Navigate to AddPaymentMethod screen on tap
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddPaymentMethod()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          height: 70, // Increased height for the option
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: 10), // Left padding for icon
                  Image.asset(
                    iconPath,
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 20), // Space between icon and text
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10), // Right padding for arrow
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
