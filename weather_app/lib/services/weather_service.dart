import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (response == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    bool serviceEnabled;
    LocationPermission permission;

    print('Verificando se o serviço de localização está habilitado...');
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // se n =ão tiver habilitado, retornar erro
      return Future.error('Serviço de localização está desabilitado.');
    }

    print('Verificar permissão: ');
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      // solicitar permisão novamente
      if (permission == LocationPermission.denied) {
        return Future.error('Permissão negada');
      }
    }
    // serviço negado permanentemente
    if (permission == LocationPermission.deniedForever) {
      print('Permissão negada permanentemente.');
      return Future.error(
          'Location permissions are permanently denied. Please enable them in settings.');
    }

    print('Obtendo a posição atual...');
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Position position =
        await Geolocator.getCurrentPosition(locationSettings: locationSettings);
        
    print('Posição obtida: ${position.latitude}, ${position.longitude}');

    print('Convertendo coordenadas em nome da cidade...');
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print('Placemarks obtidos: $placemark');

    String? city = placemark[0].locality;
    print('Cidade detectada: $city');

    return city ?? ''; // Retorna uma string vazia se for nula
  }

  //   print('Obtendo a posição atual...');
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   print('Posição obtida: ${position.latitude}, ${position.longitude}');
}
