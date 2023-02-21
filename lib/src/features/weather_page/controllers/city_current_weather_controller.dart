import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_court_demo/src/repositories/weather_repo.dart';

import '../models/weather_response.dart';

class CityCurrentWeatherController extends StateNotifier<AsyncValue<WeatherData>> {
  CityCurrentWeatherController(this._weatherRepo, {required this.city}) : super(const AsyncValue.loading()) {
    getWeather(city: city);
  }
  final WeatherRepo _weatherRepo;
  final String city;

  Future<void> getWeather({required String city}) async {
    try {
      state = const AsyncValue.loading();
      final weather = await _weatherRepo.getWeather(city: city);
      state = AsyncValue.data(WeatherData.fromJson(weather.toJson()));
    } catch (e, stackTrace) {
      state = AsyncValue.error(e.toString(), stackTrace);
    }
  }
}

final currentWeatherControllerProvider =
    StateNotifierProvider.family<CityCurrentWeatherController, AsyncValue<WeatherData>, String>((ref, city) {
  final weatherRepository = ref.watch(weatherRepoProvider);
  //final city = ref.watch(cityProvider);
  return CityCurrentWeatherController(weatherRepository, city: city);
});

final cityProvider = StateProvider<String>((ref) {
  return 'Lagos';
});
final city2Provider = StateProvider<String>((ref) {
  return 'Abuja';
});
final city3Provider = StateProvider<String>((ref) {
  return 'Ibadan';
});
