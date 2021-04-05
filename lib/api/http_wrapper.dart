import 'package:http/http.dart' as http;

class HTTP {
  static Future<String> getJsonString(String str) async {
    final url = Uri.parse(str);
    final response = await http.get(url);
    return response.body;
  }
}
