import 'package:HolidayMakers/Controller/ConnectivityService.dart';
import 'package:HolidayMakers/pages/homePages/no_internet_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;
  const ConnectivityWrapper({Key? key, required this.child}) : super(key: key);

  @override
  _ConnectivityWrapperState createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  @override
  Widget build(BuildContext context) {
    print("🔄 UI rebuilding in ConnectivityWrapper...");  // Debugging UI rebuilds

    return Consumer<ConnectivityService>(
      builder: (context, connectivity, _) {
        print("📶 Current connection status: ${connectivity.isOnline}");
        
        // ✅ Force the widget tree to rebuild by using setState()
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 500), // Smooth transition
          child: connectivity.isOnline ? widget.child : NoInternetPage(),
        );
      },
    );
  }
}
