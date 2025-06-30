import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class WordPressNewsView extends StatefulWidget {
  const WordPressNewsView({super.key});

  @override
  State<WordPressNewsView> createState() => _WordPressNewsViewState();
}

class _WordPressNewsViewState extends State<WordPressNewsView> {
  bool _isLoading = true;
  List<dynamic> _posts = [];

  Future<void> _fetchPosts() async {
    setState(() {
      _isLoading = true;
    });

    // Ejemplo con blog de Kinsta (puedes cambiar URL si quieres)
    final url = Uri.parse('https://kinsta.com/wp-json/wp/v2/posts?per_page=3');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        _posts = json;
        _isLoading = false;
      });
    } else {
      setState(() {
        _posts = [];
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el enlace')),
      );
    }
  }

  String parseHtmlString(String htmlString) {
    // Remueve etiquetas HTML simples para mostrar texto plano
    return htmlString.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Noticias WordPress")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(post['title']['rendered']),
                    subtitle:
                        Text(parseHtmlString(post['excerpt']['rendered'])),
                    trailing: IconButton(
                      icon: const Icon(Icons.open_in_new),
                      onPressed: () {
                        _launchURL(post['link']);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
