import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  final String paymentUrl;
  final String paymentMethod;

  PaymentWebView({required this.paymentUrl, required this.paymentMethod});

  @override
  _PaymentWebViewState createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    _controller = WebViewController()
      ..clearCache()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.5481.77 Safari/537.36")
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (widget.paymentMethod == "tabby") {
              if (url.contains("success")) {
                print('success in tabby webview');
                Navigator.pop(context, "success");
              } else if (url.contains("failure")) {
                print('failure in tabby webview');
                Navigator.pop(context, "failure");
              }
            } else if (widget.paymentMethod == "telr") {
              if (url.contains("close")) {
                print('success in telr webview');
                Navigator.pop(context, "successfull");
              } else if (url.contains("abort")) {
                print('failure in webview');
                Navigator.pop(context, "failure");
              }
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    print("paymentUrl ${widget.paymentUrl}");
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(title: Text("Complete Payment")),
      body: SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }
}
