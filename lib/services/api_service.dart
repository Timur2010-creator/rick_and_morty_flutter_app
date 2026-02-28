import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/character.dart';

class ApiService {
  static const String baseUrl = "https://rickandmortyapi.com/api";

  static Future<List<Character>> fetchCharacters({int page = 1, String query = ""}) async {
    final url = query.isEmpty
        ? "$baseUrl/character?page=$page"
        : "$baseUrl/character?name=$query&page=$page";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List results = data['results'];
      return results.map((c) => Character.fromJson(c)).toList();
    } else {
      throw Exception("Failed to load characters");
    }
  }
}
