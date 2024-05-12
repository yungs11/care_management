import 'dart:ffi';

import 'package:flutter/material.dart';

/*
ex.

*/
class TakingMedicineItem {
  final String prescriptionItemId;
  final String pillName;
  final String medicineId;
  final String takeUnit;
  double takeAmount;
  int remainAmount; //남은양(몇일분)
  int totalAmount;  //처방량(몇일분)
  final String takeHistoryItemId;
  bool takeStatus;
  DateTime? takingTime;
  final TextEditingController controller;

  TakingMedicineItem({
    required this.prescriptionItemId,
    required this.pillName,
    required this.medicineId,
    required this.takeUnit,
    required this.takeAmount,
    required this.remainAmount,
    required this.totalAmount,
    required this.takeHistoryItemId,
    required this.takeStatus,
    this.takingTime,
    required this.controller,
  });

  factory TakingMedicineItem.fromJson({required Map<String, dynamic> json}) {
    print('@@TakingMedicineItem.fromJson@@');
    print(json);
    print(json['take_amount']);

    return TakingMedicineItem(
      prescriptionItemId: json['prescription_item_id'] ?? '',
      pillName: json['pill_name'] ?? '',
      medicineId: json['medicine_id'] ?? '',
      takeUnit: json['take_unit'] ?? '',
      takeAmount: json['take_amount'].toDouble() ?? 0.0,
      remainAmount: json['remain_amount'].toInt() ?? 0,
      totalAmount: json['total_amount'].toInt() ?? 0,
      takeHistoryItemId: json['take_history_item_id'] ?? '',
      takeStatus: json['take_status'] ?? false,
      takingTime: json['take_date'] != null ?  DateTime.parse(json['take_date']) : DateTime(0),
      controller: TextEditingController(text: json['take_amount'].toString()),
    );
  }
}
