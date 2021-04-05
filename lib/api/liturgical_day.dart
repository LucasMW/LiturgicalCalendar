import 'package:flutter/material.dart';

class LiturgicalDay {
  String date;
  String season;
  int seasonWeek;
  List<Celebrations> celebrations;
  String weekday;

  LiturgicalDay(
      {this.date,
      this.season,
      this.seasonWeek,
      this.celebrations,
      this.weekday});

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
    if (this.celebrations != null) {
      data['celebrations'] = this.celebrations.map((v) => v.toJson()).toList();
    }
    data['weekday'] = this.weekday;
    return data;
  }
}

class Celebrations {
  String title;
  String colour;
  String rank;
  double rankNum;

  Celebrations({this.title, this.colour, this.rank, this.rankNum});

  Color getColor() {
    switch (colour) {
      case "green":
        return Colors.green;
      case "red":
        return Colors.red;
      case "violet":
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
