import 'package:liturgical_calendar/api/liturgical_day.dart';

class LiturgicalMonth {
  List<LiturgicalDay> days = [];

  LiturgicalMonth.fromDays(List<LiturgicalDay> days) {
    this.days = days; //this is necessary here
  }

  LiturgicalDay nextHolyDay(LiturgicalDay day) {
    final next = days.firstWhere(
      (element) =>
          element.getDate()!.isAfter(day.getDate()!) &&
          element.celebrations
              .where((element) =>
                  element.rank == 'Sunday' || element.rankNum! < 2.7)
              .isNotEmpty,
      orElse: () {
        print("Look NextMonth");
        return day;
      },
    );
    print(next.toJson());
    return next;
  }

  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (!(other is LiturgicalMonth && runtimeType == other.runtimeType))
      return false;
    LiturgicalMonth otherMonth = other;
    if (otherMonth.days.length != days.length) return false;
    for (int i = 0; i < days.length; i++) {
      if (days[i] != otherMonth.days[i]) return false;
    }
    return true;
  }

  LiturgicalWeek getWeekForDay(LiturgicalDay day) {
    final weeks = getWeeks();
    final week = weeks.firstWhere((element) => element.isCurrentWeek);
    return week;
  }

  List<LiturgicalWeek> getWeeks() {
    List<LiturgicalWeek> weeks = [];

    final index1 = days.indexWhere((element) => element.weekday == 'sunday');
    final index2 = index1 + 7;
    final index3 = index2 + 7;
    final index4 = index3 + 7;
    final index5 = index4 + 7;
    final indexLast = days.length;
    final index0 = 0;
    if (index0 == index1) {
      //print('warning!');
      //print(days.length);
      //print('$index4-$indexLast');
      weeks
          .add(LiturgicalWeek.fromDays(days.getRange(index1, index2).toList()));
      weeks
          .add(LiturgicalWeek.fromDays(days.getRange(index2, index3).toList()));
      weeks
          .add(LiturgicalWeek.fromDays(days.getRange(index3, index4).toList()));
      weeks
          .add(LiturgicalWeek.fromDays(days.getRange(index4, index5).toList()));
      weeks.add(
          LiturgicalWeek.fromDays(days.getRange(index5, indexLast).toList()));
    } else {
      weeks
          .add(LiturgicalWeek.fromDays(days.getRange(index0, index1).toList()));
      weeks
          .add(LiturgicalWeek.fromDays(days.getRange(index1, index2).toList()));
      weeks
          .add(LiturgicalWeek.fromDays(days.getRange(index2, index3).toList()));
      weeks
          .add(LiturgicalWeek.fromDays(days.getRange(index3, index4).toList()));

      if (index5 < indexLast) {
        weeks.add(
            LiturgicalWeek.fromDays(days.getRange(index4, index5).toList()));
        weeks.add(
            LiturgicalWeek.fromDays(days.getRange(index5, indexLast).toList()));
      } else {
        weeks.add(
            LiturgicalWeek.fromDays(days.getRange(index4, indexLast).toList()));
      }
    }

    return weeks;
  }

  LiturgicalMonth.fromListDynamic(List<dynamic> list) {
    days = list.map((e) => LiturgicalDay.fromJson(e)).toList();
  }

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

  @override
  int get hashCode {
    if (days.isEmpty || days.first.date == null) return -1;
    final split = days.first.date!.split('-');
    int year = int.parse(split.first);
    int month = int.parse(split[1]);
    return 100 * year + month;
  }
}

class LiturgicalWeek {
  late List<LiturgicalDay> days;

  LiturgicalWeek.fromDays(List<LiturgicalDay> days) {
    this.days = days;
  }
  LiturgicalWeek.fromJson(Map<String, dynamic> json) {
    if (json['days'] != null) {
      json['days'].forEach((v) {
        days.add(LiturgicalDay.fromJson(v));
      });
    }
  }

  bool get isCurrentWeek {
    for (final day in this.days) {
      if (day.isToday) return true;
    }
    return false;
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
  late List<LiturgicalMonth> months;
  int? number;

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

LiturgicalDay nextHolyDay(LiturgicalDay day, List<LiturgicalDay> searchSpace) {
  final next = searchSpace.firstWhere(
    (element) =>
        element.getDate()!.isAfter(day.getDate()!) &&
        element.celebrations
            .where(
                (element) => element.rank == 'Sunday' || element.rankNum! < 2.7)
            .isNotEmpty,
  );
  print(next.toJson());
  return next;
}
