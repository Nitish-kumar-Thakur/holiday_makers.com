import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:xml/xml.dart' as xml;

class TelrPaymentService {
  static const String _authUrl =
      "https://secure.innovatepayments.com/gateway/mobile.xml";
  static const String _statusUrl =
      "https://secure.innovatepayments.com/gateway/mobile_complete.xml";
  static const String _storeId = "18140";
  static const String _storeKey = "GLTzL@cdrQ-mpV5X";

  // data only for update booking status
  static String? code;
  static String? ivpStore;
  static String? ivpAuthKey;
  static String? ivpCart;
  static String? ivpAmount;
  static String? ivpCurrency;
  static String? ivpDesc;
  static String? billName;
  static String? billAddr1;
  static String? billAddr2;
  static String? billCity;
  static String? billRegion;
  static String? billCountry;
  static String? billZip;
  static String? billEmail;
  static String? tranref;
  static String? authCode;
  static String? message;
  static String? cvv;
  static String? avs;
  static String? cardCode;
  static String? cardLast4;
  static String? cardCountry;
  static String? cardFirst6;
  static String? expiryMonth;
  static String? expiryYear;
  static String? caValid;
  static String? trace;

  //////

  static Future<String?> createTelrSession({
    required String ivpStore,
    required String ivpAuthKey,
    required String ivpCart,
    required String ivpAmount,
    required String ivpCurrency,
    required String ivpDesc,
    required String billName,
    required String billAddr1,
    required String billAddr2,
    required String billCity,
    required String billRegion,
    required String billCountry,
    required String billZip,
    required String billEmail,
  }) async {
    // Assign passed values to class-level variables
    // Assign to static class-level variables
    TelrPaymentService.ivpStore = ivpStore;
    TelrPaymentService.ivpAuthKey = ivpAuthKey;
    TelrPaymentService.ivpCart = ivpCart;
    TelrPaymentService.ivpAmount = ivpAmount;
    TelrPaymentService.ivpCurrency = ivpCurrency;
    TelrPaymentService.ivpDesc = ivpDesc;
    TelrPaymentService.billName = billName;
    TelrPaymentService.billAddr1 = billAddr1;
    TelrPaymentService.billAddr2 = billAddr2;
    TelrPaymentService.billCity = billCity;
    TelrPaymentService.billRegion = billRegion;
    TelrPaymentService.billCountry = billCountry;
    TelrPaymentService.billZip = billZip;
    TelrPaymentService.billEmail = billEmail;
    final url = Uri.parse(_authUrl);

    final requestXml = '''<?xml version="1.0" encoding="UTF-8"?>
<mobile>
<store>$_storeId</store>
<key>$_storeKey</key>
<device>
<type>ANDROID</type>
<id>DeviceID_1234</id>
</device>
<app>
<name>Holiday Makers</name>
<version>1.0.0</version>
<user>U1</user>
<id>D1</id>
</app>
<tran>
<test>1</test>
<type>paypage</type>
<cartid>$ivpCart</cartid>
<description>$ivpDesc</description>
<currency>$ivpCurrency</currency>
<amount>$ivpAmount</amount>
<language>en</language>
<ref></ref>
</tran>
<billing>
<name>
<title>Mr</title>
<first>$billName</first>
<last></last>
</name>
<address>
<line1>$billAddr1</line1>
<line2>$billAddr2</line2>
<city>$billCity</city>
<region>$billRegion</region>
<country>$billCountry</country>
<zip>$billZip</zip>
</address>
<phone></phone>
<email>$billEmail</email>
</billing>
</mobile>
    ''';

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/xml"},
      body: requestXml,
    );

    if (response.statusCode == 200) {
      print("Cart_id: $ivpCart");
      final document = xml.XmlDocument.parse(response.body);
      final startUrl = document.findAllElements("start").firstOrNull?.text;
      code = document
          .findAllElements("code")
          .firstOrNull
          ?.text; // ✅ Capture Transaction Reference
      print("telr code $code");

      if (startUrl != null) {
        return startUrl;
      }
    }

