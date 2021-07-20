import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:path_provider/path_provider.dart';
import 'package:surveypptik/constants/const.dart';
import 'package:surveypptik/constants/route_name.dart';
import 'package:surveypptik/locator.dart';
import 'package:surveypptik/models/send_absen.dart';
import 'package:surveypptik/services/alert_service.dart';
import 'package:surveypptik/services/api_service.dart';
import 'package:surveypptik/services/ftp_service.dart';
import 'package:surveypptik/services/geolocator_service.dart';
import 'package:surveypptik/services/guid_service.dart';
import 'package:surveypptik/services/location_service.dart';
import 'package:surveypptik/services/navigation_service.dart';
import 'package:surveypptik/services/rmq_service.dart';
import 'package:surveypptik/services/storage_service.dart';
import 'package:surveypptik/viewmodels/base_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as paths;

class AbsenViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final GeolocatorService _geolocatorService = locator<GeolocatorService>();
  final ApiService _apiService = locator<ApiService>();
  final StorageService _storageService = locator<StorageService>();
  final AlertService _alertService = locator<AlertService>();
  final FtpService _ftpService = locator<FtpService>();
  final RMQService _rmqService = locator<RMQService>();
  final LocationService _locationService = locator<LocationService>();
  final GuidService _guidService = locator<GuidService>();

  String imagePath = '';
  String imageName = '';
  double lat = 0.0;
  double lng = 0.0;
  String address = '';
  String pathLocation = 'data/kehadiran/image/';

  String kindOfReport = '#LaporanSurvey';
  TextEditingController commentController = TextEditingController();
  String carrierName = '';
  static const platform = const MethodChannel('jurnalamari.pptik.id/battery');
  String battery = 'Unknown battery level.';
  List<SimCard> simCard = <SimCard>[];
  String mobileNumber = '';

  String phoneNumber = '';
  Future<void> getNumberPhone() async {
    try {
      final String result = await platform.invokeMethod('getNumber');
      phoneNumber = result;
      print("your phone $phoneNumber");
    } catch (e) {
      phoneNumber = 'error available';
    }
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

  void init_state() async {
    print("awal mulai");
    setBusy(true);
    openLocationSetting();
    initMobileNumberState();
    getBatteryLevel();
    getNumberPhone();
    writeAttendance("some text");
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

      simCard.map((e) => carrierName = e.carrierName);
      print(simCard.map((e) => e.number));
      print("ini sim card ${simCard[0].carrierName}");
      carrierName = simCard[0].carrierName;
      mobileNumber = simCard[0].number;
      print("ini carrier card ${carrierName}");
      print("ini number card ${mobileNumber}");
    } on PlatformException catch (e) {
      debugPrint("Failed to get mobile number because of '${e.message}'");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
  }

  Future<void> cameraView() async {
    try {
      final path = await _navigationService.navigateTo(CameraViewRoute);
      var words = path.split('#');
      imagePath = words[0];
      imageName = words[1];
      await getLocation();
      print(imagePath);
    } on NoSuchMethodError catch (ne) {
      throw StateError(
          'On Back Pressed after no capture photo: ' + ne.toString());
    } on NullThrownError catch (nue) {
      throw StateError('NullThrownError: ' + nue.toString());
    } on Exception catch (e) {
      throw StateError('Other Error: ' + e.toString());
    }
  }

  void openLocationSetting() async {
    // final AndroidIntent intent = new AndroidIntent(
    //   action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    // );
    // await intent.launch();
    initMobileNumberState();
    getBatteryLevel();
    getNumberPhone();
    cek_data();

    await _locationService.checkService();
  }

  Future<String> cek_data() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return "connected";
      }
    } on SocketException catch (_) {
      print('not connected');
      return "disconnected";
    }
  }

  void renameFile(String path) async {
    File file = new File(path);
    String rename = path.replaceAll("X", "O");
    print("before rename $path");
    print("rename $rename");
    String newPath = paths.join(path, rename);
    // file.renameSync(newPath);
    print("name file renamed $newPath");
    try {
      File f = await File(file.path).copy(newPath);
    } catch (e) {}
  }

  void reSendMessages(BuildContext context) async {
    setBusy(true);
    print("Kirim Ulang");
    String directory;
    List file = new List();
    directory = (await getExternalStorageDirectory()).path;
    String path = '$directory/report/';
    file = Directory('$path').listSync();
    for (int i = 0; i < file.length; i++) {
      File newfile = new File(file[i].toString());
      print(newfile.path.split("/").last.replaceAll("'", ""));
      File datasurevey =
          new File('$path' + newfile.path.split("/").last.replaceAll("'", ""));
      String pathname = newfile.path
          .split("/")
          .last
          .replaceAll("'", "")
          .toString()
          .split("-")[0];
      if (pathname == 'X') {
        print("path name data ${newfile.path}");
        final text = json.decode(datasurevey.readAsStringSync());
        print("datanya");
        print(text);
        var absentData = SendAbsen(
            address: text['ADDRESS'],
            cmdType: text['CMD_TYPE'],
            company: text['COMPANY'],
            description: text['DESCRIPTION'],
            guid: text['GUID'],
            image: text['IMAGE'],
            lat: text['LAT'],
            long: text['LONG'],
            localImage: text['LOCAL_IMAGE'],
            msgType: text['MSG_TYPE'],
            name: text['NAME'],
            status: text['STATUS'],
            timestamp: text['TIMESTAMP'],
            unit: text['UNIT'],
            signalCarrier: text['SIGNAL_CARRIER'],
            signalStrength: text['SIGNAL_STRENGTH'],
            signalType: text['SIGNAL_TYPE'],
            reportType: text['REPORT_TYPE']);
        bool isSuccess = await _ftpService.uploadFile(
            File(text['LOCAL_IMAGE']), text['GUID'], text['TIMESTAMP']);
        // print(text['LOCAL_IMAGE']), text['GUID'], text['TIMESTAMP']);
        if (isSuccess) {
          print("Kirim ulang ke Rmq");
          final sendAbsen = sendAbsenToJson(absentData);
          print(sendAbsen);
          print(newfile.path);
          renameFile(newfile.path);
          print(sendAbsen);
          print(absentData);
          _rmqService.publish(sendAbsen);
          _alertService.showSuccess(
            context,
            'Success',
            '',
            () {
              _navigationService.replaceTo(HomeViewRoute);
            },
          );
        } else {
          setBusy(false);
          print("data nya tidak masuk");
        }
      }
    }
  }

  void sendMessages(BuildContext context) async {
    print("Tombol di tekan");
    setBusy(true);
    // reSendMessages();
    final date = DateTime.now().millisecondsSinceEpoch.toString();
    final timestamp = date.substring(0, 10);
    final name = await _storageService.getString(K_NAME);
    final company = await _storageService.getString(K_COMPANY);
    final unit = await _storageService.getString(K_UNIT);
    final guid = await _storageService.getString(K_GUID);
    String network = '';
    var absenData = SendAbsen(
        address: '$address',
        cmdType: 0,
        company: '$company',
        description: '${kindOfReport}#${commentController.text}',
        guid: '$guid',
        image: '$pathLocation$guid$timestamp-PPTIK.jpg',
        lat: '$lat',
        long: '$lng',
        localImage: '$imagePath',
        msgType: 1,
        name: '$name',
        status: 'REPORT',
        timestamp: '$timestamp',
        unit: '$unit',
        signalCarrier: carrierName,
        signalStrength: int.parse(battery),
        signalType: phoneNumber,
        reportType: CODE_FOTO);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        network = 'connected';
      }
    } on SocketException catch (_) {
      print('not connected');
      network = 'disconnect';
    }

    if (network == 'connected') {
      bool isSuccess =
          await _ftpService.uploadFile(File(imagePath), guid, timestamp);
      if (isSuccess) {
        final sendAbsen = sendAbsenToJson(absenData);
        print("tes");
        print(sendAbsen);
        print(absenData);
        _rmqService.publish(sendAbsen);
        // storeFile("O", sendAbsen);
        _alertService.showSuccess(
          context,
          'Success',
          '',
          () {
            _navigationService.replaceTo(DashboardRoute);
          },
        );
      } else {
        //
        _alertService.showWarning(
          context,
          'Warning',
          'Gagal Ftp,Connection to server problem, data temporarily will be saved om the device',
          () {
            _navigationService.replaceTo(DashboardRoute);
          },
        );
        print("absen");
        print(absenData.toJson());
        storeFile("X", sendAbsenToJson(absenData));
      }
    } else {
      _alertService.showWarning(
        context,
        'Warning',
        'Connection to server problem, data temporarily will be saved om the device',
        () {
          _navigationService.replaceTo(DashboardRoute);
        },
      );
      print("absen");
      print(absenData.toJson());
      storeFile("X", sendAbsenToJson(absenData));
    }
    setBusy(false);
  }

  void absent(BuildContext context) async {
    setBusy(true);
    final company = await _storageService.getString(K_COMPANY);
    final guid = await _storageService.getString(K_GUID);
    final name = await _storageService.getString(K_NAME);
    final desc = commentController.text;
    final status = "Hadir";
    final position = await _storageService.getString(K_POSITION);
    final unit = await _storageService.getString(K_UNIT);
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final data = await _apiService.report(
        pathLocation + guid + '-' + imagePath,
        company,
        guid,
        name,
        '$lng',
        '$lat',
        address,
        status,
        position,
        unit,
        timestamp,
        desc,
        File(imagePath));

    if (data != null) {
      _alertService.showSuccess(
        context,
        'Succes',
        '',
        () {
          _navigationService.pop();
        },
      );
    } else {
      _alertService.showWarning(context, 'Warning',
          'Connection to server problem', _navigationService.pop);
    }
    setBusy(false);
  }

  bool isPathNull() {
    if (imagePath == null || imagePath.isEmpty) {
      return false;
    }
    return true;
  }

  void getValueRadio(int value) {
    switch (value) {
      case 1:
        kindOfReport = '#LaporanSurvey';
        break;
      case 2:
        kindOfReport = '#SayaSakit';
        break;
      case 3:
        kindOfReport = '#SayaButuhPertolongan';
        break;
      default:
        {
          kindOfReport = 'Tidak Ada Laporan Khusus';
        }
        break;
    }
  }

  Future<void> getLocation() async {
    setBusy(true);
    try {
      final userLocation = await _geolocatorService.getCurrentLocation();
      lat = userLocation.latitude;
      lng = userLocation.longitude;
      address = userLocation.addressLine;
      setBusy(false);
    } catch (e) {
      setBusy(false);

      cameraView();
    }
  }

  Future<String> get localPath async {
    final dir = await getExternalStorageDirectory();
    return dir.path;
  }

  Future<void> writeAttendance(String text) async {
    final file = await localFile;
    print(file.toString());
    await file.writeAsString(text);
  }

  Future<File> checkDirectorty(String guid, String state) async {
    final path = await localPath;
    final Directory folder = Directory('$path/report');
    if (await folder.exists()) {
      return File('${path}/report/$state-$guid.txt');
    } else {
      final Directory dir = await folder.create(recursive: true);
      if (await dir.exists()) {
        return File('${path}/report/$state-$guid.txt');
      } else {
        checkDirectorty(guid, state);
      }
    }
  }

  Future<void> storeFile(String status, String payload) async {
    String guid = _guidService.generateGuid();
    final file = await checkDirectorty("$guid", "$status");
    await file.writeAsString("$payload");
  }

  Future<File> get localFile async {
    String guid = await _storageService.getString(K_GUID);
    final path = await localPath;
    return File('$path/$guid.txt');
  }

  Future<String> readData() async {
    try {
      final file = await localFile;
      String body = await file.readAsString();
      print(body);
      return body;
    } catch (e) {
      return e.toString();
    }
  }
}
