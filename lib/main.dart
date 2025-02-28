import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:holdidaymakers/pages/homePages/splashscreen.dart';

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
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
        ,
          useMaterial3: true,
        ),
        home: Splashscreen(), // Use `const` for better performance.
        );
  }
}