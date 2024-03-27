import 'dart:convert';
import 'package:gaa/core/globals/global_variables.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class GoogleMapApiController {
  static Future<String> getAddressFromPosition(Position position) async {
    // Replace with your actual API key
    final apiUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final results = data['results'];
          if (results.isNotEmpty) {
            final address = results[0]['formatted_address'];
            return address;
          }
        }
      }
      return 'No Address Found';
    } catch (e) {
      print('Error getting address: $e');
      return 'Error Getting Address';
    }
  }

  static Future<Map<String, List<String>>> searchNearbyPlaces(
      Position position) async {
    // Replace with your actual API key
    final apiUrl =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${position.latitude},${position.longitude}&key=$mapKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final results = data['results'];
          Map<String, List<String>> sortedPlaces = {
            'malls': [],
            'airports': [],
            'tourist_spots': [],
          };
          for (var place in results) {
            print(place);
            if (place['types'].contains('shopping_mall')) {
              sortedPlaces['malls']!.add(place['name']);
            } else if (place['types'].contains('airport')) {
              sortedPlaces['airports']!.add(place['name']);
            } else if (place['types'].contains('tourist_attraction')) {
              sortedPlaces['tourist_spots']!.add(place['name']);
            }
          }
          return sortedPlaces;
        }
      }
      return {};
    } catch (e) {
      print('Error searching nearby places: $e');
      return {};
    }
  }
}
