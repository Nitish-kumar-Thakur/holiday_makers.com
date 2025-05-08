import 'dart:convert';
import 'package:http/http.dart' as http;

class TabbyService {
  static const String _baseUrl = "https://api.tabby.ai/api/v2";
  final String apiKey = 'sk_test_6cffbd5b-d2ac-4e84-a9ea-e854e7460fb9';

  // TabbyService({required this.apiKey});

  Future<Map<String, dynamic>> createCheckoutSession() async {
    final url = Uri.parse("$_baseUrl/checkout");
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
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
          "success": "holidaymakers://payment?status=success",
          "cancel":
              "https://holidaymakers.com/holiday_api/payment_gateway/tabby_cancel/HMFD-509/FD_VHCID1433498322",
          "failure":
              "https://holidaymakers.com/holiday_api/payment_gateway/tabby_failure/HMFD-509/FD_VHCID1433498322"
        }
      }),
    );
    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    try {
      final data = json.decode(response.body);
      return data;
    } catch (e) {
      return {'error': 'Invalid response'};
    }
  }

  Future<Map<String, dynamic>> getPaymentStatus(String paymentId) async {
    print("getPaymentStatus service");
    final response = await http.get(
      Uri.parse('$_baseUrl/payments/$paymentId'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
    );

    try {
      final data = json.decode(response.body);
      return data;
    } catch (e) {
      return {'error': 'Invalid response'};
    }
  }

  Future<Map<String, dynamic>> capturePayment(String paymentId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/payments/$paymentId/captures'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "amount": "100.00",
        "reference_id": "HMCR-EMI-51_4500",
        "tax_amount": "0.00",
        "shipping_amount": "0.00",
        "discount_amount": "0.00",
        "created_at": "2025-02-26T14:15:22Z",
        "items": [
          {
            "title": "Oman : UAE National Day",
            "description": "Oman : UAE National Day",
            "quantity": 1,
            "unit_price": "100.00",
            "discount_amount": "0.00",
            "reference_id": "string",
            "image_url": "http://example.com",
            "product_url": "http://example.com",
            "gender": "Male",
            "category": "string",
            "color": "string",
            "product_material": "string",
            "size_type": "string",
            "size": "string",
            "brand": "string",
            "is_refundable": true
          }
        ]
      }),
    );

    try {
      final data = json.decode(response.body);
      return data;
    } catch (e) {
      return {'error': 'Invalid response'};
    }
  }
}
