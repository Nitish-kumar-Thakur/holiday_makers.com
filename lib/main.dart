import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/Cruise/booking_summary.dart';
import 'package:holdidaymakers/pages/FixedDeparturesPages/departureDeals.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/flightPage.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/homePage.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/independentTravelerPage.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/mainPage.dart';
import 'package:holdidaymakers/splashscreen.dart';
import 'package:holdidaymakers/web_admin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Holiday Makers',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 6, 3, 3)),
          useMaterial3: true,
        ),
        home:  Mainpage(), // Use `const` for better performance.
        );
  }
}