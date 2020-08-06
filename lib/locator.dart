import 'package:surveypptik/services/alert_service.dart';
import 'package:surveypptik/services/api_service.dart';
import 'package:surveypptik/services/ftp_service.dart';
import 'package:surveypptik/services/geolocator_service.dart';
import 'package:surveypptik/services/guid_service.dart';
import 'package:surveypptik/services/navigation_service.dart';
import 'package:surveypptik/services/permission_service.dart';
import 'package:surveypptik/services/rmq_service.dart';
import 'package:surveypptik/services/storage_service.dart';
import 'package:surveypptik/services/vibrate_service.dart';
import 'package:get_it/get_it.dart';
import 'package:surveypptik/services/location_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => GeolocatorService());
  locator.registerLazySingleton(() => ApiService());
  locator.registerLazySingleton(() => GuidService());
  locator.registerLazySingleton(() => StorageService());
  locator.registerLazySingleton(() => AlertService());
  locator.registerLazySingleton(() => VibrateService());
  locator.registerLazySingleton(() => FtpService());
  locator.registerLazySingleton(() => RMQService());
  locator.registerLazySingleton(() => LocationService());
  locator.registerLazySingleton(() => PermissionsService());
}
