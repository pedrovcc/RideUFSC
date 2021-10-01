import 'package:boilerplate_flutter/data/models/ride/ride.dart';
import 'package:boilerplate_flutter/main.dart';
import 'package:boilerplate_flutter/modules/core/core_screen.dart';
import 'package:boilerplate_flutter/modules/createRide/create_ride.dart';
import 'package:boilerplate_flutter/modules/editProfile/edit_profile_screen.dart';
import 'package:boilerplate_flutter/modules/login/login_screen.dart';
import 'package:boilerplate_flutter/modules/register/register_screen.dart';
import 'package:boilerplate_flutter/modules/rideDetails/ride_details.dart';
import 'package:flutter/material.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class AppRoutes {
  static const String login = '/login';
  static const String appRestart = '/appRestart';
  static const String core = '/core';
  static const String register = '/register';
  static const String editProfile = '/core/editProfile';
  static const String rideDetails = '/core/rides/details';
  static const String createRide = '/core/rides/createRide';

  static Map<String, WidgetBuilder> defaultBuilder = <String, WidgetBuilder>{};

  static Route<dynamic> routeFactory(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.core:
        return MaterialPageRoute(
          builder: (context) {
            return CoreScreen(
              rideRepository: rideRepository,
              routeObserver: routeObserver,
              accountRepository: accountRepository,
            );
          },
        );
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (context) {
            return LoginScreen(
              routeObserver: routeObserver,
              accountRepository: accountRepository,
            );
          },
        );
      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (context) {
            return RegisterScreen(
              routeObserver: routeObserver,
              accountRepository: accountRepository,
            );
          },
        );
      case AppRoutes.editProfile:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return EditProfileScreen(
              accountRepository: accountRepository,
              routeObserver: routeObserver,
            );
          },
        );
      case AppRoutes.createRide:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return CreateRideScreen(
              rideRepository: rideRepository,
              routeObserver: routeObserver,
            );
          },
        );
      case AppRoutes.rideDetails:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return RideDetailsScreen(
              rideRepository: rideRepository,
              routeObserver: routeObserver,
              ride: settings.arguments as Ride,
            );
          },
        );
      case AppRoutes.appRestart:
        return PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => LoginScreen(
            routeObserver: routeObserver,
            accountRepository: accountRepository,
          ),
          transitionDuration: Duration(seconds: 0),
        );

      default:
        return MaterialPageRoute(builder: defaultBuilder[settings.name]!, settings: settings);
    }
  }
}
