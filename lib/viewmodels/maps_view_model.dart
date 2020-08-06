import 'package:flutter_map/flutter_map.dart';
import 'package:surveypptik/viewmodels/base_model.dart';
import 'package:surveypptik/constants/const.dart';
import 'package:surveypptik/constants/route_name.dart';
import 'package:surveypptik/locator.dart';
import 'package:surveypptik/services/alert_service.dart';
import 'package:surveypptik/services/api_service.dart';
import 'package:surveypptik/services/geolocator_service.dart';
import 'package:surveypptik/services/navigation_service.dart';
import 'package:surveypptik/services/storage_service.dart';
import 'package:surveypptik/services/rmq_service.dart';
import 'package:surveypptik/viewmodels/base_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';

class MapsViewModel extends BaseModel {
  final ApiService _apiService = locator<ApiService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final StorageService _storageService = locator<StorageService>();
  final AlertService _alertService = locator<AlertService>();
  final RMQService _rmqService = locator<RMQService>();
  final GeolocatorService _geolocatorService = locator<GeolocatorService>();
  MapController mapController = MapController();
  List<Marker> markers;
  double lat ;
  double lng ;
  String address = '';
  bool isLoading = false;
  void onModelReady() {
    print('init the home');
    getLocation();
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
