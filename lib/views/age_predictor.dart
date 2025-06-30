import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AgePredictorView extends StatefulWidget {
  const AgePredictorView({super.key});

  @override
  State<AgePredictorView> createState() => _AgePredictorViewState();
}

class _AgePredictorViewState extends State<AgePredictorView> {
  final TextEditingController _controller = TextEditingController();
  int? _age;
  bool _isLoading = false;
  String _name = "";

  String getAgeCategory(int age) {
    if (age < 30) return "Joven";
    if (age < 60) return "Adulto";
    return "Anciano";
  }

  String getImageAsset(int age) {
    if (age < 30) return 'assets/images/joven.png';
    if (age < 60) return 'assets/images/adulto.png';
    return 'assets/images/anciano.png';
  }

  Future<void> _predictAge(String name) async {
    setState(() {
      _isLoading = true;
      _age = null;
    });

    final url = Uri.parse('https://api.agify.io/?name=$name');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        _age = json['age'];
        _isLoading = false;
        _name = name;
      });
    } else {
      setState(() {
        _age = null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Estimar Edad")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Introduce un nombre para estimar la edad:"),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final name = _controller.text.trim();
                if (name.isNotEmpty) {
                  _predictAge(name);
                }
              },
              child: const Text("Estimar Edad"),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_age != null)
              Column(
                children: [
                  Text("Edad estimada para '$_name': $_age"),
                  Text(getAgeCategory(_age!)),
                  Image.asset(getImageAsset(_age!),
                      height: 150, width: 150, fit: BoxFit.contain),
                ],
              )
            else
              const Text("No se pudo determinar la edad."),
          ],
        ),
      ),
    );
  }
}
