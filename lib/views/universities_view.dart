import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UniversitiesView extends StatefulWidget {
  const UniversitiesView({super.key});

  @override
  State<UniversitiesView> createState() => _UniversitiesViewState();
}

class _UniversitiesViewState extends State<UniversitiesView> {
  final TextEditingController _controller =
      TextEditingController(text: "Dominican Republic");
  bool _isLoading = false;
  List<dynamic> _universities = [];

  Future<void> _fetchUniversities(String country) async {
    setState(() {
      _isLoading = true;
      _universities = [];
    });

    final url = Uri.parse(
        'http://universities.hipolabs.com/search?country=${Uri.encodeComponent(country)}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        _universities = json;
        _isLoading = false;
      });
    } else {
      setState(() {
        _universities = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Universidades por País")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Introduce un país en inglés:"),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: "País"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final country = _controller.text.trim();
                if (country.isNotEmpty) {
                  _fetchUniversities(country);
                }
              },
              child: const Text("Buscar Universidades"),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_universities.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _universities.length,
                  itemBuilder: (context, index) {
                    final uni = _universities[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(uni['name'] ?? ''),
                        subtitle: Text(
                            'Dominio: ${(uni['domains'] as List).join(", ")}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.open_in_new),
                          onPressed: () {
                            final url = uni['web_pages'] != null &&
                                    (uni['web_pages'] as List).isNotEmpty
                                ? uni['web_pages'][0]
                                : null;
                            if (url != null) {
                              _launchURL(context, url);
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              const Text("No se encontraron universidades."),
          ],
        ),
      ),
    );
  }

  void _launchURL(BuildContext context, String url) async {
    // Usaremos url_launcher para abrir el navegador
    // Debes agregar la dependencia en pubspec.yaml
    // e importar 'package:url_launcher/url_launcher.dart';
    // Pero para que esto funcione en esta demo simple, mostramos un diálogo.
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Abrir enlace"),
        content: Text("Abrir: $url"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar")),
        ],
      ),
    );
  }
}
