import 'dart:convert';
import 'dart:io';

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
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

class SignUpViewModel extends BaseModel {
  final ApiService _apiService = locator<ApiService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AlertService _alertService = locator<AlertService>();
  final GuidService _guidService = locator<GuidService>();
  final StorageService _storageService = locator<StorageService>();

  List<String> units = List();
  List<String> profesi = List();
  List<String> areasList =  List();
  List<Item> areaForDistrcit = List();
  List<dynamic> districts = List();
  List<String> jurusanList = List();

  String unitSelected ;
  String profesiSelected;
  String areasSelected;
  String districtSelected;
  String jurusanSelected;
  String company;
  String imagePath;

  bool eula = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberCotroller = TextEditingController();
  TextEditingController idCardController = TextEditingController();
  void onReady(){
    profesi.add("Bukan Civitas ITB");
    profesi.add("Mahasiswa");
    profesi.add("Dosen");
    profesi.add("Tenaga Kependidikan");
    profesi.add("Lain Lain (Peneliti dll.)");
    profesi.add("Pengguna UNBK");
    profesi.add("Tamu");

//    loadAsset();
//    getAreas();
  }

  void showEula(BuildContext context){
    _alertService.showSuccess(context, "AMARI COVID19 End-User License Agreement \n (\"Agreement\")", Helper.eula_content, _navigationService.pop);
  }
  void onChangeEula(bool value){
    eula = value;
  }
  Future<String> loadAsset() async {
    final a = await rootBundle.loadString('assets/level1.csv');
    final ab = json.decode(a);
    print(ab[0]);
    print(ab);
  }

  Future<void> getAreas() async{

    try{
      final data = await _apiService.areas();
      if (data.code==200) {
        print("add");
        for(int i= 0 ;i<data.data.areas.length ;i++){
          areasList.add(data.data.areas[i].area);
        }
      } else {
        // User already registered
      }
    }catch(e){

    }
  }
  void register(BuildContext context) async {
    setBusy(true);
    print('ini adalah image path $imagePath');
    try {
      if(eula){
        if (nameController.text.length != null &&
            positionController.text.length != null &&
            emailController.text.length != null &&
            passwordController.text.length != null &&
            phoneNumberCotroller.text.length != null &&
            company.length != null &&
            imagePath.length != null &&
            profesiSelected != null
        ) {
          final name = nameController.text;
          final email = emailController.text;
          final position = positionController.text;
          final password = passwordController.text;
          final phoneNumber = phoneNumberCotroller.text;
          final idCard = idCardController.text;
          final companies = company;
          final data = await _apiService.register(
            name,
            email,
            password,
            profesiSelected,
            idCard,
            companies,
            imagePath,
            profesiSelected,
            phoneNumber,
            File(imagePath),
          );

          if (data.code==200) {
            setBusy(false);

            // navigate to home
            _navigationService.replaceTo(LoginViewRoute);
          } else {
            setBusy(false);

            // User already registered
            _alertService.showError(
                context, 'Error', 'Something went wrong '+data.message, _navigationService.pop);
          }
        } else {
          setBusy(false);
          _alertService.showWarning(context, 'Warning',
              'Please fill in all fields', _navigationService.pop);
        }
      }else{
        _alertService.showError(
            context, 'Error', 'Please Check Eula', _navigationService.pop);
      }

    } catch (e) {
      print(e.toString());
      _alertService.showError(
          context, 'Error', 'Please check once again', _navigationService.pop);
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

  void onProfesiChanged(String value) {
    profesiSelected = value;
    getAreas();
    setBusy(false);
  }

  void getDistrict(String value){
    districts.clear();
    jurusanList.clear();
    districtSelected=null;
    jurusanSelected = null;
//    print(areaForDistrcit.where((element) => element.areasDistrict==value).toList());
//
//    List<Item> data = areaForDistrcit.where((element) => element.areasDistrict==value).toList();
//    districts.addAll(data)
    for(int i=0 ; i<areaForDistrcit.length;i++){
      if(areaForDistrcit[i].areasDistrict==value){
        districts.addAll(areaForDistrcit[i].district);
      }
    }
  }
  void onDistricChanged(String value) async {
    districtSelected = value;
    setBusy(false);

    jurusanSelected = null;
    jurusanList.clear();

    final data = await _apiService.jurusan(areasSelected, value);
    if (data.code==200) {
      print("add");
      data.data.forEach((element) {
        jurusanList.add(element.companyName + '-' +element.companyCode);
      });
    } else {
      // User already registered
    }

    setBusy(false);
    print('jurusan => ${data.code}');
    print('visi => ${changeVisibility()}');
  }

  void onJurusanChanged(String value) {
    jurusanSelected = value;
    setBusy(false);
    company = value.split('-')[1];
    print(value.split('-')[1]);

  }

  void getAreaUnit(String value) async {
    setBusy(false);
    profesiSelected = value;
    areasSelected = null;
    districtSelected = null;
    jurusanSelected=null;
    districts.clear();
    areasList.clear();
    jurusanList.clear();

    final data = await _apiService.areas();
    if (data.code==200) {
      print("add");
      data.data.areas.forEach((element) {
        areasList.add(element.area);
        areaForDistrcit.add(Item(element.area, element.districts));
      });
    } else {
      // User already registered
    }

    setBusy(false);
    print('units => $units');
    print('visi => ${changeVisibility()}');
  }
  void onAreasChanged(String value) {
    areasSelected = value;

    getDistrict(value);
    setBusy(false);
  }

  bool changeVisibilityDistrict(){
    if(districts== null || districts.isEmpty){
      return false;
    }else{
      return true;
    }
  }
  bool changeVisibilityAreas(){
    if(areasList== null || areasList.isEmpty){
      return false;
    }else{
      return true;
    }
  }
  bool changeVisibility() {
    if (units == null || units.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void getJurusan(String value)async{
    jurusanSelected=null;
    jurusanList.clear();
    final data = await _apiService.jurusan(areasSelected, value);
    if(data.code ==200){
      data.data.forEach((element) {
        jurusanList.add(element.companyName+'-'+element.companyCode);
        print("data ${element.companyCode}");
      });
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

class Item {
  String areasDistrict;
  List district;
  Item(this.areasDistrict, this.district);
}
