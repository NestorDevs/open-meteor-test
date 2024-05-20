import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../utils/utils.dart';

part 'weather_repository.g.dart';

class WeatherRepository {
  //* Función para obtener datos del clima.
  Future<Map<String, dynamic>> fetchWeatherData(String cityName) async {
    final coordinates = cityCoordinates[cityName]!;
    final latitude = coordinates['latitude']!;
    final longitude = coordinates['longitude']!;

    final response = await http.get(
      Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&hourly=temperature_2m&current_weather=true',
      ),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // Función para obtener la temperatura mínima y máxima
  Map<String, double> getMinMaxTemperature(Map<String, dynamic> weatherData) {
    List<double> temperatures =
        List<double>.from(weatherData['hourly']['temperature_2m']);
    double minTemp = temperatures.reduce((a, b) => a < b ? a : b);
    double maxTemp = temperatures.reduce((a, b) => a > b ? a : b);

    return {
      'min': minTemp,
      'max': maxTemp,
    };
  }
}

@Riverpod(keepAlive: true)
WeatherRepository weatherRepository(WeatherRepositoryRef ref) {
  return WeatherRepository();
}
