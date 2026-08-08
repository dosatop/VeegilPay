import 'package:flutter/material.dart';
import 'package:veegil_pay/core/utils/app_logger.dart';

class MyNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    AppLogger.logger.i('''
      NAVIGATION PUSH
      Route: ${route.settings.name}
      From: ${previousRoute?.settings.name}
    ''');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    AppLogger.logger.i('''
      NAVIGATION POP
      Route: ${route.settings.name}
      To: ${previousRoute?.settings.name}
    ''');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    AppLogger.logger.i('''
      NAVIGATION REPLACE
      Old Route: ${oldRoute?.settings.name}
      New Route: ${newRoute?.settings.name}
    ''');
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);

    AppLogger.logger.i('''
      NAVIGATION REMOVE
      Route: ${route.settings.name}
    ''');
  }
}
