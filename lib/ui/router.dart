import 'package:surveypptik/constants/route_name.dart';
import 'package:surveypptik/ui/views/absen_view.dart';
import 'package:surveypptik/ui/views/camera_view.dart';
import 'package:surveypptik/ui/views/change_pw_view.dart';
import 'package:surveypptik/ui/views/dashboard_view.dart';
import 'package:surveypptik/ui/views/edit_profile.dart';
import 'package:surveypptik/ui/views/home_view.dart';
import 'package:surveypptik/ui/views/login_view.dart';
import 'package:surveypptik/ui/views/maps_view.dart';
import 'package:surveypptik/ui/views/profile_view.dart';
import 'package:surveypptik/ui/views/reportlocal_view.dart';
import 'package:surveypptik/ui/views/sign_up_view.dart';
import 'package:surveypptik/ui/views/questioner_view.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginViewRoute:
      return _pageRoute(
        routeName: settings.name,
        viewToShow: LoginView(),
      );
    case SignUpViewRoute:
      return _pageRoute(
        routeName: settings.name,
        viewToShow: SignUpView(),
      );
    case HomeViewRoute:
      return _pageRoute(
        routeName: settings.name,
        viewToShow: HomeView(),
      );
    case ProfileViewRoute:
      return _pageRoute(
        routeName: settings.name,
        viewToShow: ProfileView(),
      );
    case AbsenViewRoute:
      return _pageRoute(
        routeName: settings.name,
        viewToShow: AbsenView(),
      );
    case CameraViewRoute:
      return _pageRoute(
        routeName: settings.name,
        viewToShow: CameraView(),
      );
    case EditProfileRoute:
      return _pageRoute(
        routeName: settings.name,
        viewToShow: EditProfileView(),
      );
    case EditChangePwRoute:
      return _pageRoute(
        routeName: settings.name,
        viewToShow: EditPasswordView(),
      );
    case QuestionerViewRoute:
      return _pageRoute(
        routeName: settings.name,
        viewToShow: QuestionerView(),
      );
    case MapViewRoute:
      return _pageRoute(
        routeName: settings.name,
        viewToShow: MapView(),
      );
    case DashboardRoute:
      return _pageRoute(
        routeName: settings.name,
        viewToShow: Dashboard(),
      );
    case LocalReportViewRoute:
      return _pageRoute(
        routeName: settings.name,
        viewToShow: LocalReportView(),
      );

    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text(
              'No route defined for ${settings.name}',
            ),
          ),
        ),
      );
  }
}

PageRoute _pageRoute({String routeName, Widget viewToShow}) {
  return MaterialPageRoute(
    settings: RouteSettings(
      name: routeName,
    ),
    builder: (_) => viewToShow,
  );
}
