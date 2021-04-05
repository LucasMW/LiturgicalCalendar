import 'package:liturgical_calendar/api/liturgical_day.dart';

class LiturgicalMonth {
  List<LiturgicalDay> days;
  LiturgicalMonth.fromJson(Map<String, dynamic> json) {
    if (json['days'] != null) {
      json['days'].forEach((v) {
        days.add(LiturgicalDay.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.days != null) {
      data['days'] = this.days.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LiturgicalYear {
  List<LiturgicalMonth> months;
  int number;
  LiturgicalYear.fromJson(Map<String, dynamic> json) {
    if (json['months'] != null) {
      json['months'].forEach((v) {
        months.add(LiturgicalMonth.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.months != null) {
      data['months'] = this.months.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
