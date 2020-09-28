import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  Permission _permission;
  PermissionStatus _permissionStatus;

  Future<void> checkStatus(Permission _permissionCheck) async {
    var status = await _permissionCheck;
    print('status = $status');
    return status;
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
    _permissionStatus = status;
    return _permissionStatus;
  }
}
