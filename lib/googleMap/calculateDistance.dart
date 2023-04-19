import 'dart:math' show asin, cos, pi, pow, sin, sqrt;

// double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//   const double earthRadius = 6371; // in kilometers
//
//   double dLat = _toRadians(lat2 - lat1);
//   double dLon = _toRadians(lon2 - lon1);
//
//   double a = pow(sin(dLat / 2), 2) +
//       cos(_toRadians(lat1)) *
//           cos(_toRadians(lat2)) *
//           pow(sin(dLon / 2), 2);
//   double c = 2 * asin(sqrt(a));
//   double distance = earthRadius * c;
//
//   return distance; // in kilometers
// }
//
// double _toRadians(double degrees) {
//   return degrees * pi / 180;
// }

String calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371; // in kilometers

  double dLat = _toRadians(lat2 - lat1);
  double dLon = _toRadians(lon2 - lon1);

  double a = pow(sin(dLat / 2), 2) +
      cos(_toRadians(lat1)) *
          cos(_toRadians(lat2)) *
          pow(sin(dLon / 2), 2);
  double c = 2 * asin(sqrt(a));
  double distance = earthRadius * c;

  if (distance >= 1) {
    return distance.toStringAsFixed(1) + ' km';
  } else {
    return (distance * 1000).toStringAsFixed(0) + ' m';
  }
}

double _toRadians(double degrees) {
  return degrees * pi / 180;
}

