import 'dart:io';

import 'package:flutter/material.dart';
import 'package:surveypptik/constants/const.dart';
import 'package:surveypptik/constants/helper.dart';
import 'package:surveypptik/constants/route_name.dart';
import 'package:surveypptik/locator.dart';
import 'package:surveypptik/services/alert_service.dart';
import 'package:surveypptik/services/api_service.dart';
import 'package:surveypptik/services/guid_service.dart';
import 'package:surveypptik/services/navigation_service.dart';
import 'package:surveypptik/services/storage_service.dart';
import 'package:surveypptik/viewmodels/base_model.dart';

class SignUpViewModel extends BaseModel {
  final ApiService _apiService = locator<ApiService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AlertService _alertService = locator<AlertService>();
  final GuidService _guidService = locator<GuidService>();
  final StorageService _storageService = locator<StorageService>();

  List<String> units = List();
  String unitSelected;
  String company;
  String imagePath;

  TextEditingController nameController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController idCardController = TextEditingController();
  bool eula = false;
  void showEula(BuildContext context) {
    _alertService.showSuccess(
        context,
        "AMARI COVID19 End-User License Agreement \n (\"Agreement\")",
        Helper.eula_content,
        _navigationService.pop);
  }

  void onChangeEula(bool value) {
    eula = value;
  }

  void register(BuildContext context) async {
    setBusy(true);
    print('ini adalah image path $imagePath');
    try {
      if (nameController.text.length > 0 &&
          emailController.text.length > 0 &&
          passwordController.text.length > 0 &&
          idCardController.text.length > 0 &&
          phoneNumberController.text.length > 0 &&
          imagePath.length != null) {
        final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        final name = nameController.text;
        final email = emailController.text;
        final position = positionController.text;
        final password = passwordController.text;
        final phoneNumber = phoneNumberController.text;
        final guid = _guidService.generateGuid();
        final idCard = idCardController.text;
        final data = await _apiService.register(
            name,
            email,
            password,
            "Survey",
            idCard,
            company,
            imagePath,
            unitSelected,
            phoneNumber,
            File(imagePath));
        if ((data != null) && (data.code == 200)) {
          // login success
          // save data

          // navigate to home
          _navigationService.replaceTo(LoginViewRoute);
        } else if ((data != null) && (data.status == false)) {
          setBusy(false);
          // Other Error
          _alertService.showError(context, 'Error ${data.code}', data.message,
              _navigationService.pop);
        } else {
          setBusy(false);
          // Other Error
          _alertService.showError(context, 'Error ${data.code}',
              'Something went wrong ${data.message}', _navigationService.pop);
        }
      } else {
        setBusy(false);

        _alertService.showWarning(context, 'Warning',
            'Please fill in all fields', _navigationService.pop);
      }
    } catch (e) {
      setBusy(false);
      _alertService.showWarning(
          context, 'Warning', 'Please check again', _navigationService.pop);
    }
    setBusy(false);
  }

  bool isPathNull() {
    if (imagePath == null || imagePath.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> cameraView() async {
    final path = await _navigationService.navigateTo(CameraViewRoute);
    imagePath = path.toString().split('#')[0];
  }

  void onUnitChanged(String value) {
    unitSelected = value;
    setBusy(false);
  }

  bool changeVisibility() {
    if (units == null || units.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void getCompanyUnit(String code) async {
    setBusy(false);
    unitSelected = null;
    units.clear();

    final unit = await _apiService.getCompanyUnit(code);
    if (unit != null) {
      unit.data.forEach(
        (value) {
          units.add(value);
        },
      );
    }

    setBusy(false);
    print('units => $units');
    print('visi => ${changeVisibility()}');
  }
}
