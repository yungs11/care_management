import 'package:flutter/material.dart';

class TimezoneModel {
  final String id;
  final String name;
  final String hour;
  final String midday;
  final String minute;
  final String title;
//  final bool useAlert;
  final TextEditingController controller;


  TimezoneModel({
    required this.id,
    required this.name,
    required this.hour,
    required this.midday,
    required this.minute,
    required this.title,
    required this.controller,
  });
}
