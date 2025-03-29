import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class TelrPaymentService {
  static String? code;
  static const String _authUrl =
      "https://secure.innovatepayments.com/gateway/mobile.xml";
  static const String _statusUrl =
      "https://secure.innovatepayments.com/gateway/mobile_complete.xml";
  static const String _storeId = "18140";
  static const String _storeKey = "GLTzL@cdrQ-mpV5X";

  static Future<String?> createTelrSession() async {
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
<cartid>BOOKREF1234</cartid>
<description>Cruise Payment</description>
<currency>AED</currency>
<amount>500</amount>
<language>en</language>
<ref></ref>
</tran>
<billing>
<name>
<title>Mr</title>
<first>John</first>
<last>Doe</last>
</name>
<address>
<line1>Address line 1</line1>
<line2>Address line 2</line2>
<city>Dubai</city>
<region>Gulf</region>
<country>United Arab Emirates</country>
<zip>000000</zip>
</address>
<phone>+971524589887</phone>
<email>testuser@gmail.com</email>
</billing>
</mobile>
    ''';

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/xml"},
      body: requestXml,
    );

    if (response.statusCode == 200) {
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
  static Future<String> checkPaymentStatus() async {
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

      // ✅ Telr Status Codes
      if (status == "A") return "success"; // Approved
      if (status == "D") return "declined"; // Declined
      if (status == "P") return "pending"; // Pending
    }

    return "failed"; // Default to failed
  }
}
