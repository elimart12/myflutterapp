import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GenderPredictorView extends StatefulWidget {
  const GenderPredictorView({super.key});

  @override
  State<GenderPredictorView> createState() => _GenderPredictorViewState();
}

class _GenderPredictorViewState extends State<GenderPredictorView> {
  final TextEditingController _controller = TextEditingController();
  String? _gender;
  bool _isLoading = false;
  String _name = "";

  Future<void> _predictGender(String name) async {
    setState(() {
      _isLoading = true;
      _gender = null;
    });

    final url = Uri.parse('https://api.genderize.io/?name=$name');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        _gender = json['gender'];
        _isLoading = false;
        _name = name;
      });
    } else {
      setState(() {
        _gender = null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.grey.shade200;
    if (_gender == 'male') {
      bgColor = Colors.blue.shade100;
    } else if (_gender == 'female') {
      bgColor = Colors.pink.shade100;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Predecir Género")),
      body: Container(
        color: bgColor,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Introduce un nombre para predecir el género:"),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final name = _controller.text.trim();
                if (name.isNotEmpty) {
                  _predictGender(name);
                }
              },
              child: const Text("Predecir"),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_gender != null)
              Column(
                children: [
                  Text("Género detectado para '$_name': $_gender"),
                  Icon(
                    _gender == 'male' ? Icons.male : Icons.female,
                    size: 100,
                    color: _gender == 'male' ? Colors.blue : Colors.pink,
                  ),
                ],
              )
            else
              const Text("No se pudo determinar el género."),
          ],
        ),
      ),
    );
  }
}
