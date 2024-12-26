import 'api_key.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weathe_app_flutter/models/weather_model.dart';
import 'package:weathe_app_flutter/services/weather_service.dart';
import 'package:google_fonts/google_fonts.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // apikey
  final _weatherService = WeatherService(tmdbApiKey); // SUA API_KEY
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
      body: SafeArea(
        minimum: EdgeInsets.all(80), // Padding
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // City Name
              Column(
                children: [
                  Icon(
                    Icons.place,
                    size: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _weather?.cityName ?? "Loading city...",
                      style: GoogleFonts.bebasNeue(
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              ),

              // Animation
              Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

              // Temperature
              Column(
                children: [
                  Text(
                    '${_weather?.temperature.round() ?? 'Loading temperature in '}°C',
                    style: GoogleFonts.bebasNeue(fontSize: 50, height: 1),
                  ),
                  // Weather condition
                  Text(_weather?.mainCondition ?? ""),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
