import 'package:surveypptik/models/user_location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
class GeolocatorService {
  final Geolocator _geolocator = Geolocator();
  Future<UserLocation> getCurrentLocation() async {
    try {
      var addressLine = '';

      final Position position = await _geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
      final Coordinates coordinates =
          Coordinates(position.latitude, position.longitude);
      final addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);

      if (position.mocked) {
        addressLine = addresses.first.addressLine + ' #FakeLocation';
      } else {
        addressLine = addresses.first.addressLine;
      }

      UserLocation userLocation = UserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        addressLine: addressLine,
      );

      return userLocation;
    } catch (e) {
      print('[getCurrentLocation] Error Ocurred $e');
      return null;
    }
  }
}
