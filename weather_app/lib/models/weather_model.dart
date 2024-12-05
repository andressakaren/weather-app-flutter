class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
  });

  // #método para lidar com o arquivo json
  // Map é chave-valor, no caso Strings: para definir que as chaves sao strings, e dynamic: permite que os valores possam ser de qualquer tipo
  // factory é um construtor de fábrica, que é usado quando se quer personalizar uma criação de objetos ou reutilizar obj ja existentes 
  // Weather.fromJson é o construtor, ele cria uma instancia de Weather a partir de um map (q nesse caso vem de json)
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
    );
  }
}

