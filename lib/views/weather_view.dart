import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  bool _isLoading = true;
  String? _weatherDescription;
  double? _temperature;

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
    });

    // Coordenadas aproximadas de Santo Domingo, RD
    final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=18.4861&longitude=-69.9312&current_weather=true');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final current = json['current_weather'];
      setState(() {
        _temperature = current['temperature'];
        // El API no devuelve texto, así que ponemos texto genérico:
        _weatherDescription = 'Temperatura actual';
        _isLoading = false;
      });
    } else {
      setState(() {
        _weatherDescription = 'Error al obtener clima';
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Clima en República Dominicana")),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_weatherDescription ?? '',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text(
                    _temperature != null
                        ? '${_temperature!.toStringAsFixed(1)} °C'
                        : '',
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ),
    );
  }
}
