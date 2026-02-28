import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';

class ApiService {
  static const String baseUrl = "https://rickandmortyapi.com/api";

  static Future<List<Character>> fetchCharacters(int page) async {
    final response = await http.get(Uri.parse("$baseUrl/character?page=$page"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List results = data['results'];
      return results.map((c) => Character.fromJson(c)).toList();
    } else {
      throw Exception("Failed to load characters");
    }
  }
}
