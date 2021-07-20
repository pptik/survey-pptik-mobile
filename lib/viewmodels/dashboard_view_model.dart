import 'package:flutter/cupertino.dart';
import 'package:surveypptik/constants/const.dart';
import 'package:surveypptik/constants/route_name.dart';
import 'package:surveypptik/services/alert_service.dart';
import 'package:surveypptik/services/navigation_service.dart';
import 'package:surveypptik/services/storage_service.dart';
import 'package:surveypptik/ui/views/login_view.dart';
import 'package:surveypptik/viewmodels/base_model.dart';
import '../locator.dart';

class DashboardView extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AlertService _alertService = locator<AlertService>();
  final StorageService _storageService = locator<StorageService>();
  String name = "";
  String pathImage = "";
  void goAnotherView(String routeName) async {
    await _navigationService.navigateTo(routeName);
  }

  void initData() async {
    setBusy(true);
    name = await _storageService.getString(K_NAME);
    pathImage = await _storageService.getString(K_IMAGE);
    setBusy(false);
  }

  void clearBeforeSignOut() async {
    await _storageService.clearStorage();
    _navigationService.replaceTo(LoginViewRoute);
  }

  void signOut(BuildContext context) {
    setBusy(true);
    _alertService.showSignOut(
        context, 'Sign Out ?', "", clearBeforeSignOut, _navigationService.pop);
    setBusy(false);
    print('User Sign Out !');
  }
}
