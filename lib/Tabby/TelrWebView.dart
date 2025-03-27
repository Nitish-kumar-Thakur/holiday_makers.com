import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Telrwebview extends StatefulWidget {
  final String paymentUrl;

  Telrwebview({required this.paymentUrl});

  @override
  _TelrwebviewState createState() => _TelrwebviewState();
}

class _TelrwebviewState extends State<Telrwebview> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (url.contains("close")) {
              Navigator.pop(context, "success");
            } else if (url.contains("failure")) {
              Navigator.pop(context, "failure");
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(title: Text("Complete Payment")),
      body: SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }
}
