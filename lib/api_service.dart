import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<String>> getMeanings(String word) async {
    final url = Uri.parse(
      "https://api.dictionaryapi.dev/api/v2/entries/en/$word",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        List<String> meanings = [];

        for (var meaning in data[0]["meanings"]) {
          for (var def in meaning["definitions"]) {
            meanings.add(def["definition"]);
          }
        }

        return meanings;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
