import 'dart:convert';
import 'package:http/http.dart' as http;

class TabbyPaymentService {
  static const String _apiUrl = "https://api.tabby.ai/api/v2/checkout";
  static const String _secretKey =
      "sk_test_6cffbd5b-d2ac-4e84-a9ea-e854e7460fb9"; // Ensure it's correct
  static const String _merchantCode = "smarttravel"; // Verify this
  static const String _webhookKey = "337410a1-91b6-40bc-afd0-08e6a66f6bfa";

  static Future<String?> createTabbySession({
    required double amount,
    required String description,
    required String referenceId,
    required String buyerPhone,
    required String buyerEmail,
    required String buyerName,
    required String itemTitle,
    required String itemDescription,
    required String itemImageUrl,
    required String itemProductUrl,
    required String itemCategory,
    required String orderId,
    required String customerId,
  }) async {
    final url = Uri.parse(_apiUrl);

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $_secretKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "payment": {
          "amount": amount,
          "currency": "AED",
          "description": description,
          "buyer": {
            "phone": buyerPhone,
            "email": buyerEmail,
            "name": buyerName,
            "dob": "0000-00-00"
          },
          "order": {
            "tax_amount": "0.00",
            "shipping_amount": "0.00",
            "discount_amount": "0.00",
            "updated_at": DateTime.now().toIso8601String(),
            "reference_id": referenceId,
            "items": [
              {
                "title": itemTitle,
                "description": itemDescription,
                "quantity": 1,
                "unit_price": amount,
                "discount_amount": "0.00",
                "reference_id": referenceId,
                "image_url": itemImageUrl,
                "product_url": itemProductUrl,
                "gender": "Male",
                "category": itemCategory,
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
          "meta": {"order_id": orderId, "customer": customerId}
        },
        "lang": "en",
        "merchant_code": _merchantCode,
        "merchant_urls": {
          "success": "holidaymakers://payment?status=success",
          "cancel": "https://b2cuat.tikipopi.com/index.php/payment_gateway/tabby_cancel/$orderId/$referenceId",
          "failure": "https://b2cuat.tikipopi.com/index.php/payment_gateway/tabby_failure/$orderId/$referenceId"
        }
      }),
    );

    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print(data['configuration']['available_products']['installments'][0]['web_url']);
      return data['configuration']['available_products']['installments'][0]['web_url'];
      // return "https://checkout.tabby.ai/?apiKey=pk_test_c4f49063-5ef5-4c31-bfcd-5d5a8a903cbb&lang=eng&merchantCode=smarttravel&product=installments&sessionId=17cc7f1b-5b6f-4b92-ad00-44e06f86c0e7";
    } else {
      print("Tabby Payment Error: ${response.body}");
      return null;
    }
  }
}
