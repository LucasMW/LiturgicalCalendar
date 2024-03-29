import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ReviewButton extends StatelessWidget {
  final String appId;
  const ReviewButton({Key? key, required this.appId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final url = "https://apps.apple.com/app/id$appId?action=write-review";
    if (Platform.isMacOS || Platform.isMacOS) {
      return ElevatedButton(
          onPressed: () {
            launchUrlString(url);
          },
          child: Text("Review app"));
    }
    return Container();
  }
}