    return null;
  }

  /// ✅ Check Payment Status using `mobile_complete.xml`
  ///
  ///

  static Future<String> checkPaymentStatus() async {
    print("telr code: $code");

    final url = Uri.parse(_statusUrl);

    final requestXml = '''<?xml version="1.0" encoding="UTF-8"?>
<mobile>
<store>$_storeId</store>
<key>$_storeKey</key>
<complete>$code</complete>
</mobile>
    ''';

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/xml"},
      body: requestXml,
    );

    if (response.statusCode == 200) {
      final document = xml.XmlDocument.parse(response.body);
      final status = document.findAllElements("status").firstOrNull?.text;
      authCode = document.findAllElements("code").firstOrNull?.text;
      message = document.findAllElements("message").firstOrNull?.text;
      tranref = document.findAllElements("tranref").firstOrNull?.text;
      cvv = document.findAllElements("cvv").firstOrNull?.text;
      avs = document.findAllElements("avs").firstOrNull?.text;
      final rawCardCode =
          document.findAllElements("cardcode").firstOrNull?.text;
      cardCode = {
            "VC": "Visa Credit",
            "VD": "Visa Debit",
            "MC": "MasterCard Credit",
            "MD": "MasterCard Debit",
            "AX": "American Express",
            "DS": "Discover",
            "TP": "Tele-Payment",
            "PP": "PayPal",
          }[rawCardCode] ??
          "Unknown";
      cardLast4 = document.findAllElements("cardlast4").firstOrNull?.text;
      cardCountry = document.findAllElements("country").firstOrNull?.text;
      cardFirst6 = document.findAllElements("first6").firstOrNull?.text;
      expiryMonth = document.findAllElements("month").firstOrNull?.text;
      expiryYear = document.findAllElements("year").firstOrNull?.text;
      caValid = document.findAllElements("ca_valid").firstOrNull?.text;
      trace = document.findAllElements("trace").firstOrNull?.text;
      print("transref: $tranref");

      // ✅ Telr Status Codes
      if (status == "A") {
        updateBookingStatus("3");
        return "success";
      }
      ; // Approved
      if (status == "D") {
        updateBookingStatus("-2");
        return "declined";
      } // Declined
      if (status == "P") {
        updateBookingStatus("-2");
        return "pending";
      } // Pending
    }

    return "failed"; // Default to failed
  }

  static Future updateBookingStatus(String statusCode) async {
    final url = Uri.parse(
        "https://b2cuat.tikipopi.com/index.php/holiday_api/update_booking_status");
    final payload = {
      "enquiry_code": ivpCart,
      "status_code": statusCode, // 3 = accepted, -2 = cancelled, etc.
      "reference_no": tranref, // <- From Telr response <tranref>
      "response": [
        {
          "method":
              "check", // or "callback" if this is being sent from your backend callback
          "trace": trace, // <- From Telr response <trace>
          "order": {
            "ref":
                code, // <- From your original mobile_complete request <complete>
            "cartid": ivpCart, // <- From your initial request <cartid>
            "test": 1, // <- From your initial request <test>
            "amount": double.tryParse(ivpAmount??"").toString(), // <- From your initial request <amount>
            "currency": ivpCurrency, // <- From your initial request <currency>
            "description":
                ivpDesc, // <- From your initial request <description>
            "status": {"code": 3, "text": "Paid"},
            "transaction": {
              "ref": tranref, // <- From Telr response <tranref>
              "date":
                  DateFormat("dd MMM yyyy HH:mm 'GST'").format(DateTime.now()),
              // <- Not available in current XML, you might format it manually
              "type": "sale", // <- Implied from your request <type>
              "class": "ECom", // <- Default class
              "status": "A", // <- From Telr response <status>
              "code": authCode, // <- From Telr response <code>
              "message": message // <- From Telr response <message>
            },
            "paymethod": "Card",
            "card": {
              "type":
                  cardCode, // <- You can determine this from <cardcode> = "VC"
              "last4": cardLast4, // <- From Telr response <cardlast4>
              "country": cardCountry, // <- From Telr response <card><country>
              "first6": cardFirst6, // <- From Telr response <card><first6>
              "expiry": {
                "month": int.tryParse(expiryMonth ?? ''),
                "year": int.tryParse(expiryYear ?? '')
              }
            },
            "customer": {
              "email": billEmail, // <- From your original billing data
              "name": {
                "forenames": billName?.split(' ').first ?? '',
                "surname": billName?.split(' ').skip(1).join(' ') ?? ''
              },

              "address": {
                "line1": billAddr1,
                "city": billCity,
                "country":  _resolveCountryCode(billCountry)
              }
            }
          }
        }
      ]
    };
    print("payload: $payload");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(payload),
    );

    print("updateBookingStatus responce Code: ${response.statusCode}");
    print("updateBookingStatus Response Body: ${response.body}");
  }
  static String _resolveCountryCode(String? country) {
  // Fallback to ISO codes if needed
  if (country?.toLowerCase() == 'india') return 'IN';
  if (country?.toLowerCase() == 'united arab emirates') return 'AE';
  return country ?? 'IN';
}

}
