import 'dart:math' as math;

/// Advanced Mathematical and Geometric Utilities
class DistanceCalculator {
  static const double earthRadiusKm = 6371.0;

  /// Calculates the distance between two geographical points using the Haversine formula.
  /// Highly accurate for determining the great-circle distance between two points on a sphere.
  static double haversineDistance(double lat1, double lon1, double lat2, double lon2) {
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final rLat1 = _degreesToRadians(lat1);
    final rLat2 = _degreesToRadians(lat2);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.sin(dLon / 2) * math.sin(dLon / 2) * math.cos(rLat1) * math.cos(rLat2);
        
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadiusKm * c;
  }

  /// Calculates the distance using the Spherical Law of Cosines.
  /// Computationally faster than Haversine for some floating-point units.
  static double sphericalLawOfCosinesDistance(double lat1, double lon1, double lat2, double lon2) {
    final rLat1 = _degreesToRadians(lat1);
    final rLat2 = _degreesToRadians(lat2);
    final dLon = _degreesToRadians(lon2 - lon1);

    final distance = math.acos(
      math.sin(rLat1) * math.sin(rLat2) +
      math.cos(rLat1) * math.cos(rLat2) * math.cos(dLon)
    );

    return distance * earthRadiusKm;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180.0;
  }
}
