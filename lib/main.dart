import 'dart:async';
import 'package:HolidayMakers/pages/homePages/mainPage.dart';
import 'package:HolidayMakers/pages/homePages/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_links/app_links.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _linkSubscription = AppLinks().uriLinkStream.listen((uri) {
      print('onAppLink: $uri');
      if (uri.host == 'payment') {
        String? status = uri.queryParameters['status'];
        if (status != null) {
          _navigatorKey.currentState?.pushNamed('/payment', arguments: status);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Holiday Makers',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 6, 3, 3)),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        useMaterial3: true,
      ),
      home: Splashscreen(),
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/payment') {
          final status = settings.arguments as String?;
          return MaterialPageRoute(builder: (context) => Mainpage())  ;
        }
        return null; // Return null to use default routing behavior
      },
    );
  }
}
