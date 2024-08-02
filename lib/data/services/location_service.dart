import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';

class LocationService {
  final String apiKey;

  LocationService(this.apiKey);

  Future<Map<String, dynamic>> searchLocation(String location) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$location&key=$apiKey';
    
    try {
      final response = await http.get(Uri.parse(url));
      final json = jsonDecode(response.body);
      final results = json['results'];

      if (results.isNotEmpty) {
        final firstResult = results[0];
        final lat = firstResult['geometry']['location']['lat'];
        final lng = firstResult['geometry']['location']['lng'];
        final name = firstResult['name'];

        return {
          'lat': lat,
          'lng': lng,
          'name': name,
        };
      } else {
        throw Exception('No results found');
      }
    } catch (e) {
      throw Exception('Failed to search location: $e');
    }
  }

 // FOR CITY BASED SUGGESTIONS

  //  Future<List<String>> searchSuggestions(String query, String city) async {
  //   final url =
  //       'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&types=address&components=country:in|locality:$city&key=$apiKey';
  //   final response = await http.get(Uri.parse(url));
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     final predictions = data['predictions'];
  //     return predictions.map<String>((p) => p['description']).toList();
  //   } else {
  //     throw Exception('Failed to fetch suggestions');
  //   }
  // }


  // FOR REGION / COUNTRY BASED SUGGESTIONS

  Future<List<String>> searchSuggestions(String query, String regionCode) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&components=country:$regionCode&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final suggestions = (data['predictions'] as List)
          .map((item) => item['description'] as String)
          .toList();
      return suggestions;
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  Future<String> getAddress(LatLng position) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      final json = jsonDecode(response.body);
      final results = json['results'];

      if (results.isNotEmpty) {
        return results[0]['formatted_address'];
      } else {
        throw Exception('No address found');
      }
    } catch (e) {
      throw Exception('Failed to get address: $e');
    }
  }
}


