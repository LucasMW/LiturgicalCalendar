import 'package:flutter/material.dart';
import 'package:liturgical_calendar/api/liturgical_day.dart';
import 'package:liturgical_calendar/api/liturgical_month.dart';
import 'package:liturgical_calendar/components/celebration.dart';
import 'package:liturgical_calendar/components/celebrations_widget.dart';

class DayWidget extends StatelessWidget {
  final LiturgicalDay? day;
  final Function(LiturgicalDay day)? onSelected;
  final bool isSelected;

  const DayWidget(
      {Key? key, required this.day, this.onSelected, this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (day == null) {
      return Expanded(
        child: Container(
          height: 100, //60 + 25 + 10 +5
          color: Colors.transparent, //Colors.black12,
          //child: Text('null'),
        ),
      );
    }
    final celebs = day?.celebrations
        .map(((e) => Container(
              height: 80,
              color: Colors.white70, //e.getColor(),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          e.translatedTitle ?? "??",
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  //Text(e.rank ?? "?"),
                ],
              ),
            )))
        .toList();
    return Flexible(
      child: GestureDetector(
        onTap: () {
          print("selected ${day?.date}");
          if (onSelected != null && day != null && day!.date != null) {
            onSelected!(day!);
          }
        },
        child: Container(
          color: day!.celebrations.first.getColor().withOpacity(0.8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: isSelected
                        ? Colors.amber
                        : Colors
                            .transparent // day!.isToday ? Colors.amber : Colors.transparent,
                    ),
                width: 25,
                height: 25,
                child: Center(
                  child: Text(
                    day!.date!.split('-').last,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                            day!.isToday ? FontWeight.bold : FontWeight.normal),
                  ),
                ),
              ),
              Container(
                  color: Colors.white60,
                  child: CelebrationsWidget(celebrations: day!.celebrations)),
              Container(
                height: 60,
                child: ListView(
                  physics: ScrollPhysics(),
                  children: celebs!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeekWidget extends StatelessWidget {
  final LiturgicalWeek week;
  final Function(LiturgicalDay day)? onSelectedDay;
  final LiturgicalDay? selectedDay;
  const WeekWidget(
      {Key? key, required this.week, this.onSelectedDay, this.selectedDay})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DayWidget> days = [];
    //if (week.days.length < 7) {}
    if (week.days.length < 7) {
      //print('problem');
      if (week.days.isEmpty) {
        //print('error');
        return Text('error');
      }
      if (week.days.first.weekday == 'sunday') //end
      {
        //print('sunday');
        for (int i = 0; i < week.days.length; i++) {
          //print(week.days[i].date);
          days.add(DayWidget(
            day: week.days[i],
            onSelected: onSelectedDay,
            isSelected: week.days[i] == selectedDay,
          ));
        }
        for (int i = week.days.length; i < 7; i++) {
          days.add(DayWidget(day: null));
        }
      } else //beginning
      {
        //print('beginning');
        final date = DateTime.parse(week.days.first.date ?? '');
        final count = date.weekday;
        //print(week.days.first.date);
        //print(date.weekday);
        //print(days.length);
        for (int i = 0; i < count; i++) {
          days.add(DayWidget(day: null));
        }
        for (int i = 0; i < week.days.length; i++) {
          //print(week.days[i].date);
          days.add(DayWidget(
            day: week.days[i],
            onSelected: onSelectedDay,
            isSelected: week.days[i] == selectedDay,
          ));
        }
      }
      //print(days.length);
    } else {
      //print('pika');
      for (int i = 0; i < 7; i++) {
        //final day = DayWidget(day: week.days[i]);
        days.add(DayWidget(
            day: week.days[i],
            onSelected: onSelectedDay,
            isSelected: week.days[i] == selectedDay));
      }
    }

    return Row(children: days);
  }
}

class MonthWidget extends StatelessWidget {
  final LiturgicalMonth month;
  final Function(LiturgicalDay day)? onSelectedDay;
  final LiturgicalDay? selectedDay;
  const MonthWidget(
      {Key? key, required this.month, this.onSelectedDay, this.selectedDay})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fit = BoxFit.scaleDown;
    final weeks = month.getWeeks().map((e) {
      return WeekWidget(
        week: e,
        onSelectedDay: onSelectedDay,
        selectedDay: selectedDay,
      );
    }).toList();
    return Expanded(
      child: SingleChildScrollView(
        child: Column(children: [
          Container(
            color: Colors.grey.shade100,
            child: Row(
              children: [
                Expanded(
                    child: FittedBox(
                  child: Text('S'),
                  fit: fit,
                )),
                Expanded(child: FittedBox(child: Text('M'), fit: fit)),
                Expanded(child: FittedBox(child: Text('T'), fit: fit)),
                Expanded(child: FittedBox(child: Text('W'), fit: fit)),
                Expanded(child: FittedBox(child: Text('T'), fit: fit)),
                Expanded(child: FittedBox(child: Text('F'), fit: fit)),
                Expanded(child: FittedBox(child: Text('S'), fit: fit)),
              ],
            ),
          ),
          ...weeks
        ]),
      ),
    );
  }
}
