import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:mobile_number/sim_card.dart';
import 'package:path_provider/path_provider.dart';
import 'package:surveypptik/constants/const.dart';
import 'package:surveypptik/constants/route_name.dart';
import 'package:surveypptik/locator.dart';
import 'package:surveypptik/models/absen_data.dart';
import 'package:surveypptik/models/report_data.dart';
import 'package:surveypptik/services/alert_service.dart';
import 'package:surveypptik/services/api_service.dart';
import 'package:surveypptik/services/geolocator_service.dart';
import 'package:surveypptik/services/navigation_service.dart';
import 'package:surveypptik/services/storage_service.dart';
import 'package:surveypptik/services/rmq_service.dart';
import 'package:surveypptik/services/permission_service.dart';
import 'package:surveypptik/viewmodels/base_model.dart';
import 'package:surveypptik/models/send_absen.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeViewModel extends BaseModel {
  final ApiService _apiService = locator<ApiService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final StorageService _storageService = locator<StorageService>();
  final AlertService _alertService = locator<AlertService>();
  final RMQService _rmqService = locator<RMQService>();
  final GeolocatorService _geolocatorService = locator<GeolocatorService>();
  final PermissionsService _permissionsService = locator<PermissionsService>();

  bool isLoading = false;
  int totalPages = 0;
  int pages = 1;

  ReportData data;
  List<AbsenData> absenData = List();

  String imagePath = '';
  String imageName = '';
  double lat = 0.0;
  double lng = 0.0;
  String address = '';

  String pathLocation = 'data/kehadiran/image/';
  String carrierName = '';
  static const platform = const MethodChannel('jurnalamari.pptik.id/battery');
  String battery = 'Unknown battery level.';
  List<SimCard> simCard = <SimCard>[];
  String mobileNumber = '';

  String directory;
  List file = new List();
  Future<void> getReportInternal() async {
    directory = (await getExternalStorageDirectory()).path;
    String path = '$directory/report/';
    file = Directory('$path').listSync();
    for (int i = 0; i < file.length; i++) {
      File newfile = new File(file[i].toString());
      print(newfile.path.split("/").last.replaceAll("'", ""));
      File datasurevey =
          new File('$path' + newfile.path.split("/").last.replaceAll("'", ""));
      final text = json.decode(datasurevey.readAsStringSync());
      print(text["DESCRIPTION"]);
      absenData.add(AbsenData(
          address: text["ADDRESS"],
          description: text["DESCRIPTION"],
          id: text["GUID"],
          image: text["IMAGE"],
          name: text["NAME"],
          timestamp: int.parse(text["TIMESTAMP"]),
          localImage: text["LOCAL_IMAGE"]));

      // List<String> data_named = file[i].toString().split("/");
      // print(data_named[i]);
    }
    print(file.length);
    print(directory);
  }

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

  void onModelReady() {
    print('init the home');
    checkStatusPermission(Permission.phone);
    checkStatusPermission(Permission.camera);
    checkStatusPermission(Permission.microphone);
    checkStatusPermission(Permission.location);
    // getBatteryLevel();
    // initMobileNumberState();
    // getAllReport(pages);
    getReportInternal();
    getLocation();
  }

  bool returndata(bool value) {
    return value;
  }

  void checkInternalStorage(String path) async {
    if (await File(path).exists()) {
      returndata(true);
    } else {
      returndata(false);
    }
  }

  void checkStatusPermission(Permission permission) async {
    PermissionStatus status = null;
    var _check = _permissionsService.checkStatus(permission);
    _check.then((value) => status = value);

    if (!status.isGranted) {
      _permissionsService.requestPermission(Permission.phone);
    }
  }

  void goAnotherView(String routeName) async {
    final data = await _navigationService.navigateTo(routeName);
    if (data == null) {
      getAllReport(1);
    }
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

  // get all reports
  void getAllReport(int page) async {
    data = null;
    absenData.clear();
    final company = await _storageService.getString(K_COMPANY);
    final guid = await _storageService.getString(K_GUID);
    final report = await getExternalStorageDirectory();
    print('${report.path}/report');
    data = await _apiService.getReport(company, guid, page);
    // totalPages = data.numberOfPages;
    data.data.forEach(
      (val) {
        print("image date ${val.timestamp}");
        print("image date ${val.description}");
        absenData.add(AbsenData(
            address: val.address,
            description: val.description,
            id: val.id,
            image: val.image,
            name: val.name,
            timestamp: val.timestamp,
            localImage: val.localImage));
      },
    );

    setBusy(false);
  }

  void loadMoreData(int page) async {
    isLoading = true;

    if (page <= totalPages) {
      print('load more with page $page');
      final company = await _storageService.getString(K_COMPANY);
      final guid = await _storageService.getString(K_GUID);
      data = await _apiService.getReport(company, guid, page);
      data.data.forEach(
        (val) {
          print('image => ${val.image}');
          absenData.add(AbsenData(
              address: val.address,
              id: val.id,
              image: val.image,
              name: val.name,
              timestamp: val.timestamp,
              localImage: val.localImage));
        },
      );

      isLoading = false;
      setBusy(false);
    } else {
      page = totalPages;
      isLoading = false;
    }
  }

  // Kirim Kondisi Saya Sehat, Saya Sakit, Saya Perlu Pertolongan
  void sendCondition(BuildContext context, String condition) async {
    getLocation();
    final date = DateTime.now().millisecondsSinceEpoch.toString();
    final timestamp = date.substring(0, 10);
    final name = await _storageService.getString(K_NAME);
    final company = await _storageService.getString(K_COMPANY);
    final unit = await _storageService.getString(K_UNIT);
    final guid = await _storageService.getString(K_GUID);

    switch (condition) {
      case "sehat":
        {
          //kirim ke RMQ
          var message = SendAbsen(
              address: '$address',
              cmdType: 0,
              company: '$company',
              description: '#SayaSehat',
              guid: '$guid',
              image: 'data/kehadiran/sayasehatemoticon.png',
              lat: '$lat',
              long: '$lng',
              localImage: 'sayasehatemoticon.png ',
              msgType: 1,
              name: '$name',
              status: 'REPORT',
              timestamp: '$timestamp',
              signalCarrier: carrierName,
              signalStrength: int.parse(battery),
              signalType: "Null",
              unit: '$unit',
              reportType: CODE_KESEHATAN);

          final data = sendAbsenToJson(message);
          _rmqService.publish(data);

          //kasih popup sukses
          _alertService.showSuccess(
            context,
            'Pesan Terkirim',
            'Saya Sehat',
            () {
              _navigationService.replaceTo(HomeViewRoute);
            },
          );
        }
        break;
      case "sakit":
        {
          //kirim ke RMQ
          //kirim ke RMQ
          var message = SendAbsen(
              address: '$address',
              cmdType: 0,
              company: '$company',
              description: '#SayaSakit',
              guid: '$guid',
              image: 'data/kehadiran/sayasakitemoticon.png',
              lat: '$lat',
              long: '$lng',
              localImage: 'sayasakitemoticon.png',
              msgType: 1,
              name: '$name',
              status: 'REPORT',
              timestamp: '$timestamp',
              unit: '$unit',
              signalCarrier: carrierName,
              signalStrength: int.parse(battery),
              signalType: "Null",
              reportType: CODE_KESEHATAN);

          final data = sendAbsenToJson(message);
          _rmqService.publish(data);

          //kasih popup sakit
          _alertService.showSuccess(
            context,
            'Pesan Terkirim',
            'Saya sakit',
            () {
              _navigationService.replaceTo(HomeViewRoute);
            },
          );
        }
        break;
      case "tolong":
        {
          //kirim ke RMQ
          //kirim ke RMQ
          var message = SendAbsen(
              address: '$address',
              cmdType: 0,
              company: '$company',
              description: '#SayaButuhPertolongan',
              guid: '$guid',
              image: 'data/kehadiran/needahugemoticon.png',
              lat: '$lat',
              long: '$lng',
              localImage: 'needahugemoticon.png',
              msgType: 1,
              name: '$name',
              status: 'REPORT',
              timestamp: '$timestamp',
              unit: '$unit',
              signalCarrier: carrierName,
              signalStrength: int.parse(battery),
              signalType: "Null",
              reportType: CODE_KESEHATAN);

          final data = sendAbsenToJson(message);
          print(data);
          _rmqService.publish(data);

          //kasih popup tolong
          _alertService.showSuccess(
            context,
            'Pesan Terkirim',
            'Saya Butuh pertolongan',
            () {
              _navigationService.replaceTo(HomeViewRoute);
            },
          );
        }
        break;
      default:
        {}
        break;
    }
  }

  Future<ReportData> sendReportData(pages) async {
    data = null;
    final company = await _storageService.getString(K_COMPANY);
    final guid = await _storageService.getString(K_GUID);
    data = await _apiService.getReport(company, guid, pages);
    setBusy(false);

    return data;
  }

  String formatDate(int date) {
    var tempData =
        new DateTime.fromMillisecondsSinceEpoch(date * 1000, isUtc: false);
    DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss a");
    var returnData = dateFormat.format(tempData);
    return returnData;
  }

  Future<void> getLocation() async {
    try {
      final userLocation = await _geolocatorService.getCurrentLocation();
      lat = userLocation.latitude;
      lng = userLocation.longitude;
      address = userLocation.addressLine;
      setBusy(false);
    } catch (e) {
      setBusy(false);
    }
  }
}
