import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:app_links/app_links.dart'; // Import the app_links package

class PaymentMethod extends StatefulWidget {
  // Dynamic Amount

  PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  final _navigatorKey = GlobalKey<NavigatorState>(); // For deep link navigation
  late StreamSubscription<Uri> _linkSubscription;

  @override
  void initState() {
    super.initState();
    initDeepLinks(); // Initialize deep link handling
  }

  @override
  void dispose() {
    _linkSubscription.cancel();
    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _linkSubscription = AppLinks().uriLinkStream.listen((uri) {
      print('onAppLink: $uri');
      handlePaymentStatus(uri);
    });
  }

  void handlePaymentStatus(Uri uri) {
    if (uri.host == 'payment') {
      String? status = uri.queryParameters['status'];
      if (status != null) {
        showToast("Payment Status: $status");
        // Optionally, navigate to another screen or show a dialog based on the status
      }
    }
  }

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
                buildPaymentOption(context, 'img/telr.png', 'Telr'),
                buildPaymentOption(context, 'img/tabby.png', 'Tabby')
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget buildPaymentOption(
      BuildContext context, String iconPath, String title) {
    return GestureDetector(
      onTap: () async {
        if (title == "Telr") {
          await initiateTelrPayment(10000);
        } else if (title == "Tabby") {
          await initiateTabbyPayment(1000);
        }
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

  Future<void> initiateTelrPayment(double amount) async {
  var storeID = '18140';
  var authKey = 'GLTzL@cdrQ-mpV5X';
  var url = Uri.parse('https://secure.telr.com/gateway/checkout');

  var headers = {'Content-Type': 'application/json'};
  var body = jsonEncode({
    "ivp_method": "checkout",
    "ivp_store": storeID,
    "ivp_authkey": authKey,
    "ivp_cart": "HMFD-${DateTime.now().millisecondsSinceEpoch}", // Unique Cart ID
    "ivp_test": "1",
    "ivp_amount": amount.toStringAsFixed(2),
    "ivp_currency": "AED",
    "ivp_desc": "Order-${DateTime.now().millisecondsSinceEpoch}",
    "return_auth": Uri.encodeFull("holidaymakers://payment?status=success"),
    "return_can": Uri.encodeFull("holidaymakers://payment?status=cancelled"),
    "return_decl": Uri.encodeFull("holidaymakers://payment?status=failed"),
    "ivp_lang": "en"
  });

  try {
    var response = await http.post(url, headers: headers, body: body);
    var responseData = jsonDecode(response.body);
    
    if (response.statusCode == 200 && responseData["order"]?["url"] != null) {
      await launchPaymentUrl(responseData["order"]["url"]);
    } else {
      showToast("Telr payment request failed: ${responseData["message"] ?? "Unknown error"}");
    }
  } catch (e) {
    showToast("Telr Payment Error: $e");
  }
}


  Future<void> initiateTabbyPayment(double amount) async {
    var url = Uri.parse('https://api.tabby.ai/api/v2/checkout');

    var headers = {
      "Authorization":
          "Bearer sk_test_6cffbd5b-d2ac-4e84-a9ea-e854e7460fb9", // Use Secret Key
      "Content-Type": "application/json"
    };

    var body = jsonEncode({
      "payment": {
        "amount": amount.toStringAsFixed(2),
        "currency": "AED",
        "description": "Test Installment Payment",
        "buyer": {
          "email": "user@example.com",
          "phone": "+971500000000",
          "name": "John Doe"
        },
        "order": {
          "reference_id": DateTime.now().millisecondsSinceEpoch.toString(),
          "items": [
            {
              "title": "Test Item",
              "quantity": 1,
              "unit_price": amount.toStringAsFixed(2)
            }
          ],
          "shipping_amount": "0.00",
          "tax_amount": "0.00"
        },
        "installments": false,
        "lang": "en"
      },
      "merchant_code": "smarttravel",
      "merchant_urls": {
        "success": "holidaymakers://payment?status=success",
        "failure": "holidaymakers://payment?status=failed",
        "webhook":
            "337410a1-91b6-40bc-afd0-08e6a66f6bfa" // Webhook for notifications
      }
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print("api responce: $responseData"); // Print the full response for debugging
        if (responseData["checkout"] != null &&
            responseData["checkout"]["web_url"] != null) {
          String paymentUrl = responseData["checkout"]["web_url"];
          await launchPaymentUrl(paymentUrl);
        } else {
          showToast("Payment URL not found for Tabby");
        }
      } else {
        showToast("Tabby payment request failed: ${response.body}");
      }
    } catch (e) {
      showToast("Tabby Payment Error: $e");
    }
  }

  Future<void> launchPaymentUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      showToast("Could not launch payment URL");
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }
}
