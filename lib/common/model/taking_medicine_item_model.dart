import 'package:flutter/material.dart';
/*
ex.

*/
class TakingMedicineItem {
  String name;
  DateTime takingTime;
  double takingCount;
  bool takingYN;
  TextEditingController controller;

  TakingMedicineItem(
      {required this.name,
      required this.takingTime,
      required this.takingCount,
      required this.takingYN,
      required this.controller});
}
