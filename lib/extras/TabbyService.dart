import 'dart:convert';
import 'package:http/http.dart' as http;

class TabbyService {
  static const String _baseUrl = 'https://api.tabby.ai/api/v2/';
  final String apiKey;
  final String merchantCode;
  final String successUrl;
  final String cancelUrl;
  final String failureUrl;

  TabbyService({
    required this.apiKey,
    required this.merchantCode,
    required this.successUrl,
    required this.cancelUrl,
    required this.failureUrl,
  });

  // Payment payload templates
  Map<String, dynamic> _createCheckoutPayload({
    required double amount,
    required String orderId,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
  }) {
    return {
        "payment": {
          "amount": 5449,
          "currency": "AED",
          "description": "FD_VHCID1433498322",
          "buyer": {
            "phone": "500000001",
            "email": "otp.success@tabby.ai",
            "name": "Ranjith",
            "dob": "0000-00-00"
          },
          "order": {
            "tax_amount": "0.00",
            "shipping_amount": "0.00",
            "discount_amount": "0.00",
            "updated_at": "2025-03-25T14:39:41Z",
            "reference_id": "HMFD-509",
            "items": [
              {
                "title": "Zanzibar : Honeymoon Package",
                "description": "Zanzibar : Honeymoon Package",
                "quantity": 1,
                "unit_price": 5449,
                "discount_amount": "0.00",
                "reference_id": "HMFD-509",
                "image_url":
                    "https://b2cuat.tikipopi.com/extras/custom/TMX1512291534825461/uploads/package_images/17425600961740485376freepik__expand__71870.jpg",
                "product_url":
                    "https://b2cuat.tikipopi.com/package/holidays-details/zanzibar-tanzaniaa-honeymoon-holiday-package",
                "gender": "Male",
                "category": "FD_VHCID1433498322_HMFD-509",
                "product_material": "Holiday Package",
                "brand": "Holidaymakers"
              }
            ]
          },
          "shipping_address": {
            "city": "Dubai",
            "address": "Dubai",
            "zip": "00000"
          },
          "meta": {"order_id": "HMFD-509", "customer": "0"}
        },
        "lang": "en",
        "merchant_code": "smarttravel",
        "webhook_key": "337410a1-91b6-40bc-afd0-08e6a66f6bfa",
        "merchant_urls": {
          "success":
              "holidaymakers://payment?status=success",
          "cancel":
              "https://b2cuat.tikipopi.com/index.php/payment_gateway/tabby_cancel/HMFD-509/FD_VHCID1433498322",
          "failure":
              "https://b2cuat.tikipopi.com/index.php/payment_gateway/tabby_failure/HMFD-509/FD_VHCID1433498322"
        }
      };
  }

  Map<String, dynamic> _createCapturePayload(double amount) {
    return {
      "amount": amount.toStringAsFixed(2),
      "tax_amount": "0.00",
      "shipping_amount": "0.00",
    };
  }

  // API Methods
  Future<Map<String, dynamic>> createCheckoutSession({
    required double amount,
    required String orderId,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
  }) async {
    final payload = _createCheckoutPayload(
      amount: amount,
      orderId: orderId,
      customerName: customerName,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
    );

    final response = await http.post(
      Uri.parse('${_baseUrl}checkout'),
      headers: _buildHeaders(),
      body: json.encode(payload),
    );

    return _handleResponse(response, 'Failed to create checkout session');
  }

  Future<Map<String, dynamic>> getPaymentStatus(String paymentId) async {
    final response = await http.get(
      Uri.parse('${_baseUrl}payments/$paymentId'),
      headers: _buildHeaders(),
    );

    return _handleResponse(response, 'Failed to get payment status');
  }

  Future<Map<String, dynamic>> capturePayment(
    String paymentId,
    double amount,
  ) async {
    final payload = _createCapturePayload(amount);
    
    final response = await http.post(
      Uri.parse('${_baseUrl}payments/$paymentId/capture'),
      headers: _buildHeaders(),
      body: json.encode(payload),
    );

    return _handleResponse(response, 'Failed to capture payment');
  }

  // Helper methods
  Map<String, String> _buildHeaders() {
    return {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };
  }

  Map<String, dynamic> _handleResponse(http.Response response, String errorMessage) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('$errorMessage: ${response.statusCode} - ${response.body}');
    }
  }
}