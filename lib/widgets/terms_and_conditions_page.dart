import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      "Terms & Conditions",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 48.0), // To balance the Row's layout
                ],
              ),
            ),
            // Custom App Bar

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Maintained by Signature Travel and Tourism LLC',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    termsCard(
                        "1. Legal Jurisdiction",
                        "Signature Travel and Tourism LLC is domiciled in the United Arab Emirates (UAE), and all terms governing the use of this website are in accordance with UAE law. By using this site, you expressly agree to comply with all applicable laws and regulations. Signature Travel and Tourism LLC reserves the right to update or modify these terms without prior notice due to changing conditions.",
                        []
                    ),
                    SizedBox(height: 16.0),

                    termsCard(
                        "2. Violations of Terms",
                        "In the event of any violation of these terms, Signature Travel and Tourism LLC Travel LLC reserves the right to block your access to the site and take legal action as necessary.",
                        []
                    ),
                    SizedBox(height: 16.0),

                    termsCard(
                      "3. User Responsibility",
                      "",
                      [
                        "Account Security: You are solely responsible for all transactions made through your account. It is your duty to maintain the confidentiality of your account credentials, including regularly updating your password.",
                        "Liability: Signature Travel and Tourism LLC is not responsible for any loss or damage resulting from failure to comply with this section.",
                      ],
                    ),
                    SizedBox(height: 16.0),

                    termsCard(
                        "4. Commercial Use",
                        "You may not use this site or its content for any commercial purpose, including the sale of goods or services, without written permission from Signature Travel and Tourism LLC. Unauthorized commercial offers, advertisements, or links are prohibited.",
                        []
                    ),
                    SizedBox(height: 16.0),

                    termsCard(
                        "5. Third-Party Links",
                        "This site may contain links to external websites for enhancing user experience. Signature Travel and Tourism LLC is not responsible for the content, claims, or services provided by these third-party websites. Any issues arising from the use of these external links should be reported to info@holidaymakers.com for further assistance.",
                        []
                    ),
                    SizedBox(height: 16.0),

                    termsCard(
                        "6. License Limitation",
                        "You are granted a limited, non-exclusive, revocable, and non-transferable license to use the site in accordance with these terms. You are not permitted to modify, adapt, rent, sell, reproduce, or exploit the site or its content in any way.",
                        []
                    ),
                    SizedBox(height: 16.0),

                    termsCard(
                        "7. Governing Law & Jurisdiction",
                        "All disputes arising from the use of this site will be governed by the laws of the United Arab Emirates. Any legal action or proceedings will be subject to the jurisdiction of UAE courts.",
                        []
                    ),
                    SizedBox(height: 16.0),

                    termsCard(
                        "8. Payment & Transactions",
                        "",
                        ["Payment Methods: Purchases made through the site may be completed via online bank transfer, payment gateway, or offline payment to Signature Travel and Tourism LLC.",
                          "Non-Payment: Signature Travel and Tourism LLC reserves the right to cancel, refund, or block any transaction if payment is not received at the time of booking.",
                          "Cancellation & Changes: Booking cancellations or changes are subject to the terms of the service providers selected. Cancellation or change fees may apply and are subject to deductions from the transaction amount. Signature Travel and Tourism LLC may apply an additional handling fee."]
                    ),
                    SizedBox(height: 16.0),

                    termsCard(
                        "9. Intellectual Property & Copyright",
                        "All content on this site is the property of Signature Travel and Tourism LLC. It is intended for personal use only. Unauthorized copying, deep-linking, or any other form of copyright violation is prohibited and may result in termination of access and legal action.",
                        []
                    ),
                    SizedBox(height: 16.0),

                    termsCard(
                        "10. Liability Disclaimer",
                        "Signature Travel and Tourism LLC acts as a facilitator for various services (e.g., transportation, accommodation) and cannot assume liability for injuries, delays, or damages caused by third party providers. By using this site, you agree to indemnify Signature Travel and Tourism LLC against any claims or damages arising from third-party services.",
                        []
                    ),
                    SizedBox(height: 16.0),

                    termsCard(
                        "11. Force Majeure",
                        "Signature Travel and Tourism LLC is not liable for delays or failure in performance due to events beyond its control, including but not limited to natural disasters, terrorism, strikes, or other circumstances.",
                        []
                    ),
                    SizedBox(height: 16.0),

                    termsCard(
                        "12. Third-Party Advertisements",
                        "This site may display advertisements, offers, or sponsorships from third parties. Signature Travel and Tourism LLC is not responsible for any actions, services, or omissions by these external advertisers or sponsors.",
                        []
                    ),
                    SizedBox(height: 16.0),

                    termsCard(
                        "13. Office of Foreign Assets Control (OFAC)",
                        "Signature Travel and Tourism LLC does not provide services to individuals or companies that are subject to OFAC sanctions or those acting on behalf of sanctioned countries.",
                        []
                    ),
                    SizedBox(height: 16.0),

                    termsCard(
                        "14. Severability",
                        "If any provision of these terms is deemed invalid, void, or unenforceable, the remaining provisions will remain in effect.",
                        []
                    ),
                    SizedBox(height: 16.0),

                    termsCard(
                        "15. Special Requests",
                        "HolidayMakers.com will make reasonable efforts to accommodate special requests from customers, such as early check-in, dietary needs, room preferences, wheelchair assistance, etc. However, such requests are not guaranteed. All requests are subject to availability, and the fulfillment is at the sole discretion of the service provider.",
                        []
                    ),
                    SizedBox(height: 16.0),

                    termsCard(
                        "16. Cruise Packages",
                        "All cruise packages booked through HolidayMakers.com are non-refundable and non-transferable under any circumstances. Once a booking is confirmed, no cancellations or modifications are permitted as per the cruise line policy.",
                        []
                    ),
                    SizedBox(height: 16.0),

                    termsCard(
                        "17. Wizz Air Bookings",
                        "Please be advised that all bookings made with Wizz Air are strictly non-refundable and non-transferable. Once the booking is confirmed, no changes or cancellations can be made, and no refunds will be issued under any circumstances.",
                        []
                    ),
                    SizedBox(height: 16.0),

                    termsCard(
                        "18. Visa and Other Travel Requirements",
                        "Guests are required to ensure that their passports are valid for at least six months until the end of their travel date. Visa and immigration requirements may vary based on the destination and the guest's nationality. HolidayMakers.com disclaims any responsibility for visa-related issues and will not issue refunds for guests denied entry due to non-compliance with immigration regulations or these Terms and Conditions. Guests are advised to recheck all travel requirements directly with the relevant embassy.",
                        []
                    ),
                    SizedBox(height: 16.0),

                    termsCard(
                        "19. Schedule Changes",
                        "HolidayMakers.com is not responsible for any flight delays or cancellations caused by the airline. However, we will provide full assistance to support our customers in securing the best possible solution from the supplier.",
                        []
                    ),
                    SizedBox(height: 16.0),

                    termsCard(
                        "20. Public Holidays",
                        "Changes or cancellations for Public Holiday packages are allowed up to 15 days before departure, with a fee of 50% of the total amount paid, along with any applicable fare differences based on the new request. After this period, the booking will be non-refundable.",
                        []
                    ),
                    SizedBox(height: 16.0),

                    termsCard(
                        "21. Name Correction",
                        "Name changes or corrections are not permitted as per airline policy. In such cases, the original ticket must be canceled, subject to applicable fees, and a new ticket will be issued.",
                        []
                    ),
                    SizedBox(height: 16.0),

                    termsCard(
                        "REFUND POLICY",
                        "Refund is not applicable. Balance amount of the booking can only be used against the future booking",
                        []
                    ),
                    SizedBox(height: 16.0),

                    // Date Change Table
                    _buildTableSection(
                      "DATE CHANGE",
                      [
                        ["7 days before departure", "AED 500 Per Person"],
                        ["72hrs before departure", "AED 800 Per Person"],
                        ["48 hrs before departure", "70% of the package price"],
                        ["24 hrs before departure", "90% of the package price"],
                        ["Within 24 hrs before departure", "Non Refundable"],
                      ],
                    ),
                    SizedBox(height: 30),

                    // Cancellations Table
                    _buildTableSection(
                      "CANCELLATIONS",
                      [
                        ["More than 7 days", "AED 800 Per Person"],
                        ["Between 7 days - 72 hrs before departure", "70% of the package price"],
                        ["Between 72 hrs - 42 hrs before departure", "90% of the package price"],
                        ["Within 24hrs before departure", "Non Refundable"],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget termsCard(String title, String? description, List<String> items) {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.isNotEmpty) ...[
              Text(
                title,
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
            ],
            if (description != null && description.trim().isNotEmpty) ...[
              Text(
                description,
                style: const TextStyle(fontSize: 16.0, height: 1.5),
              ),
              const SizedBox(height: 8.0),
            ],
            if (items.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: items
                      .where((item) => item.trim().isNotEmpty) // Remove empty items
                      .map(
                        (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• ", style: TextStyle(fontSize: 16.0)),
                          Expanded(
                            child: Text(
                              item,
                              style: const TextStyle(fontSize: 16.0, height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTableSection(String title, List<List<String>> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        SizedBox(height: 10),
        Table(
          border: TableBorder.all(color: Colors.blue, width: 1.5),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
          },
          children: [
            _buildTableRow(["TYPE", "FEES"], isHeader: true),
            ...data.map((row) => _buildTableRow(row)).toList(),
          ],
        ),
      ],
    );
  }

  TableRow _buildTableRow(List<String> row, {bool isHeader = false}) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? Colors.blue : Colors.white,
      ),
      children: row.map((cell) {
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            cell,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: isHeader ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }
}
