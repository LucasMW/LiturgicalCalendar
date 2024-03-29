import 'package:flutter/material.dart';
import 'package:liturgical_calendar/api/liturgical_day.dart';

class CelebrationWidget extends StatelessWidget {
  final Celebrations celebration;

  const CelebrationWidget({Key? key, required this.celebration})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      //height: 30,
      color: celebration.getColor().withOpacity(0.1),
      child: Container(
        color: Colors.orange,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${celebration.title}',
            ),
            Text(
              '${celebration.rank}',
            ),
          ],
        ),
      ),
    );
  }
}
