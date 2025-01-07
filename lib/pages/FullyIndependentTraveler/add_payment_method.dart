import 'package:flutter/material.dart';
import 'payment_success_screen.dart'; // Import the PaymentSuccessScreen

class AddPaymentMethod extends StatefulWidget {
  const AddPaymentMethod({super.key});

  @override
  State<AddPaymentMethod> createState() => _AddPaymentMethodState();
}

class _AddPaymentMethodState extends State<AddPaymentMethod> {
  String? selectedCountry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Add Payment Methods',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Payment Details Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Name on Card',
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey.shade200,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Card Number',
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey.shade200,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Valid Till*',
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey.shade200,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Enter CVV*',
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey.shade200,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Your Details Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Details',
                    style: TextStyle(
                      color: Colors.grey, // Gray text color for title
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey.shade200,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Address Line 1',
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey.shade200,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Address Line 2',
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey.shade200,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'City',
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey.shade200,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Region/ State',
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey.shade200,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedCountry,
                          onChanged: (value) {
                            setState(() {
                              selectedCountry = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Country',
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey.shade200,
                          ),
                          items: [
                            'United States',
                            'Canada',
                            'India',
                            'United Kingdom',
                            'Australia'
                          ]
                              .map((country) => DropdownMenuItem(
                            value: country,
                            child: Text(country),
                          ))
                              .toList(),
                          icon: const Icon(Icons.arrow_drop_down, size: 24),
                          iconSize: 24,
                          iconEnabledColor: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Post/Zip Code',
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey.shade200,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Buttons Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentSuccessScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      shadowColor: Colors.black,
                      elevation: 5,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'CONFIRM',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Navigate back on cancel
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      shadowColor: Colors.black,
                      elevation: 5,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
