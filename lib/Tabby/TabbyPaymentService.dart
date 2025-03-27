import 'dart:convert';
import 'package:http/http.dart' as http;

class TabbyPaymentService {
  static const String _apiUrl = "https://api.tabby.ai/api/v2/checkout";
  static const String _secretKey =
      "sk_test_6cffbd5b-d2ac-4e84-a9ea-e854e7460fb9"; // Ensure it's correct
  static const String _merchantCode = "smarttravel"; // Verify this

  static Future<String?> createTabbySession(double amount) async {
    final url = Uri.parse(_apiUrl);

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $_secretKey",
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
          "success":
              "holidaymakers://payment?status=success",
          "cancel":
              "https://b2cuat.tikipopi.com/index.php/payment_gateway/tabby_cancel/HMFD-509/FD_VHCID1433498322",
          "failure":
              "https://b2cuat.tikipopi.com/index.php/payment_gateway/tabby_failure/HMFD-509/FD_VHCID1433498322"
        }
      }),
    );

    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // print(data['configuration']['available_products']['installments'][0]['web_url'];
      return data['configuration']['available_products']['installments'][0]['web_url'];
      // return "https://checkout.tabby.ai/?apiKey=pk_test_c4f49063-5ef5-4c31-bfcd-5d5a8a903cbb&lang=eng&merchantCode=smarttravel&product=installments&sessionId=17cc7f1b-5b6f-4b92-ad00-44e06f86c0e7";
    } else {
      print("Tabby Payment Error: ${response.body}");
      return null;
    }
  }
}
