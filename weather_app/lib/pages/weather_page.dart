import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  // apikey
  final _weatherService = WeatherService('apiiiiiiiiiiiiiiiiiiiiiiiiiii');
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

    // animação

    // iniciar state
    @override
    void initState() {
      super.initState();

      _fetchWeather();
    }
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
            // temperatura
            Text('${_weather?.temperature.toString()}°C'),
          ],
        ),
      ),
    );
  }
}