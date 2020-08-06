import 'package:surveypptik/constants/const.dart';
import 'package:surveypptik/constants/route_name.dart';
import 'package:surveypptik/locator.dart';
import 'package:surveypptik/services/alert_service.dart';
import 'package:surveypptik/services/api_service.dart';
import 'package:surveypptik/services/navigation_service.dart';
import 'package:surveypptik/services/storage_service.dart';
import 'package:surveypptik/viewmodels/base_model.dart';
import 'package:flutter/cupertino.dart';

class EditPasswordViewModel extends BaseModel {
  final ApiService _apiService = locator<ApiService>();
  final StorageService _storageService = locator<StorageService>();
  final AlertService _alertService = locator<AlertService>();
  final NavigationService _navigationService = locator<NavigationService>();

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmationPasswordController =
      TextEditingController();

  void onUpdtePassword(BuildContext context) async {
    setBusy(true);
    if (currentPasswordController == null ||
        currentPasswordController.text.isEmpty &&
            newPasswordController == null ||
        newPasswordController.text.isEmpty &&
            confirmationPasswordController == null ||
        confirmationPasswordController.text.isEmpty) {
      _alertService.showWarning(
        context,
        'Warning',
        'Please fill in all fields',
        () {
          _navigationService.pop();
        },
      );
    } else {
      final email = await _storageService.getString(K_EMAIL);
      print(email);
      print(currentPasswordController.text);
      print(newPasswordController.text);
      print(confirmationPasswordController.text.toString());
      final data = await _apiService.changePassword(
          email,
          currentPasswordController.text.toString(),
          newPasswordController.text.toString(),
          confirmationPasswordController.text.toString());

      if (data.code == 200) {
        _alertService.showSuccess(
          context,
          'Success',
          'Change Password Successfully',
          () {
            _navigationService.replaceTo(ProfileViewRoute);
          },
        );
      } else {
        _alertService.showError(
          context,
          'Error',
          'Something went wrong ' + data.message + ' dan ${data.code}',
          () {
            _navigationService.pop();
          },
        );
      }
    }
    setBusy(false);
  }
}
