import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:liturgical_calendar/pages/my_home_page.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final app = MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Liturgical Calendar',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'Liturgical Calendar'),
      onGenerateRoute: ((settings) {
        print(settings.name);
        var startParamIndex = settings.name?.indexOf('=');
        var fragmentEndIndex = settings.name?.indexOf('?');
        if (settings.name != null &&
            startParamIndex != -1 &&
            startParamIndex != null &&
            settings.name?.substring(0, fragmentEndIndex) == '/submitted') {
          var name = settings.name!;
          var queryParameter =
              name.substring(startParamIndex).replaceFirst('=', '');
          return MaterialPageRoute(
              builder: (_) => MyHomePage(title: '$queryParameter'));
        } else {
          return MaterialPageRoute(
              builder: (_) => MyHomePage(title: '${settings.toString()}'));
        }
      }),
      // routes: {
      //   '/': (context) => MyHomePage(
      //         title: 'Liturgical Calendar /',
      //       ),
      //   '/details': (context) => MyHomePage(
      //         title: 'Liturgical Calendar /',
      //       ),
      // },
    );
    return app;
  }
}
