import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BreakModel {
  String name;
  FaIconData icon;
  Color color;
  String time;
  String? taken;
  String type;

  BreakModel({
    required this.name,
    required this.icon,
    required this.color,
    required this.time,
    required this.taken,
    required this.type,
  });
}

class DetailedBreakModel {
  String name;
  FaIconData icon;
  Color color;
  String time, startedAt, endedAT, reason;

  DetailedBreakModel({
    required this.name,
    required this.icon,
    required this.color,
    required this.time,
    required this.startedAt,
    required this.endedAT,
    required this.reason,
  });
}
