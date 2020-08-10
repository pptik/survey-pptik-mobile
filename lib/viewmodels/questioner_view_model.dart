import 'dart:collection';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

import 'package:excel/excel.dart';
import 'package:flutter/widgets.dart';
import 'package:surveypptik/constants/const.dart';
import 'package:surveypptik/constants/route_name.dart';
import 'package:surveypptik/locator.dart';
import 'package:surveypptik/models/send_absen.dart';
import 'package:surveypptik/services/alert_service.dart';
import 'package:surveypptik/services/geolocator_service.dart';
import 'package:surveypptik/services/location_service.dart';
import 'package:surveypptik/services/navigation_service.dart';
import 'package:surveypptik/services/rmq_service.dart';
import 'package:surveypptik/services/storage_service.dart';
import 'package:surveypptik/services/permission_service.dart';
import 'package:surveypptik/viewmodels/base_model.dart';
import 'package:flutter/services.dart'
    show ByteData, MethodChannel, PlatformException, rootBundle;
import 'dart:io';
import 'dart:async';

import 'package:mobile_number/mobile_number.dart';

class QuestionerViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final GeolocatorService _geolocatorService = locator<GeolocatorService>();
  final RMQService _rmqService = locator<RMQService>();
  final LocationService _locationService = locator<LocationService>();
  final StorageService _storageService = locator<StorageService>();
  final AlertService _alertService = locator<AlertService>();
  final PermissionsService _permissionsService = locator<PermissionsService>();

  TextEditingController keteranganController = TextEditingController();

  bool q_1 = true;
  bool q_1a = true;
  bool q_2 = true;
  bool q_3 = true;

  String q_1s = '';
  String q_1as = '';
  String q_2s = '';
  String q_3s = '';
  double lat;
  double lng;
  String address = '';
  String description = '';
  String selectedProvince;
  String selectedCity;

  List<String> value_province = [];
  List<String> value_city = [];

  List<Data> province_data = [];
  List<DataCiy> city_data = [];
  var province = new LinkedHashMap();
  var cities = new LinkedHashMap();
  List<SimCard> simCard = <SimCard>[];
  String mobileNumber = '';
  String carrierName = '';
  static const platform = const MethodChannel('jurnalamari.pptik.id/battery');

  String battery = 'Unknown battery level.';

  Future<void> getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = '$result';
    } on PlatformException catch (e) {
      batteryLevel = "-1";
    }

    battery = batteryLevel;
    print(battery);
  }

  Future<void> initMobileNumberState() async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
      return;
    }
    String mobileNumbers = '';
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      mobileNumbers = await MobileNumber.mobileNumber;
      simCard = await MobileNumber.getSimCards;
      mobileNumber = mobileNumbers;
      simCard.map((e) => carrierName = e.carrierName);
      print(simCard.map((e) => e.carrierName));
      print("ini sim card ${simCard[0].carrierName}");
      carrierName = simCard[0].carrierName;
      print("ini carrier card ${carrierName}");
    } on PlatformException catch (e) {
      debugPrint("Failed to get mobile number because of '${e.message}'");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
  }

  void init_state() async {
    setBusy(true);
    initMobileNumberState();
    getBatteryLevel();
    MobileNumber.listenPhonePermission((isPermissionGranted) {
      if (isPermissionGranted) {
        initMobileNumberState();
      } else {
        _permissionsService.requestPermission(Permission.phone);
        _permissionsService.requestPermission(Permission.microphone);
      }
    });

    try {
      final userLocation = await _geolocatorService.getCurrentLocation();
      lat = userLocation.latitude;
      lng = userLocation.longitude;
      address = userLocation.addressLine;

      print(address);
      get_prov();
      setBusy(false);
    } catch (e) {
      setBusy(false);
    }
  }

  void get_prov() async {
    province.clear();
    value_province.clear();
    try {
      ByteData data = await rootBundle.load("assets/level1.xlsx");
      var bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      var excel = Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys) {
        print(table); //sheet Name
        print(excel.tables[table].maxCols);
        print(excel.tables[table].maxRows);
        for (var row in excel.tables[table].rows) {
          print("${row[2]}");
          print(province);
          province_data.add(Data(row[6], row[2]));
        }
      }
    } catch (e) {
      print("[x] Error Get Prov " + e);
    }
  }

  void onProvinceChanged(String value) {
    selectedProvince = value;
    setBusy(false);
    var id = province_data.singleWhere((element) => element.nama == value);
    print(id.kode);
    get_city(id.toString());
  }

  void get_city(String id) async {
    city_data.clear();
    try {
      ByteData data = await rootBundle.load("assets/level2.xlsx");
      var bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      var excel = Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys) {
        print(table); //sheet Name
        print(excel.tables[table].maxCols);
        print(excel.tables[table].maxRows);
        for (var row in excel.tables[table].rows) {
          print("${row[2]}");
          print(province);
          province_data.add(Data(row[6], row[2]));
        }
      }
    } catch (e) {
      print("[x] Error Get Prov " + e);
    }
  }

  void group_1(bool question) async {
    q_1 = question;
    print(q_1);
  }

  void group_1a(bool question) async {
    q_1a = question;
    print(q_1);
  }

  void group_2(bool question) async {
    q_2 = question;
  }

  void group_3(bool question) async {
    q_3 = question;
  }

  void get_province() async {
    // File data = File.fromUri()
  }

  void send_message(BuildContext context) async {
    if (!q_1) {
      q_1s = 'No';
      q_1a = null;
      q_1as = 'No';
    } else {
      q_1s = 'Yes';
      if (q_1a) {
        q_1as = 'Yes';
      } else {
        q_1as = 'No';
      }
    }

    if (!q_2) {
      q_2s = 'No';
    } else {
      q_2s = 'Yes';
    }

    if (!q_3) {
      q_3s = 'No';
      keteranganController.clear();
    } else {
      q_3s = 'Yes';
    }

    final date = DateTime.now().millisecondsSinceEpoch.toString();
    final timestamp = date.substring(0, 10);
    final name = await _storageService.getString(K_NAME);
    final company = await _storageService.getString(K_COMPANY);
    final unit = await _storageService.getString(K_UNIT);
    final guid = await _storageService.getString(K_GUID);
    description =
        '#Q#1:$q_1s; 1a:$q_1as; 2:$q_2s; 3:$q_3s;${keteranganController.text}';
    print(description);
    var message = SendAbsen(
        address: '$address',
        cmdType: 0,
        company: '$company',
        description: '$description',
        guid: '$guid',
        image: 'data/kehadiran/survey.png',
        lat: '$lat',
        long: '$lng',
        localImage: 'survey.png',
        msgType: 1,
        name: '$name',
        status: 'REPORT',
        timestamp: '$timestamp',
        unit: '$unit',
        signalCarrier: carrierName,
        signalStrength: int.parse(battery),
        signalType: "Null",
        reportType: CODE_QUIZ);

    final data = sendAbsenToJson(message);
    _rmqService.publish(data);
    print(data);
    showAlert(context);
  }

  void showAlert(BuildContext context) {
    if (!q_1 && !q_2 && q_3) {
      _alertService.showSuccess(
        context,
        'Message',
        Q1,
        () {
          _navigationService.replaceTo(HomeViewRoute);
        },
      );
    } else if (q_1 && !q_2) {
      _alertService.showSuccess(
        context,
        'Message',
        Q2,
        () {
          _navigationService.replaceTo(HomeViewRoute);
        },
      );
    } else if (!q_1 && q_2) {
      _alertService.showSuccess(
        context,
        'Message',
        Q3,
        () {
          _navigationService.replaceTo(HomeViewRoute);
        },
      );
    } else if (q_1 && q_2) {
      _alertService.showSuccess(
        context,
        'Message',
        Q2,
        () {
          _navigationService.replaceTo(HomeViewRoute);
        },
      );
    } else {
      _alertService.showSuccess(
        context,
        'Message',
        Q4,
        () {
          _navigationService.replaceTo(HomeViewRoute);
        },
      );
    }
  }
}

class Data {
  final int kode;
  final String nama;

  const Data(this.kode, this.nama);
}

class DataCiy {
  final int kode;
  final String nama;

  const DataCiy(this.kode, this.nama);
}
