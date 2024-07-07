import 'dart:math';

//compute the distance between two geographic points using the Haversine formula
class LocationUtils {
  static const double _earthRadius = 6371000; // Earth radius in meters

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    final double lat1Rad = _degreesToRadians(lat1);
    final double lon1Rad = _degreesToRadians(lon1);
    final double lat2Rad = _degreesToRadians(lat2);
    final double lon2Rad = _degreesToRadians(lon2);

    final double deltaLat = lat2Rad - lat1Rad;
    final double deltaLon = lon2Rad - lon1Rad;

    final double a =
        sin(deltaLat / 2) * sin(deltaLat / 2) + cos(lat1Rad) * cos(lat2Rad) * sin(deltaLon / 2) * sin(deltaLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return _earthRadius * c;
  }

  static bool isWithinRadius(
      double currentLat, double currentLon, double targetLat, double targetLon, double radiusInMeters) {
    final double distance = calculateDistance(currentLat, currentLon, targetLat, targetLon);
    return distance <= radiusInMeters;
  }
}
