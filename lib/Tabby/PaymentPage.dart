import 'package:HolidayMakers/Tabby/PaymentWebView.dart';
import 'package:HolidayMakers/Tabby/TabbyPaymentService.dart';
import 'package:HolidayMakers/Tabby/TelrPaymentService.dart';
import 'package:HolidayMakers/utils/api_handler.dart';
import 'package:HolidayMakers/pages/homePages/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> BSData;
  final Map<String, dynamic> sbAPIBody;

  const PaymentScreen(
      {super.key, required this.BSData, required this.sbAPIBody});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final List<String> img = ['img/telr.png', 'img/tabby.png'];
  bool _loading = false;
  String? transactionRef; // Store the Telr transaction reference
  List<dynamic> paymentMethods = [];
  Map<String, dynamic> sbAPIResponse = {};
  String? checkoutUrl;

  void initState() {
    super.initState();
    print(widget.sbAPIBody);
    print(widget.BSData);
    // print(widget.sbAPIBody['payment_type']);
    paymentMethods = widget.BSData['payment_options'] ??
        widget.BSData['data']['payment_options'];
  }

  Future<void> _saveBooking(Map<String, dynamic> body) async {
    try {
      final response = await APIHandler.fdSaveBooking(body);
      if (response["status"] == true) {
        setState(() {
          sbAPIResponse = response['data'];
        });
        // print('===================================================');
        // print(sbAPIResponse);
        // print('===================================================');
      }
    } catch (e) {
      print("Error fetching cities: $e");
    }
  }

  void startPayment(String paymentMethod) async {
    widget.sbAPIBody['payment_type'] = paymentMethod;
    try {
      await _saveBooking(widget.sbAPIBody);
      // print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
      // print(sbAPIResponse);
      // print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

      setState(() {
        _loading = true;
      });

      if (paymentMethod == "tabby") {
        checkoutUrl = await TabbyPaymentService.createTabbySession(5000);
      } else if (paymentMethod == "telr") {
        checkoutUrl = await TelrPaymentService.createTelrSession();
      }

      setState(() {
        _loading = false;
      });

      if (checkoutUrl != null) {
        String? result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentWebView(
                paymentUrl: checkoutUrl.toString(),
                paymentMethod: paymentMethod),
          ),
        );
        // print('###############################################');
        // print(paymentMethod);
        // print(result);
        // print(transactionRef);
        // print('###############################################');
        if (paymentMethod == "telr" && result == "successfull") {
          // If Telr is selected, check the payment status after WebView closes
          String paymentStatus = await TelrPaymentService.checkPaymentStatus();

          if (paymentStatus == "success") {
            Fluttertoast.showToast(msg: "Payment Successful!");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Mainpage()),
              (Route<dynamic> route) => false, // Removes all previous routes
            );
          } else if (paymentStatus == "declined") {
            Fluttertoast.showToast(msg: "Payment Declined!");
          } else if (paymentStatus == "pending") {
            Fluttertoast.showToast(msg: "Payment Pending!");
          } else {
            Fluttertoast.showToast(msg: "Payment Failed!");
          }
        } else if (result == "success") {
          // If Tabby is selected, just show success
          Fluttertoast.showToast(msg: "Payment Successful!");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Mainpage()),
          );
        } else {
          Fluttertoast.showToast(msg: "Payment Failed or Canceled!");
        }
      } else {
        Fluttertoast.showToast(msg: "Failed to initiate payment.");
      }
    } catch (e) {
      print('Error occurred in Start Payment method: $e');
    }
  }

  Widget _buildTopCurve() {
    return Padding(
      padding: const EdgeInsets.only(top: 50), // 20% of the screen height
      child: CustomPaint(
        size: Size(double.infinity, 0), // Height of the curved area
        painter: CirclePainter(radius: 200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(title: Text("Select Payment Method")),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                _buildTopCurve(),
                const SizedBox(height: 10),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: CircleAvatar(
                        backgroundColor: Colors.grey
                            .withOpacity(0.6), // Transparent grey background
                        child: Text(
                          '<', // Use "<" symbol
                          style: TextStyle(
                            color: Colors.white, // White text color
                            fontSize: 24, // Adjust font size as needed
                            fontWeight:
                                FontWeight.bold, // Make the "<" bold if needed
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text('PAYMENT MODES',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: paymentMethods.length,
                    itemBuilder: (context, index) {
                      final paymentMethod = paymentMethods[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Card(
                          color: Colors.grey.shade50,
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: Image.network(
                                paymentMethod['payment_logo'] ?? '',
                                width: 100, // Adjust the size of the image
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              title: Text(paymentMethod['label'] ?? ''),
                              onTap: () {
                                // Handle payment method selection
                                // print('Selected payment method: ${paymentMethod['payment_type']}');
                                startPayment(
                                    paymentMethod['payment_type'] ?? "");
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double radius;

  CirclePainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..style = PaintingStyle.fill;

    // We can use FontAwesome icon positioning logic here.
    double centerX = size.width / 2;

    // Draw the largest circle (dark blue)
    paint.color = Color(0xFF0D939E);
    canvas.drawCircle(Offset(centerX, radius - 600), radius + 400, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
