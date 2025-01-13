import 'package:flutter/material.dart';
import 'package:holdidaymakers/pages/login&signup/loginPage.dart';
import 'package:holdidaymakers/splashScreen.dart';

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
        home: LoginPage(), // Use `const` for better performance.
        );
  }
}