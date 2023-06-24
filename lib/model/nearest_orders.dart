// import 'package:location/location.dart';
// import 'package:sahlat/models/station.dart';
// import 'dart:math' show cos, sqrt, asin;

// class NearestOrder {
//   Future<List<Station>> sortStationByNear(List<Station> stations) async {
//     Location location = new Location();
//     LocationData userLocation = await location.getLocation();
//     List<Station> result = stations;
//     result.sort(
//       (a, b) => coordinateDistance(a.location.lat, a.location.long,
//               userLocation.latitude, userLocation.longitude)
//           .toInt()
//           .compareTo(
//             coordinateDistance(b.location.lat, b.location.long,
//                     userLocation.latitude, userLocation.longitude)
//                 .toInt(),
//           ),
//     );
//     return result;
//   }

//   static double coordinateDistance(lat1, lon1, lat2, lon2) {
//     var p = 0.017453292519943295;
//     var c = cos;
//     var a = 0.5 -
//         c((lat2 - lat1) * p) / 2 +
//         c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
//     return (12742 * asin(sqrt(a))) * 1000;
//   }
// }
