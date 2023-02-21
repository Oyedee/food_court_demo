import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_court_demo/src/features/weather_page/models/temperature.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/custom_dropdown_search.dart';
import '../../../widgets/weather_icon_widget.dart';
import '../controllers/city_current_weather_controller.dart';
import '../models/cities_response.dart';
import '../models/weather_response.dart';

class CurrentWeather extends ConsumerStatefulWidget {
  const CurrentWeather({Key? key}) : super(key: key);

  @override
  ConsumerState<CurrentWeather> createState() => _CurrentWeatherState();
}

class _CurrentWeatherState extends ConsumerState<CurrentWeather> {
  Cities? _selectedCity1;
  Cities? _selectedCity2;
  Cities? _selectedCity3;
  List<Cities> _cityList = [];

  onCity1Selected(Cities? value) {
    setState(() {
      _selectedCity1 = value;
      ref.read(cityProvider.notifier).state = value?.city ?? '';
    });
  }

  onCity2Selected(Cities? value) {
    setState(() {
      _selectedCity3 = value;
      ref.read(city2Provider.notifier).state = value?.city ?? '';
    });
  }

  onCity3Selected(Cities? value) {
    setState(() {
      _selectedCity3 = value;
      ref.read(city3Provider.notifier).state = value?.city ?? '';
    });
  }

  Future<void> getCityList() async {
    final String response = await rootBundle.loadString('assets/ng.json');
    final data = await json.decode(response);
    setState(() {
      _cityList = CityList.fromJson(data).cities ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    getCityList();
  }

  @override
  Widget build(BuildContext context) {
    final lagosWeather = ref.watch(currentWeatherControllerProvider(ref.read(cityProvider)));
    final abujaWeather = ref.watch(currentWeatherControllerProvider(ref.read(city2Provider)));
    final ibadanWeather = ref.watch(currentWeatherControllerProvider(ref.read(city3Provider)));
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
            child: Container(
              padding: const EdgeInsets.only(bottom: 3, top: 3, right: 3, left: 3),
              height: 40,
              decoration: BoxDecoration(color: const Color(0xffF1F3F5), borderRadius: BorderRadius.circular(9.0)),
              child: TabBar(
                  indicator: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  labelColor: Colors.black,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  unselectedLabelColor: const Color(0xff212529),
                  tabs: const [
                    Tab(text: 'City One'),
                    Tab(text: 'City Two'),
                    Tab(text: 'City Three'),
                  ]),
            ),
          ),
          SizedBox(
            height: 500,
            child: TabBarView(
              children: [
                SizedBox(
                  height: 200,
                  //decoration: const BoxDecoration(color: AppColors.rainBlueDark),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: CustomDropdownSearch<Cities>(
                                  isRequired: false,
                                  title: 'City',
                                  hintText: 'Select a City',
                                  items: _cityList,
                                  selectedItem: _selectedCity1,
                                  borderColor: Colors.transparent,
                                  onChanged: onCity1Selected,
                                  compareFn: (Cities? i, Cities? s) => i!.city == s!.city,
                                  itemAsString: (Cities? u) => u!.city ?? '',
                                  itemBuilder: (context, item, isSelected) {
                                    return Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        item.city ?? '',
                                        style: const TextStyle(
                                          color: AppColors.rainBlueLight,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(ref.read(cityProvider), style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 30),
                      lagosWeather.when(
                        data: (weatherData) => CurrentWeatherContents(data: weatherData),
                        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accentColor)),
                        error: (e, __) => Text(e.toString()),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 200,
                  //decoration: const BoxDecoration(color: AppColors.accentColor),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: CustomDropdownSearch<Cities>(
                                  isRequired: false,
                                  title: 'City',
                                  hintText: 'Select a City',
                                  items: _cityList,
                                  selectedItem: _selectedCity2,
                                  borderColor: Colors.transparent,
                                  onChanged: onCity2Selected,
                                  compareFn: (Cities? i, Cities? s) => i!.city == s!.city,
                                  itemAsString: (Cities? u) => u!.city ?? '',
                                  itemBuilder: (context, item, isSelected) {
                                    return Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        item.city ?? '',
                                        style: const TextStyle(
                                          color: AppColors.rainBlueLight,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(ref.read(city2Provider), style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 30),
                      abujaWeather.when(
                        data: (weatherData) => CurrentWeatherContents(data: weatherData),
                        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accentColor)),
                        error: (e, __) => Text(e.toString()),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 200,
                  //decoration: const BoxDecoration(color: AppColors.rainBlueLight),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: CustomDropdownSearch<Cities>(
                                  isRequired: false,
                                  title: 'City',
                                  hintText: 'Select a City',
                                  items: _cityList,
                                  selectedItem: _selectedCity3,
                                  borderColor: Colors.transparent,
                                  onChanged: onCity3Selected,
                                  compareFn: (Cities? i, Cities? s) => i!.city == s!.city,
                                  itemAsString: (Cities? u) => u!.city ?? '',
                                  itemBuilder: (context, item, isSelected) {
                                    return Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        item.city ?? '',
                                        style: const TextStyle(
                                          color: AppColors.rainBlueLight,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(ref.read(city3Provider), style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 30),
                      ibadanWeather.when(
                        data: (weatherData) => CurrentWeatherContents(data: weatherData),
                        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accentColor)),
                        error: (e, __) => Text(e.toString()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CurrentWeatherContents extends ConsumerWidget {
  const CurrentWeatherContents({Key? key, required this.data}) : super(key: key);
  final WeatherData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    final temp = Temperature.celsius(data.main?.temp?.toDouble() ?? 0).celsius.toString();
    final minTemp = data.main?.tempMin?.toInt().toString();
    final maxTemp = data.main?.tempMax?.toInt().toString();
    final highAndLow = 'H:$maxTemp° L:$minTemp°';
    final description = data.weather![0].description;
    final icon = data.weather![0].icon;
    final cityName = data.name ?? "";
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        WeatherIconImage(iconUrl: 'https://openweathermap.org/img/wn/$icon@2x.png', size: 120),
        Text(temp, style: textTheme.displayMedium),
        Text(description ?? '', textAlign: TextAlign.center, style: textTheme.displayMedium),
        Text(highAndLow, style: textTheme.bodySmall),
        Text(cityName, style: textTheme.bodyMedium),
      ],
    );
  }
}
