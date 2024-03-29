import 'package:flutter/material.dart';
import 'package:liturgical_calendar/api/liturgical_day.dart';

class CelebrationsWidget extends StatelessWidget {
  final List<Celebrations> celebrations;
  const CelebrationsWidget({Key? key, required this.celebrations})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //if (celebrations.length <= 1) return Container();
    return Row(
        children: celebrations
            .map((e) => Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        color: e.getColor().withAlpha(244),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ))
            .toList());
  }
}
