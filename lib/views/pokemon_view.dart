import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemonView extends StatefulWidget {
  const PokemonView({super.key});

  @override
  State<PokemonView> createState() => _PokemonViewState();
}

class _PokemonViewState extends State<PokemonView> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _pokemonData;

  Future<void> _fetchPokemon(String name) async {
    setState(() {
      _isLoading = true;
      _pokemonData = null;
    });

    final url =
        Uri.parse('https://pokeapi.co/api/v2/pokemon/${name.toLowerCase()}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        _pokemonData = json;
        _isLoading = false;
      });
    } else {
      setState(() {
        _pokemonData = null;
        _isLoading = false;
      });
    }
  }

  List<String> getAbilities() {
    if (_pokemonData == null) return [];
    return (_pokemonData!['abilities'] as List)
        .map((e) => e['ability']['name'] as String)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buscar Pokémon")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Introduce el nombre de un Pokémon:"),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: "Pokémon"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final name = _controller.text.trim();
                if (name.isNotEmpty) {
                  _fetchPokemon(name);
                }
              },
              child: const Text("Buscar"),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_pokemonData != null)
              Expanded(
                child: ListView(
                  children: [
                    Image.network(
                      _pokemonData!['sprites']['front_default'] ?? '',
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                    Text(
                        'Experiencia base: ${_pokemonData!['base_experience']}'),
                    const SizedBox(height: 10),
                    const Text('Habilidades:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    ...getAbilities().map((a) => Text(a)).toList(),
                    const SizedBox(height: 10),
                    // No hay sonido oficial en PokeAPI, así que omitimos el audio
                    const Text('Sonido: No disponible'),
                  ],
                ),
              )
            else
              const Text("No se encontró el Pokémon."),
          ],
        ),
      ),
    );
  }
}
