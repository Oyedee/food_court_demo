import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../repositories/weather_repo.dart';
import '../models/location_weather_data.dart';

class CurrentLocationWeatherController extends StateNotifier<AsyncValue<LocationWeatherData>> {
  CurrentLocationWeatherController(this._weatherRepo) : super(const AsyncValue.loading());
  final WeatherRepo _weatherRepo;
  Future<void> getCurrentLocationWeather({required double lat, required double long}) async {
    try {
      log('I got here');
      state = const AsyncValue.loading();
      final weather = await _weatherRepo.getCurrentLocationWeather(lat: lat, long: long);
      log('I got here too');
      state = AsyncValue.data(LocationWeatherData.fromJson(weather.toJson()));
      log('This is the location weather data: ${weather.toJson()}');
    } catch (e, stackTrace) {
      state = AsyncValue.error(e.toString(), stackTrace);
      log('error: ${e.toString()}');
    }
  }
}

final currentLocationWeatherControllerProvider =
    StateNotifierProvider.autoDispose<CurrentLocationWeatherController, AsyncValue<LocationWeatherData>>((ref) {
  final weatherRepository = ref.watch(weatherRepoProvider);
  return CurrentLocationWeatherController(weatherRepository);
});
