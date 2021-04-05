import 'package:flutter/material.dart';
import 'package:liturgical_calendar/api/api.dart';
import 'package:liturgical_calendar/api/liturgical_day.dart';
import 'package:liturgical_calendar/celebration.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liturgical Calendar',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'Liturgical Calendar'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LiturgicalDay day;
  DateTime lastAccessedDate;

  @override
  void initState() {
    super.initState();
    lastAccessedDate = DateTime.now();
    API().getLiturgyToday().then((value) {
      setState(() {
        day = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    context.findAncestorStateOfType<_MyHomePageState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        color: Colors.indigo.shade50,
        child: Center(
          child: day != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        color: day.celebrations.first.getColor(), height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '${day.date}',
                        ),
                        Text(
                          '${day.season}',
                        ),
                        Text(
                          '${day.weekday}',
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Text(
                          //   'Found ${day.celebrations.length} celebrations',
                          // ),
                          Container(height: 20),
                          Expanded(
                            flex: 2,
                            child: ListView.builder(
                              itemCount: day.celebrations.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CelebrationWidget(
                                    celebration: day.celebrations[index]);
                              },
                            ),
                          ),
                          Expanded(
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
                                    API()
                                        .getLiturgyFor(dateStr)
                                        .then((liturgy) {
                                      setState(() {
                                        day = liturgy;
                                        lastAccessedDate = date;
                                      });
                                    });
                                  });
                                }),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              : CircularProgressIndicator(),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
