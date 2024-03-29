import 'dart:convert';

import 'package:liturgical_calendar/api/http_wrapper.dart';
import 'package:liturgical_calendar/api/liturgical_day.dart';

class API {
  bool useProxy = true;
  String get todayUrl => useProxy
      ? 'https://menezesworks.com:8081/liturgy'
      : "http://calapi.inadiutorium.cz/api/v0/en/calendars/default/today";
  String get base => useProxy
      ? "https://menezesworks.com:8081/liturgy/"
      : "http://calapi.inadiutorium.cz/api/v0/";
  final req = "en/calendars/default/";

  Future<LiturgicalDay> getLiturgyToday() async {
    final jsonString = await HTTP.getJsonString(todayUrl);
    final jsonObj = json.decode(jsonString);
    final liturgy = LiturgicalDay.fromJson(jsonObj);
    return liturgy;
  }

  String _reverseDateString(String s) {
    return s.split('/').reversed.join('/');
  }

  Future<LiturgicalDay> getLiturgyFor(String dateString) async {
    final argumentStr = useProxy
        ? '$base${_reverseDateString(dateString)}' //proxy uses reversed format;
        : '$base$req$dateString';
    final jsonString = await HTTP.getJsonString(argumentStr);
    final jsonObj = json.decode(jsonString);
    final liturgy = LiturgicalDay.fromJson(jsonObj);
    return liturgy;
  }

  Future<List<LiturgicalDay>> getLiturgyForMonth(DateTime month) async {
    final dateString = "${month.year}/${month.month}/";
    final argumentStr = useProxy ? '$base$dateString' : '$base$req$dateString';
    //print(argumentStr);
    final jsonString = await HTTP.getJsonString(argumentStr);
    //print(jsonString);
    final jsonObj = json.decode(jsonString);
    List<LiturgicalDay> litMonth;
    litMonth = [];
    for (final litDay in jsonObj) {
      final liturgy = LiturgicalDay.fromJson(litDay);
      litMonth.add(liturgy);
    }
    return litMonth;
  }
}
