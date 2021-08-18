import 'dart:convert';
import 'dart:io';

import 'package:surveypptik/models/absent_data.dart';
import 'package:surveypptik/models/areas_model.dart';
import 'package:surveypptik/models/change_password_data.dart';
import 'package:surveypptik/models/company_unit.dart';
import 'package:surveypptik/models/jurusan_model.dart';
import 'package:surveypptik/models/login_data.dart';
import 'package:surveypptik/models/register_model.dart';
import 'package:surveypptik/models/update_company_unit.dart';
import 'package:async/async.dart';
import 'package:surveypptik/constants/const.dart';
import 'package:surveypptik/models/report_data.dart';
import 'package:surveypptik/models/user_data.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as Path;

class ApiService {
  Future<ResponseJurusan> jurusan(String area, String district) async {
    final client = http.Client();
    try {
      final jurusanUrl = '${BASE_URL}companies/$area/$district';
      print(jurusanUrl);
      final response = await client.get(jurusanUrl);
      final jurusanData = responseJurusanFromJson(response.body);
      if (jurusanData.status != true || response.statusCode != 200) {
        return null;
      }

      return jurusanData;
    } catch (e) {
      print('[Jurusan] error occurred $e');
      return null;
    }
  }

  Future<ResponseAreas> areas() async {
    final client = http.Client();
    try {
      final areasUrl = '${BASE_URL}areas';
      final response = await client.get(areasUrl);
      final userData = responseAreasFromJson(response.body);
      print(userData.code);
      if (userData.status == "failed" || response.statusCode != 200) {
        return null;
      }

      return userData;
    } catch (e) {
      print('[Login] error occurred $e');
      return null;
    }
  }

  Future<ResponseRegister> register(
    String name,
    String email,
    String password,
    String position,
    String idCard,
    String company,
    String localImage,
    String unit,
    String phonenumber,
    File imageFile,
  ) async {
    try {
      final stream =
          http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      final length = await imageFile.length();
      final multipartFile = http.MultipartFile('image', stream, length,
          filename: Path.basename(imageFile.path));
      final registerUrl = Uri.parse('${BASE_URL}users/register');
      print(registerUrl);
      final request = http.MultipartRequest('POST', registerUrl)
        ..fields['name'] = name
        ..fields['email'] = email
        ..fields['password'] = password
        ..fields['position'] = position
        ..fields['id_card'] = idCard
        ..fields['company'] = company
        ..fields['local_image'] = localImage
        ..fields['unit'] = unit
        ..fields['phone_number'] = phonenumber
        ..files.add(multipartFile);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final userData = responseRegisterFromJson(response.body);
      print(userData);
      print('response register ${response.body}');
      return userData;
    } catch (e) {
      print('[Register] Error occurred $e');
      return null;
    }
  }

  Future<LoginData> newLogin(String email, String password) async {
    final client = http.Client();
    try {
      final loginUrl = '${BASE_URL}users/login';
      print('login URL $loginUrl');

      final response = await client.post(
        loginUrl,
        body: {
          'email': email,
          'password': password,
        },
      );
      print(response.body);
      final userData = loginDataFromJson(response.body);
      if (userData.status != true || response.statusCode != 200) {
        return null;
      }
      return userData;
    } catch (e) {
      print('[Login] error occurred $e');
      return null;
    }
  }

  Future<UserData> login(String email, String password) async {
    final client = http.Client();
    try {
      final loginUrl = '${BASE_URL}users/login';
      final response = await client.post(
        loginUrl,
        body: {
          'EMAIL': email,
          'ID_CARD': password,
        },
      );
      final userData = userDataFromJson(response.body);

      if (userData.status == "failed" || response.statusCode != 200) {
        return null;
      }

      return userData;
    } catch (e) {
      print('[Login] error occurred $e');
      return null;
    }
  }

  Future<ReportData> getReport(
    String company,
    String guid,
    int page,
  ) async {
    final client = http.Client();
    try {
      final reportUrl = '${BASE_URL}report/$company/$guid/$page';
      final response = await client.get(reportUrl);
      final data = json.decode(response.body);
      print(data['code']);
      final reportData = reportDataFromJson(response.body);

      return reportData;
    } catch (e) {
      print('[getReport] error occurred $e');
      return null;
    }
  }

  Future<CompanyUnitData> getCompanyUnit(String companyCode) async {
    final client = http.Client();
    try {
      final reportUrl = '${BASE_URL}company/$companyCode/units?code=true';
      final response = await client.get(reportUrl);
      final companyUnitData = companyUnitDataFromJson(response.body);

      if (companyUnitData.code != 200) {
        return null;
      }
      return companyUnitData;
    } catch (e) {
      print('[getCompanyUnit] error occurred $e');
      return null;
    }
  }

  Future<AbsentData> report(
    String image,
    String company,
    String guid,
    String name,
    String lng,
    String lat,
    String address,
    String status,
    String position,
    String unit,
    String timestamp,
    String description,
    File imageFile,
  ) async {
    try {
      final stream =
          http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      final length = await imageFile.length();
      final multipartFile = http.MultipartFile('IMAGE', stream, length,
          filename: Path.basename(imageFile.path));
      final reportUrl = Uri.parse('${BASE_URL}users/report/create');
      print(reportUrl);
      final request = http.MultipartRequest('POST', reportUrl)
        ..files.add(multipartFile)
        ..fields['COMPANY'] = company
        ..fields['GUID'] = guid
        ..fields['NAME'] = name
        ..fields['LONG'] = lng
        ..fields['LAT'] = lat
        ..fields['ADDRESS'] = address
        ..fields['LOCAL_IMAGE'] = image
        ..fields['STATUS'] = status
        ..fields['DESCRIPTION'] = description
        ..fields['POSITION'] = position
        ..fields['UNIT'] = unit
        ..fields['TIMESTAMP'] = timestamp;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final absentData = absentDataFromJson(response.body);
      if (absentData.status != "success" || response.statusCode != 200) {
        return null;
      }
      print('response absentData ${response.body}');

      return absentData;
    } catch (e) {
      print('[AbsentData] error occurred $e');
      return null;
    }
  }

  Future<UpdateCompanyData> updateCompanyUnit(
    String guid,
    String companyCode,
    String unit,
  ) async {
    final client = http.Client();
    try {
      final reportUrl = '${BASE_URL}users/profile/update';
      final response = await client.patch(
        reportUrl,
        body: {
          'guid': guid,
          'company': companyCode,
          'unit': unit,
        },
      );
      final updateCompanyData = updateCompanyDataFromJson(response.body);

      return updateCompanyData;
    } catch (e) {
      print('[UpdateCompanyData] error occurred $e');
      return null;
    }
  }

  Future<ChangePasswordData> changePassword(String email, String currentPw,
      String newPw, String confirmationPw) async {
    final client = http.Client();
    try {
      final processUrl = '${BASE_URL}users/change-password';
      final response = await client.patch(processUrl, body: {
        'email': email,
        'current_password': currentPw,
        'new_password': newPw,
        'new_password_confirmation': confirmationPw
      });
      final changePasswordData = changePasswordDataFromJson(response.body);
      return changePasswordData;
    } catch (e) {
      print('[ChangePasswordData] error occurred $e');
      return null;
    }
  }
}
