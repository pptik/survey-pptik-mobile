import 'package:surveypptik/constants/const.dart';
import 'package:surveypptik/locator.dart';
import 'package:surveypptik/services/alert_service.dart';
import 'package:surveypptik/services/api_service.dart';
import 'package:surveypptik/services/navigation_service.dart';
import 'package:surveypptik/services/storage_service.dart';
import 'package:surveypptik/viewmodels/base_model.dart';
import 'package:flutter/cupertino.dart';

class EditProfileViewModel extends BaseModel {
  final ApiService _apiService = locator<ApiService>();
  final StorageService _storageService = locator<StorageService>();
  final AlertService _alertService = locator<AlertService>();
  final NavigationService _navigationService = locator<NavigationService>();

  List<String> units = List();
  String unitSelected;
  String company;

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
  }

  void updateCompanyUnit(BuildContext context) async {
    setBusy(true);
    if (units == null || units.isEmpty && company == null || company.isEmpty) {
      _alertService.showWarning(
        context,
        'Warning',
        'Please fill in all fields',
        () {
          _navigationService.pop();
        },
      );
    } else {
      final guid = await _storageService.getString(K_GUID);
      final data =
          await _apiService.updateCompanyUnit(guid, company, unitSelected);

      if (data != null) {
        await _storageService.setString(K_GUID, guid);
        await _storageService.setString(K_COMPANY, data.data.company);
        await _storageService.setString(K_UNIT, data.data.unit);

        _alertService.showSuccess(
          context,
          'Successfully updated class',
          '',
          () {
            _navigationService.pop();
          },
        );
      } else {
        _alertService.showError(
          context,
          'Error',
          'Something went wrong',
          () {
            _navigationService.pop();
          },
        );
      }
    }
    setBusy(false);
  }
}
