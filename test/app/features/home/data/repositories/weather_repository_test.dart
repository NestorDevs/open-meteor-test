import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:mocktail/mocktail.dart';
import 'package:open_meteor/app/features/home/data/repositories/weather_repository.dart';

abstract class HttpClient {
  Future<http.Response> get(Uri url);
}

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  group('WeatherRepository', () {
    late WeatherRepository weatherRepository;

    setUp(() {
      weatherRepository = WeatherRepository();
      registerFallbackValue(Uri.parse('https://example.com'));
    });

    test('getMinMaxTemperature returns min and max temperature', () {
      final weatherData = {
        'hourly': {
          'temperature_2m': [15.0, 18.0, 12.0, 20.0, 10.0]
        }
      };

      final expectedResult = {'min': 10.0, 'max': 20.0};

      final result = weatherRepository.getMinMaxTemperature(weatherData);

      expect(result, expectedResult);
    });
  });
}
