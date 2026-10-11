import 'dart:convert';

import 'package:http/http.dart' as http;

class DictionaryApi {
  final String baseUrl;

  const DictionaryApi({this.baseUrl = 'http://localhost:8000'});

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
