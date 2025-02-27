import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PaymentMethod extends StatefulWidget {
  PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
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
                buildPaymentOption(context, 'img/visa.png', 'Visa'),
                buildPaymentOption(context, 'img/mastercard.png', 'MasterCard'),
                buildPaymentOption(context, 'img/amex.png', 'American Express'),
                buildPaymentOption(context, 'img/paypal.png', 'PayPal'),
                buildPaymentOption(context, 'img/diners.png', 'Diners'),
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
      onTap: () async {
        await initiateTelrPayment();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: 10),
                  Image.asset(
                    iconPath,
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 20),
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
                padding: const EdgeInsets.only(right: 10),
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

  /// Initiates payment with Telr API and redirects the user to the payment page.
  Future<void> initiateTelrPayment() async {
    var storeID = 'YOUR_STORE_ID';
    var authKey = 'YOUR_AUTH_KEY';
    var url = Uri.parse('https://secure.telr.com/gateway/order.json');

    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      "ivp_method": "create",
      "ivp_store": storeID,
      "ivp_authkey": authKey,
      "ivp_cart": DateTime.now().millisecondsSinceEpoch.toString(), // Unique order ID
      "ivp_test": "1", // Set to "0" for production
      "ivp_amount": "100",
      "ivp_currency": "AED",
      "ivp_desc": "Test Payment",
      "return_auth": "https://yourwebsite.com/success",
      "return_can": "https://yourwebsite.com/cancel",
      "return_decl": "https://yourwebsite.com/failure",
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData["order"] != null && responseData["order"]["url"] != null) {
          String paymentUrl = responseData["order"]["url"];
          await launchPaymentUrl(paymentUrl);
        } else {
          Fluttertoast.showToast(msg: "Failed to get payment URL");
        }
      } else {
        Fluttertoast.showToast(msg: "Payment request failed: ${response.body}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  /// Opens the Telr payment page in a browser or WebView
  Future<void> launchPaymentUrl(String url) async {
  Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    Fluttertoast.showToast(msg: "Could not launch payment URL");
  }
}
}
