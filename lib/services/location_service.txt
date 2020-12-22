import 'package:location/location.dart';

class LocationService {
  bool _serviceEnabled;
  final Location location = new Location();

  Future<void> checkService() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }
}
