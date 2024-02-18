import 'package:flutter/material.dart';
/*
ex.

*/
class Pill {
  String name;
  String takingTime;
  double takingCount;
  bool takingYN;
  TextEditingController controller;

  Pill(
      {required this.name,
      required this.takingTime,
      required this.takingCount,
      required this.takingYN,
      required this.controller});
}
