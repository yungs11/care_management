import 'package:flutter/material.dart';
/*
ex.

*/
class Medicine {
  String name;
  String takingTime;
  double takingCount;
  bool takingYN;
  TextEditingController controller;

  Medicine(
      {required this.name,
      required this.takingTime,
      required this.takingCount,
      required this.takingYN,
      required this.controller});
}
