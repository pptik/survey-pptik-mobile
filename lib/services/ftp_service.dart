import 'dart:io';

import 'package:surveypptik/constants/const.dart';
import 'package:ftpclient/ftpclient.dart';

class FtpService {

  Future<bool> uploadFile(File file, String guid, String ts) async {
    FTPClient client = FTPClient(PROD_FTP_URL,
        user: PROD_FTP_USERNAME, pass: PROD_FTP_PASSWORD, port: PROD_FTP_PORT);
    try {
      client.connect();
      client.changeDirectory('/kehadiran/image/');
      print("storage image ${file.length()}");
      await client.uploadFile(file, sRemoteName: '$guid$ts-PPTIK.jpg');
    } catch (e) {
      print('[uploadFile] - error ocurred $e');
      return false;
    } finally {
      client.disconnect();
    }

    return true;
  }
}
