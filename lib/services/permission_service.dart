
import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  Permission _permission;
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;

  Future<PermissionStatus> checkStatus(Permission _permissionCheck)async {
      final status = await _permissionCheck.status;
      return status;

  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
    _permissionStatus = status;
    return _permissionStatus;
  }
}