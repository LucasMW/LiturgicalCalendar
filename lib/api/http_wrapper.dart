import 'package:liturgical_calendar/api/api_cache.dart';

class HTTP {
  static APICache cache = APICache(Duration(minutes: 30));

  static Future<String> getJsonString(String str) async {
    final date = DateTime.now();
    //final url = Uri.parse(str);
    final response = await cache.get(str);
    final ms = (DateTime.now().difference(date)).inMilliseconds;
    print("[${response.statusCode}] $str took $ms ms");
    return response.body;
  }
}
