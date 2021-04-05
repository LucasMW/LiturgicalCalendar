import 'dart:convert';

import 'package:liturgical_calendar/api/http_wrapper.dart';
import 'package:liturgical_calendar/api/liturgical_day.dart';

class API {
  final todayUrl =
      "http://calapi.inadiutorium.cz/api/v0/en/calendars/default/today";
  final base = "http://calapi.inadiutorium.cz/api/v0/";
  final req = "en/calendars/default/";

  Future<LiturgicalDay> getLiturgyToday() async {
    final jsonString = await HTTP.getJsonString(todayUrl);
    final jsonObj = json.decode(jsonString);
    final liturgy = LiturgicalDay.fromJson(jsonObj);
    return liturgy;
  }

  Future<LiturgicalDay> getLiturgyFor(String dateString) async {
    final argumentStr = '$base$req$dateString';
    final jsonString = await HTTP.getJsonString(argumentStr);
    final jsonObj = json.decode(jsonString);
    final liturgy = LiturgicalDay.fromJson(jsonObj);
    return liturgy;
  }

  Future<List<LiturgicalDay>> getLiturgyForMonth(DateTime month) async {
    final dateString = "${month.year}/${month.month}";
    final argumentStr = '$base$req$dateString';
    final jsonString = await HTTP.getJsonString(argumentStr);
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
