import 'package:flutter/material.dart';
import 'package:liturgical_calendar/api/liturgical_month.dart';
import 'package:liturgical_calendar/translation/translation_service.dart';

class LiturgicalDay {
  String? date;
  String? season;
  int? seasonWeek;
  late List<Celebrations> celebrations;
  String? weekday;

  bool get isToday {
    if (date == null) return false;
    final split = date!.split('-');
    int day = int.parse(split.last);
    int month = int.parse(split[1]);
    int year = int.parse(split.first);

    final now = DateTime.now();
    return day == now.day && month == now.month && year == now.year;
  }

  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LiturgicalDay &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          other.seasonWeek == seasonWeek &&
          other.celebrations.length == celebrations.length &&
          other.weekday == weekday;

  LiturgicalDay(
      {required this.date,
      required this.season,
      required this.seasonWeek,
      required this.celebrations,
      required this.weekday});

  DateTime? getDate() {
    return DateTime.tryParse(date ?? "");
  }

  LiturgicalDay.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    season = json['season'];
    seasonWeek = json['season_week'];
    if (json['celebrations'] != null) {
      celebrations = [];
      json['celebrations'].forEach((v) {
        celebrations.add(new Celebrations.fromJson(v));
      });
    }
    weekday = json['weekday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['season'] = this.season;
    data['season_week'] = this.seasonWeek;
    if (this.celebrations != null && this.celebrations.isNotEmpty) {
      data['celebrations'] = this.celebrations.map((v) => v.toJson()).toList();
    }
    data['weekday'] = this.weekday;
    return data;
  }

  @override
  int get hashCode {
    if (date == null) return -1;
    final split = date!.split('-');
    int year = int.parse(split.first);
    int month = int.parse(split[1]);
    return 100 * year + month;
  }
}

class Celebrations {
  String? title;
  String? colour;
  String? rank;
  double? rankNum;

  String get translatedTitle {
    return title ?? "";
    if (rank == 'ferial' || rank == 'Sunday') return "";
    //return "$rank $rankNum";
    return TranslationService.translateTitle(title ?? "???", "pt");
  }

  Celebrations(
      {required this.title,
      required this.colour,
      required this.rank,
      required this.rankNum});

  Color getColor() {
    switch (colour) {
      case "green":
        return Colors.green;
      case "red":
        return Colors.red;
      case "violet":
        if (title == "4th Sunday of Lent" || title == "3rd Sunday of Advent")
          return Color.fromARGB(255, 226, 141, 229);
        return Colors.deepPurple;
      case "white":
        return Colors.white;
      default:
        print("not found color $colour; Used default");
        return Colors.blue;
    }
  }

  Celebrations.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    colour = json['colour'];
    rank = json['rank'];
    rankNum = json['rank_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['colour'] = this.colour;
    data['rank'] = this.rank;
    data['rank_num'] = this.rankNum;
    return data;
  }
}
