import 'package:flutter/material.dart';
import 'package:holdidaymakers/learn.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/travelerHotels.dart';
import 'package:holdidaymakers/pages/learn.dart';
import 'package:holdidaymakers/pages/homePage.dart';
import 'package:holdidaymakers/pages/FullyIndependentTraveler/independentTravelerPage.dart';
import 'package:holdidaymakers/pages/mainPage.dart';
import 'package:holdidaymakers/pages/onboardPage.dart';
import 'package:holdidaymakers/pages/searchBarpage.dart';
import 'package:holdidaymakers/widgets/travelDate.dart';
import 'package:holdidaymakers/widgets/travelerDrawer.dart';
// import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final SharedPreferences prefs = await SharedPreferences.getInstance();
  // final onBoardScreen = prefs.getBool('onBoardScreen') ?? false;
  // await prefs.setBool('onBoardScreen', true);
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
        home: Travelerhotels(), // Use `const` for better performance.
        );
  }
}