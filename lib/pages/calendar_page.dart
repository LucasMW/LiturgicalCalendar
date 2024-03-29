import 'package:flutter/material.dart';
import 'package:liturgical_calendar/api/api.dart';
import 'package:liturgical_calendar/api/liturgical_day.dart';
import 'package:liturgical_calendar/api/liturgical_month.dart';

import 'package:liturgical_calendar/components/week_widget.dart';
import 'package:liturgical_calendar/extensions/date_helper.dart';

class CalendarPage extends StatefulWidget {
  final LiturgicalDay day;
  final LiturgicalMonth month;
  final DateTime lastAccessedDate;

  const CalendarPage(
      {Key? key,
      required this.day,
      required this.month,
      required this.lastAccessedDate})
      : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  LiturgicalDay? day;
  LiturgicalMonth? month;
  DateTime? lastAccessedDate;
  bool loadingMonth = false;
  LiturgicalDay? selectedDay;

  @override
  void initState() {
    day = widget.day;
    month = widget.month;
    lastAccessedDate = widget.lastAccessedDate;
    prepareMonth();
    super.initState();
  }

  void prepareMonth() {
    API().getLiturgyForMonth(DateTime.now()).then((value) {
      setState(() {
        month = LiturgicalMonth.fromDays(value);
      });
      //prepareCaches();
    });
  }

  @override
  Widget build(BuildContext context) {
    final monthlyCalendar = month != null
        ? Column(
            children: [
              Row(children: [
                IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: () {
                      lastAccessedDate = lastAccessedDate!.getPreviousMonth();
                      setState(() {
                        loadingMonth = true;
                      });
                      API().getLiturgyForMonth(lastAccessedDate!).then((value) {
                        setState(() {
                          loadingMonth = false;
                          month = LiturgicalMonth.fromDays(value);
                        });
                      });
                    }),
                IconButton(
                    icon: Icon(Icons.arrow_right),
                    onPressed: () {
                      lastAccessedDate =
                          lastAccessedDate = lastAccessedDate!.getNextMonth();
                      setState(() {
                        loadingMonth = true;
                      });
                      API().getLiturgyForMonth(lastAccessedDate!).then((value) {
                        setState(() {
                          loadingMonth = false;
                          month = LiturgicalMonth.fromDays(value);
                        });
                      });
                    }),
                Text("${lastAccessedDate?.month}/${lastAccessedDate?.year}"),
                loadingMonth
                    ? Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          CircularProgressIndicator.adaptive(),
                        ],
                      )
                    : Container()
              ]),
              MonthWidget(
                  month: month!,
                  onSelectedDay: ((day) {
                    setState(() {
                      this.day = day;
                    });
                  }),
                  selectedDay: day),
            ],
          )
        : Text("Couldn't load month correctly");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade100,
        title: Text("Monthly Calendar"),
      ),
      body: Container(
        color: Colors.indigo.shade50,
        child: Column(
          children: [
            Container(
              //height: 30,
              child: Row(
                children: [
                  Text("Selected: "),
                  Text("${day?.date ?? "??"}"),
                  DayWidget(day: day)
                ],
              ),
            ),
            Expanded(child: monthlyCalendar),
          ],
        ),
      ),
    );
  }
}
