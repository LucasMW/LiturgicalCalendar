import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TranslationService {
  static List<String> enLines = [];
  static List<String> ptLines = [];
  static Future<void> load() async {
    //print("loading");
    final en_path = "assets/data/universal_en.txt";
    final pt_path = "assets/data/universal_pt.txt";
    final enFile = await rootBundle.loadString(en_path);
    enLines = enFile.substring(enFile.indexOf("=")).split("\n");
    //print(enLines);
    final ptFile = await rootBundle.loadString(pt_path);
    ptLines = ptFile.substring(ptFile.indexOf("=")).split("\n");
    if (enLines.length == ptLines.length) {
      for (int i = 0; i < enFile.length; i++) {
        enLines[i] = enLines[i].split(":").last.trim();
        ptLines[i] = ptLines[i].split(":").last.trim();
      }
      print(enLines);
      print(ptLines);
    } else {
      for (int i = 0; i < enLines.length; i++) {
        enLines[i] = enLines[i].split(":").last.trim();
        ptLines[i] = ptLines[i].split(":").last.trim();
      }
      print("incorrect lenght ${enLines.length} vs ${ptLines.length}");
    }
    print("loaded");
  }

  static String translateTitle(String title, String lang) {
    switch (lang) {
      case "pt":
        final idx = enLines.indexWhere((element) =>
            element.toLowerCase().trim() == title.toLowerCase().trim());
        if (idx != -1) {
          return ptLines[idx];
        }
        print("failed once $title");
        final sIdx = enLines.indexWhere((element) => element.contains(title));
        if (sIdx != -1) {
          return ptLines[idx];
        }
        print("failed twice $title");
        return title;

      default:
        print("unrecognized lang $lang");
        return title;
    }
  }
}
