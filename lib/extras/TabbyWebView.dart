import 'package:HolidayMakers/extras/TabbyService.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TabbyWebView extends StatefulWidget {
  final String url;
  final String paymentId;
  final double amount;
  final TabbyService tabbyService;

  const TabbyWebView({
    Key? key,
    required this.url,
    required this.paymentId,
    required this.amount,
    required this.tabbyService,
  }) : super(key: key);

  @override
  _TabbyWebViewState createState() => _TabbyWebViewState();
}

class _TabbyWebViewState extends State<TabbyWebView> {
  late final WebViewController _controller;
  var _isLoading = true;
  var _canGoBack = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) => _updateLoadingState(progress == 100),
          onPageStarted: (_) => _updateLoadingState(false),
          onPageFinished: (_) async {
            _updateLoadingState(false);
            _canGoBack = await _controller.canGoBack();
          },
          onWebResourceError: (error) {
            _updateLoadingState(false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${error.description}')),
            );
          },
          onNavigationRequest: _handleNavigation,
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _updateLoadingState(bool isLoading) {
    if (mounted) {
      setState(() => _isLoading = isLoading);
    }
  }

  NavigationDecision _handleNavigation(NavigationRequest request) {
    if (request.url.contains('success')) {
      _completePayment();
      return NavigationDecision.prevent;
    }
    if (request.url.contains('cancel') || request.url.contains('failure')) {
      Navigator.pop(context, request.url.contains('cancel') ? 'cancel' : 'failure');
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  Future<void> _completePayment() async {
    try {
      final status = await widget.tabbyService.getPaymentStatus(widget.paymentId);
      
      if (status['status'] == 'CREATED') {
        await widget.tabbyService.capturePayment(
          widget.paymentId,
          widget.amount,
        );
        Navigator.pop(context, 'success');
      } else {
        Navigator.pop(context, 'failure');
      }
    } catch (e) {
      Navigator.pop(context, 'failure');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabby Payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _canGoBack
              ? () async {
                  if (await _controller.canGoBack()) {
                    await _controller.goBack();
                  } else {
                    Navigator.pop(context, 'cancel');
                  }
                }
              : null,
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}