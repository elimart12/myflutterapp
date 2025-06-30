import 'package:flutter/material.dart';
import 'gender_predictor.dart';
import 'age_predictor.dart';
import 'universities_view.dart';
import 'weather_view.dart';
import 'pokemon_view.dart';
import 'wordpress_news_view.dart';
import 'about_me.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Caja de Herramientas")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/images/toolbox.png'),
            _buildButton(
                context, "Predecir Género", const GenderPredictorView()),
            _buildButton(context, "Estimar Edad", const AgePredictorView()),
            _buildButton(context, "Universidades", const UniversitiesView()),
            _buildButton(context, "Clima en RD", const WeatherView()),
            _buildButton(context, "Buscar Pokémon", const PokemonView()),
            _buildButton(
                context, "Noticias WordPress", const WordPressNewsView()),
            _buildButton(context, "Acerca de mí", const AboutMeView()),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, Widget targetView) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        child: Text(label),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetView),
        ),
      ),
    );
  }
}
