class OpenWeatherMapAPI {
  OpenWeatherMapAPI(this.apiKey);
  final String apiKey;

  static const String _apiBaseUrl = "api.openweathermap.org";
  static const String _apiPath = "/data/2.5/";

  Uri weather(String city) => _buildUri(
        endpoint: "weather",
        parametersBuilder: () => cityQueryParameters(city),
      );

  Uri currentLocationWeather(double lat, double long) {
    print(' I got here: lat: $lat, long: $long');
    return _buildUri(
      endpoint: "weather",
      parametersBuilder: () => currentLocationParameters(lat, long),
    );
  }

  Uri _buildUri({
    required String endpoint,
    required Map<String, dynamic> Function() parametersBuilder,
  }) {
    return Uri(
      scheme: "https",
      host: _apiBaseUrl,
      path: "$_apiPath$endpoint",
      queryParameters: parametersBuilder(),
    );
  }

  Map<String, dynamic> cityQueryParameters(String city) => {
        "q": city,
        "appid": apiKey,
        "units": "metric",
      };

  Map<String, dynamic> currentLocationParameters(double lat, double long) => {
        "lat": lat,
        "long": long,
        "appid": apiKey,
        "units": "metric",
      };
}
