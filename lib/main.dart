import 'package:flutter/material.dart';
import 'package:liturgical_calendar/app.dart';
import 'package:liturgical_calendar/translation/translation_service.dart';

void main() {
  runApp(MyApp());
  TranslationService.load();
}
