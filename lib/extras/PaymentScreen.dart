import 'package:HolidayMakers/extras/TabbyService.dart';
import 'package:HolidayMakers/extras/TabbyWebView.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  

  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabbyService = TabbyService(
      apiKey: 'sk_test_6cffbd5b-d2ac-4e84-a9ea-e854e7460fb9',
      merchantCode: 'smarttravel',
      successUrl: 'https://yourdomain.com/success',
      cancelUrl: 'https://yourdomain.com/cancel',
      failureUrl: 'https://yourdomain.com/failure',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Select Payment Method')),
      body: PaymentMethods(
        amount: 5000,
        orderId: "23456",
        customerName: "ranjit",
        customerEmail: "otp.success@tabby.ai",
        customerPhone: "500000001",
        tabbyService: tabbyService,
      ),
    );
  }
}

class PaymentMethods extends StatefulWidget {
  final double amount;
  final String orderId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final TabbyService tabbyService;

  const PaymentMethods({
    Key? key,
    required this.amount,
    required this.orderId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.tabbyService,
  }) : super(key: key);

  @override
  _PaymentMethodsState createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  bool _isLoading = false;

  Future<void> _initiateTabbyPayment() async {
    setState(() => _isLoading = true);
    
    try {
      final session = await widget.tabbyService.createCheckoutSession(
        amount: widget.amount,
        orderId: widget.orderId,
        customerName: widget.customerName,
        customerEmail: widget.customerEmail,
        customerPhone: widget.customerPhone,
      );

      final paymentId = session['payment']['id'];
      final webviewUrl = session['configuration']['available_products']['installments'][0]['web_url'];

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TabbyWebView(
            url: webviewUrl,
            paymentId: paymentId,
            amount: widget.amount,
            tabbyService: widget.tabbyService,
          ),
        ),
      );

      _handlePaymentResult(result);
    } catch (e) {
      _showErrorSnackbar('Payment Error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handlePaymentResult(String? result) {
    if (result == 'success') {
      _showSuccessSnackbar('Payment successful!');
      Navigator.pop(context, true);
    } else if (result == 'cancel') {
      _showInfoSnackbar('Payment cancelled');
    } else {
      _showErrorSnackbar('Payment failed');
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showInfoSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Select your payment method:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildPaymentOption(
            icon: Icons.credit_card,
            title: 'Pay with Tabby',
            subtitle: 'Pay in installments with 0% interest',
            onTap: _initiateTabbyPayment,
          ),
          // Add other payment options here
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 40),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: _isLoading 
            ? const CircularProgressIndicator()
            : const Icon(Icons.arrow_forward),
        onTap: _isLoading ? null : onTap,
      ),
    );
  }
}