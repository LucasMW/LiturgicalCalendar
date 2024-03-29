import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:liturgical_calendar/api/api.dart';
import 'package:liturgical_calendar/api/liturgical_month.dart';

import '01_2024.dart';

void main() {
  String strForNumber(int n) {
    if (n < 10) {
      return "0$n";
    }
    return "$n";
  }

  group('API Running?', () {
    final api = API();
    test("today", () async {
      final todayLit = await api.getLiturgyToday();
      final now = DateTime.now();

      expect(todayLit.date,
          "${now.year}-${strForNumber(now.month)}-${strForNumber(now.day)}");
    });
    test("Specific date", () async {
      final date = "2024/01/01";
      final lit = await api.getLiturgyFor(date);
      expect(lit.date, '2024-01-01');
      expect(lit.season, "christmas");
    });
    test('month', () async {
      final lit = await api.getLiturgyForMonth(DateTime(2024, 1));
      final litMonth = LiturgicalMonth.fromDays(lit);
      final json = january2024json;
      final list = jsonDecode(json);
      final expected = LiturgicalMonth.fromListDynamic(list);
      expect(expected.days.length, 31);
      expect(litMonth.days.length, 31);
      expect(litMonth.days.first, expected.days.first);
      expect(litMonth, expected);
    });
  });
  group("core", () {
    test('week', () {
      final json = january2024json;
      final list = jsonDecode(json);
      final expected = LiturgicalMonth.fromListDynamic(list);
      expected.getWeeks();
    });
  });
}
