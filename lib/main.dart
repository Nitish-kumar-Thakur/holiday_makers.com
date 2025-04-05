// import 'dart:async';
// import 'package:HolidayMakers/pages/homePages/mainPage.dart';
// import 'package:HolidayMakers/pages/homePages/splashscreen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:app_links/app_links.dart';
// import 'package:HolidayMakers/Controller/ConnectivityService.dart';
// import 'package:HolidayMakers/pages/homePages/no_internet_page.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => ConnectivityService()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final _navigatorKey = GlobalKey<NavigatorState>();
//   StreamSubscription<Uri>? _linkSubscription;

//   @override
//   void initState() {
//     super.initState();
//     initDeepLinks();
//   }

//   @override
//   void dispose() {
//     _linkSubscription?.cancel();
//     super.dispose();
//   }

//   Future<void> initDeepLinks() async {
//     _linkSubscription = AppLinks().uriLinkStream.listen((uri) {
//       if (uri.host == 'payment') {
//         String? status = uri.queryParameters['status'];
//         if (status != null) {
//           _navigatorKey.currentState?.pushNamed('/payment', arguments: status);
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       navigatorKey: _navigatorKey,
//       debugShowCheckedModeBanner: false,
//       title: 'Holiday Makers',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF060303)),
//         textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
//         useMaterial3: true,
//       ),
//       home: Consumer<ConnectivityService>(
//         builder: (context, connectivity, child) {
//           print("🏠 Rebuilding home: isOnline = ${connectivity.isOnline}");
//           return connectivity.isOnline ? Splashscreen() : NoInternetPage();
//         },
//       ),
//       onGenerateRoute: (RouteSettings settings) {
//         if (settings.name == '/payment') {
//           return MaterialPageRoute(builder: (context) => Mainpage());
//         }
//         return null;
//       },
//     );
//   }
// }


import 'dart:async';
import 'package:HolidayMakers/widgets/MyBookings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_links/app_links.dart';
import 'package:HolidayMakers/Controller/ConnectivityService.dart';
import 'package:HolidayMakers/Controller/GlobalRouteObserver.dart';
import 'package:HolidayMakers/pages/homePages/no_internet_page.dart';
import 'package:HolidayMakers/pages/homePages/splashscreen.dart';
import 'package:HolidayMakers/pages/homePages/mainPage.dart';

final GlobalRouteObserver routeObserver = GlobalRouteObserver();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectivityService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription<Uri>? _linkSubscription;
  late ConnectivityService connectivityService;

  @override
  void initState() {
    super.initState();
    connectivityService = Provider.of<ConnectivityService>(context, listen: false);
    initDeepLinks();

    // 🌍 Auto-check internet connection periodically
    Timer.periodic(Duration(seconds: 5), (timer) {
      connectivityService.manualCheck();
    });
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _linkSubscription = AppLinks().uriLinkStream.listen((uri) {
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
  return Consumer<ConnectivityService>(
    builder: (context, connectivity, child) {
      if (!connectivity.isOnline) {
        // ✅ Ensure last page is set before navigating to NoInternetPage
        print("⚠️ No internet. Saving last visited page: ${connectivity.lastPage}");
        Get.to(() => NoInternetPage());
      } else if (connectivity.lastPage != null &&
          connectivity.lastPage != "/no_internet") {
        Get.offNamed(connectivity.lastPage!);
      }

      return GetMaterialApp(
        navigatorKey: _navigatorKey,
        navigatorObservers: [routeObserver],
        debugShowCheckedModeBanner: false,
        title: 'Holiday Makers',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF060303)),
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          useMaterial3: true,
        ),
        home: Splashscreen(),
        onGenerateRoute: (RouteSettings settings) {
          if (settings.name == '/payment') {
            return MaterialPageRoute(builder: (context) => Mainpage());
          }
          return null;
        },
      );
    },
  );
}

}

