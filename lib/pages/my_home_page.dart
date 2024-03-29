import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liturgical_calendar/api/api.dart';
import 'package:liturgical_calendar/api/liturgical_day.dart';
import 'package:liturgical_calendar/api/liturgical_month.dart';
import 'package:liturgical_calendar/components/celebration.dart';
import 'package:liturgical_calendar/components/review_util.dart';
import 'package:liturgical_calendar/components/week_widget.dart';
import 'package:liturgical_calendar/pages/calendar_page.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LiturgicalDay? day;
  LiturgicalMonth? month;
  DateTime? lastAccessedDate;
  bool loadingMonth = false;
  LiturgicalDay? nextHolyDay;

  @override
  void initState() {
    super.initState();
    lastAccessedDate = DateTime.now();
    API().getLiturgyToday().then((value) {
      setState(() {
        day = value;
      });
      prepareMonth();
    });
  }

  void prepareCaches() {
    DateTime now = DateTime.now();
    for (int i = 1; i < 12; i++) {
      final previous = now.subtract(Duration(days: 20 * i));
      final later = now.add(Duration(days: 20 * i));
      API().getLiturgyForMonth(previous);
      API().getLiturgyForMonth(later);
      print("caching $i/12");
    }
    print("caching finished");
  }

  void prepareMonth() {
    API().getLiturgyForMonth(DateTime.now()).then((value) {
      setState(() {
        month = LiturgicalMonth.fromDays(value);
      });
      nextHolyDay = month?.nextHolyDay(day!);
      prepareCaches();
    });
  }

  void getThisWeek() {
    final week = month!.getWeekForDay(day!);
    if (week.days.length < 7) {
      final date = week.days.first.getDate()!;
      final day = date.day;
      final month = date.month;
      if (week.days.first.getDate()!.day == 1) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    //context.findAncestorStateOfType<_MyHomePageState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade100,
        title: Text(widget.title),
      ),
      body: Container(
        color: Colors.indigo.shade50,
        child: Center(
          child: day != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                        color: day?.celebrations.first.getColor(), height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Today: '),
                        Text(
                          '${day?.date}',
                        ),
                        Text(
                          '${day?.season}',
                        ),
                        Text(
                          '${day?.weekday}',
                        ),
                      ],
                    ),
                    Container(
                      height: 50,
                      child: ListView.builder(
                        itemCount: day?.celebrations.length,
                        itemBuilder: (BuildContext context, int index) {
                          return day?.celebrations == null
                              ? Text("Celebrations couldn't load.")
                              : CelebrationWidget(
                                  celebration: day!.celebrations[index]);
                        },
                      ),
                    ),
                    // month != null
                    //     ? WeekWidget(
                    //         week: month!.getWeeks().firstWhere(
                    //             (element) => element.isCurrentWeek))
                    //     : Text("error"),

                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Next Holy Day of Obligation:",
                            style: TextStyle(fontSize: 17),
                          ),
                          nextHolyDay != null
                              ? Row(
                                  children: [
                                    // DayWidget(day: null),
                                    // DayWidget(day: null),
                                    DayWidget(day: nextHolyDay),
                                    // DayWidget(day: null),
                                    // DayWidget(day: null)
                                  ],
                                )
                              : Text("Couldn't load"),
                        ],
                      ),
                    ),

                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "This Week:",
                            style: TextStyle(fontSize: 17),
                          ),
                          month != null
                              ? WeekWidget(
                                  selectedDay: day,
                                  week: month!.getWeeks().firstWhere(
                                      (element) => element.isCurrentWeek))
                              : Text("Full week could not be loaded"),
                        ],
                      ),
                    ),

                    ElevatedButton(
                        onPressed: month != null &&
                                day != null &&
                                lastAccessedDate != null
                            ? () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CalendarPage(
                                              lastAccessedDate:
                                                  lastAccessedDate!,
                                              month: month!,
                                              day: day!,
                                            )));
                              }
                            : null,
                        child: Text("See full calendar")),
                    Flexible(
                      flex: 1,
                      child: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              initialDate: lastAccessedDate,
                              firstDate: DateTime(1990),
                              lastDate: DateTime(2028),
                            ).then((date) {
                              if (date == null) return;
                              setState(() {
                                day = null;
                              });
                              final dateStr =
                                  "${date.year}/${date.month}/${date.day}";
                              print(dateStr);
                              API().getLiturgyFor(dateStr).then((liturgy) {
                                setState(() {
                                  day = liturgy;
                                  lastAccessedDate = date;
                                  nextHolyDay = month?.nextHolyDay(day!);
                                });
                              });
                            });
                          }),
                    ),
                    kIsWeb
                        ? Column(
                            children: [
                              Text("Download it now!"),
                              TextButton(
                                  onPressed: () {
                                    final appstorePage =
                                        "https://apps.apple.com/us/app/liturgy-calendar/id6478806238";
                                    print("pressed");
                                    launchUrlString(appstorePage).then((value) {
                                      print("could launch $value");
                                    });
                                  },
                                  child: SvgPicture.asset(
                                      "assets/download_buttons/macStore.svg",
                                      semanticsLabel: 'App Store Logo'))
                            ],
                          )
                        : ReviewButton(appId: "6478806238")
                  ],
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
