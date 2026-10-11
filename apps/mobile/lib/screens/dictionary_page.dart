import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DictionaryService {
  final String baseUrl;

  const DictionaryService({this.baseUrl = 'http://localhost:8000'});

  Future<Map<String, dynamic>> search(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/dictionary/search?q=${Uri.encodeQueryComponent(query)}'),
    );

    if (response.statusCode != 200) {
      throw Exception('Dictionary request failed: ${response.statusCode}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  final TextEditingController _controller = TextEditingController();
  final DictionaryService _service = const DictionaryService(baseUrl: 'http://localhost:8000');

  bool _loading = false;
  List<dynamic> _results = [];
  String? _error;

  Future<void> _search() async {
    final query = _controller.text.trim();
    if (query.isEmpty) {
      setState(() {
        _error = 'Masukkan kata yang ingin dicari.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await _service.search(query);
      final list = response['entries'] as List<dynamic>? ?? <dynamic>[];
      setState(() {
        _results = list;
      });
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat hasil kamus: $e';
        _results = [];
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kamus'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Cari kosakata Korea',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: _loading ? null : _search,
                  icon: const Icon(Icons.search_rounded),
                  label: const Text('Cari'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_loading)
              const CircularProgressIndicator()
            else if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red))
            else if (_results.isEmpty)
              const Text('Coba kata seperti 사랑, 공부, 한국어')
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final item = _results[index] as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(
                          item['word'] ?? 'kata',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${item['part_of_speech'] ?? 'kata'}\n${item['meaning'] ?? 'Tidak ada arti'}',
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
