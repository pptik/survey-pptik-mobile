import 'package:permission_handler/permission_handler.dart';
import 'package:surveypptik/constants/const.dart';
import 'package:surveypptik/constants/route_name.dart';
import 'package:surveypptik/locator.dart';
import 'package:surveypptik/services/alert_service.dart';
import 'package:surveypptik/services/api_service.dart';
import 'package:surveypptik/services/navigation_service.dart';
import 'package:surveypptik/services/permission_service.dart';
import 'package:surveypptik/services/storage_service.dart';
import 'package:surveypptik/viewmodels/base_model.dart';
import 'package:flutter/cupertino.dart';

class LoginViewModel extends BaseModel {
  final ApiService _apiService = locator<ApiService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final StorageService _storageService = locator<StorageService>();
  final AlertService _alertService = locator<AlertService>();
  final PermissionsService _permissionsService = locator<PermissionsService>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void checkPermission(BuildContext context) async {
    var status = await Permission.storage.status;
    if (status.isUndetermined) {
      Permission.storage.request();
      // We didn't ask for permission yet.
    }

// You can can also directly ask the permission about its status.
    if (await Permission.location.isRestricted) {
      // The OS restricts access, for example because of parental controls.
      Permission.storage.request();
    }
  }

  void loginAccount(BuildContext context) async {
    setBusy(true);
    print(passwordController.text == null);
    if (emailController.text.length > 0 && passwordController.text.length > 0) {
      final data = await _apiService.newLogin(
          emailController.text, passwordController.text);
      // print('ini respon:${data}');
      // print('ini code:${data.code}');
      if (data != null) {
        // login success
        // save data
        await _storageService.setString(K_PHONE_NUMBER, data.data.phoneNumber);
        await _storageService.setString(K_NAME, data.data.name);
        await _storageService.setString(K_EMAIL, data.data.email);
        await _storageService.setString(K_COMPANY, data.data.company);
        await _storageService.setString(K_UNIT, data.data.unit);
        await _storageService.setString(K_POSITION, data.data.position);
        await _storageService.setString(K_LOCAL_IMAGE, data.data.localImage);
        await _storageService.setString(K_GUID, data.data.guid);
        await _storageService.setString(K_IMAGE, data.data.image);
        // navigate to home
        _navigationService.replaceTo(DashboardRoute);
      // }else if (data.code==401){
      //   setBusy(false);
      //   _alertService.showError(context, 'Error ${data.code}',
      //       '${data.message}', _navigationService.pop);
      } else {
        _alertService.showError(context, 'Error',
            'Harap Masukan Email dan Password Yang Benar', _navigationService.pop);
      }
    } else {
      _alertService.showWarning(context, 'Warning', 'Please fill in all fields',
          _navigationService.pop);
    }
    setBusy(false);
  }
}
