import 'package:flutter_riverpod/flutter_riverpod.dart';

class MedicineItemModel {
  String medicineId;
  String name;
  double? takeAmount;
  int? remainAmount; //남은양(몇일분)
  int? totalAmount;  //처방량(몇일분)
  String? takeUnit;
  String? memo;
  bool? selected;

  MedicineItemModel({
    required this.medicineId,
    required this.name,
    this.takeAmount,
    this.remainAmount,
    this.totalAmount,
    this.takeUnit,
    this.memo,
    this.selected,
  });



  MedicineItemModel copyWith({
    required String medicineId,
    required String name,
    double? takeAmount,
    int? remainAmount,
    int? totalAmount,
    String? takeUnit,
    String? memo,
    bool? selected,
  }) {
    return MedicineItemModel(
      medicineId: medicineId ?? this.medicineId,
      name: name ?? this.name,
      takeAmount: takeAmount ?? this.takeAmount,
      remainAmount : remainAmount ?? this.remainAmount,
      totalAmount : totalAmount ?? this.totalAmount,
      takeUnit: takeUnit ?? this.takeUnit,
      memo: memo ?? this.memo,
      selected: selected ?? this.selected,
    );
  }



  ///plan API에서 온 pills
  factory MedicineItemModel.fromJson({required Map<String, dynamic> json}) {
    return MedicineItemModel(
      medicineId: json['medicine_id'] ?? '',
      name: json['pill_name'] ?? '',
      takeAmount: json['take_amount'].toDouble() ?? 0.0,
      remainAmount: json['remain_amount'].toInt() ?? 0,
      totalAmount: json['total_amount'].toInt() ?? 0,
      takeUnit: json['take_unit'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'medicine_id': medicineId,
    'name': name,
    'memo': memo,
    'take_amount' : takeAmount,
    'remain_amount' : remainAmount,
    'total_amount' : totalAmount,
    'take_unit' : takeUnit
  };
}
