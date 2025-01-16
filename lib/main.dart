import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/homePage.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/mainPage.dart';
import 'package:holdidaymakers/pages/login&signup/signupPage.dart';
import 'package:holdidaymakers/splashScreen.dart';
import 'package:holdidaymakers/widgets/Blogs.dart';
import 'package:holdidaymakers/widgets/MyBookings.dart';
import 'package:holdidaymakers/widgets/ReadMore.dart';

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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        home: Splashscreen(), // Use `const` for better performance.
        );
  }
}