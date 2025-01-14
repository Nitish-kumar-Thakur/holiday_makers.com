import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/homePage.dart';
import 'package:holdidaymakers/pages/login&signup/loginPage.dart';
import 'package:holdidaymakers/splashScreen.dart';
import 'package:holdidaymakers/widgets/profile_page.dart';

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
        home: HomePage(), // Use `const` for better performance.
        );
  }
}