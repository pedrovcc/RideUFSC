import 'dart:io';

import 'package:boilerplate_flutter/config/app_routes.dart';
import 'package:boilerplate_flutter/config/theme.dart';
import 'package:boilerplate_flutter/data/repositories/account_repository.dart';
import 'package:boilerplate_flutter/data/repositories/ride_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  await launcher(accountRepository);
  Intl.defaultLocale = 'pt_BR';
  runApp(
    App(),
  );
}

AccountRepository accountRepository = AccountRepository();
RideRepository rideRepository = RideRepository();
String? route;

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness:
            Platform.isIOS ? Brightness.dark : Brightness.light,
      ),
      child: MaterialApp(
        title: 'BoilerPlate',
        debugShowCheckedModeBanner: false,
        theme: appThemeData,
        initialRoute: route,
        onGenerateInitialRoutes: (_) {
          switch (route) {
            case AppRoutes.register:
              return <Route>[
                AppRoutes.routeFactory(
                  RouteSettings(name: AppRoutes.register),
                )
              ];
            case AppRoutes.core:
              return <Route>[
                AppRoutes.routeFactory(
                  RouteSettings(name: AppRoutes.core),
                )
              ];
            default:
              return <Route>[
                AppRoutes.routeFactory(
                  RouteSettings(name: AppRoutes.login),
                )
              ];
          }
        },
        onGenerateRoute: AppRoutes.routeFactory,
        navigatorObservers: [routeObserver],
      ),
    );
  }
}

Future launcher(AccountRepository accountRepository) async {
  final prefs = await SharedPreferences.getInstance();
  final user = prefs.getString('user');

  if (user != null) {
    route = '/core';
  } else {
    route = '/login';
  }
}

extension ObjectExt<T> on T {
  R let<R>(R Function(T that) op) => op(this);
}
