import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/weather_icon_widget.dart';
import '../controllers/current_location_weather_controller.dart';
import '../models/temperature.dart';

class CurrentLocationWeatherPage extends ConsumerWidget {
  const CurrentLocationWeatherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final currentLocation = ref.watch(currentLocationWeatherControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Weather'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.rainGradient,
          ),
        ),
        child: SafeArea(
          child: currentLocation.when(
              data: (data) {
                final temp = Temperature.celsius(data.main?.temp?.toDouble() ?? 0).celsius.toString();
                final minTemp = data.main?.tempMin?.toInt().toString();
                final maxTemp = data.main?.tempMax?.toInt().toString();
                final highAndLow = 'H:$maxTemp° L:$minTemp°';
                final description = data.weather![0].description;
                final icon = data.weather![0].icon;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    WeatherIconImage(iconUrl: 'https://openweathermap.org/img/wn/$icon@2x.png', size: 120),
                    Text(temp ?? '', style: textTheme.headline2),
                    Text(description ?? '', textAlign: TextAlign.center, style: textTheme.headline2),
                    Text(highAndLow, style: textTheme.bodyText2),
                  ],
                );
              },
              error: (error, stackTrace) {
                return Center(child: Text(error.toString()));
              },
              loading: () => Center(child: const CircularProgressIndicator(color: AppColors.accentColor))),
        ),
      ),
    );
  }
}
