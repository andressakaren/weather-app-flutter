import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weathe_app_flutter/models/weather_model.dart';
import 'package:weathe_app_flutter/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // apikey
  final _weatherService = WeatherService('f188be1f1a0041ac81d46b7cdb4caac6');
  Weather? _weather;

  _fetchWeather() async {
    // pegar a cidade atual
    String cityName = await _weatherService.getCurrentCity();

    // obter o clima dessa cidade
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    // se tiver erro
    catch (e) {
      print(e);
    }
  }

    // animação
    String getWeatherAnimation(String? mainCondition) {
      if (mainCondition == null) return 'assets/sunny.json'; //default 

      switch (mainCondition.toLowerCase()) {
        case 'clouds':
        case 'mist':
        case 'smoke':
        case 'haze':
        case 'dust':
        case 'fog':
          return 'assets/cloud.json';
        case 'rain':
        case 'drizzle':
        case 'shower rain':
          return 'assets/rain.json';
        case 'thunderstorm':
          return 'assets/thunder.json';
        case 'clear':
          return 'assets/sunny.json';
        default: 
          return 'assets/sunny.json';
    
      }
    }

    // iniciar state
  @override
  void initState() {
    super.initState();

    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // city name
            Text(_weather?.cityName ?? 'loading city..'),

            // animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            // temperatura
            Text('${_weather?.temperature.toString()}°C'),
            
            // weather condition 
            Text(_weather?.mainCondition ?? ''),
          ],
        ),
      ),
    );
  }
}
