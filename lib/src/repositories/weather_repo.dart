import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../features/weather_page/models/location_weather_data.dart';
import '../features/weather_page/models/weather_response.dart';
import '../services/api_keys.dart';
import '../services/api_service.dart';

class WeatherRepo {
  final OpenWeatherMapAPI api;
  final http.Client client;

  WeatherRepo({required this.api, required this.client});
  Future<WeatherData> getWeather({required String city}) => _getData(
        uri: api.weather(city),
        builder: (data) => WeatherData.fromJson(data),
      );

  Future<LocationWeatherData> getCurrentLocationWeather({required double lat, required double long}) {
    return _getData(
      uri: api.currentLocationWeather(lat, long),
      builder: (data) => LocationWeatherData.fromJson(data),
    );
  }

  Future<T> _getData<T>({
    required Uri uri,
    required T Function(dynamic data) builder,
  }) async {
    try {
      final response = await client.get(uri);
      switch (response.statusCode) {
        case 200:
          final data = json.decode(response.body);
          return builder(data);
        case 401:
          final data = json.decode(response.body);
          throw data['message'] ?? 'Invalid api key';
        case 404:
          throw 'not found';
        default:
          throw 'Unknown error';
      }
    } on SocketException catch (_) {
      //throw const APIError.noInternetConnection();
      throw 'No internet connection';
    }
  }
}

/// Providers used by rest of the app
final weatherRepoProvider = Provider<WeatherRepo>((ref) {
  const apiKey = APIKeys.openWeatherAPIKey;
  return WeatherRepo(
    api: OpenWeatherMapAPI(apiKey),
    client: http.Client(),
  );
});
