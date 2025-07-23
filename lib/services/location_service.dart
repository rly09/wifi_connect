import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;

class LocationService {
  /// Gets the user's current location using `location` package
  static Future<loc.LocationData> getCurrentLocation() async {
    final loc.Location location = loc.Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw Exception("Location services are disabled.");
      }
    }

    loc.PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        throw Exception("Location permission denied.");
      }
    }

    return await location.getLocation();
  }

  /// Calculates distance in meters between two lat/lng points
  static double calculateDistanceMeters(
      double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }
}
