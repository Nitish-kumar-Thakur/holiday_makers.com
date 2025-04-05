import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:HolidayMakers/Controller/ConnectivityService.dart';

class GlobalRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _updateLastPage(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _updateLastPage(newRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

void _updateLastPage(Route<dynamic>? route) {
  if (route is PageRoute) {
    final navigator = route.navigator;
    if (navigator != null) {
      final context = navigator.context;
      final routeName = route.settings.name ?? '/';

      print("🔖 RouteObserver: Last page set to $routeName");

      Provider.of<ConnectivityService>(context, listen: false)
          .setLastPage(routeName);
    } else {
      print("⚠️ RouteObserver: navigator is null, cannot update last page.");
    }
  }
}


}
