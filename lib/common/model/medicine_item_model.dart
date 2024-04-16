import 'package:flutter_riverpod/flutter_riverpod.dart';

class MedicineItemModel {
  String medicineId;
  String name;
  int? takeAmount;
  String? takeUnit;
  String? memo;
  bool? selected;

  MedicineItemModel({
    required this.medicineId,
    required this.name,
    this.takeAmount,
    this.takeUnit,
    this.memo,
    this.selected,
  });

  MedicineItemModel copyWith({
    required String medicineId,
    required String name,
    int? takeAmount,
    String? takeUnit,
    String? memo,
    bool? selected,
  }) {
    return MedicineItemModel(
      medicineId: medicineId ?? this.medicineId,
      name: name ?? this.name,
      takeAmount: takeAmount ?? this.takeAmount,
      takeUnit: takeUnit ?? this.takeUnit,
      memo: memo ?? this.memo,
      selected: selected ?? this.selected,
    );
  }

  Map<String, dynamic> toJson() => {
    'medicine_id': medicineId,
    'name': name,
    'memo': memo,
    'take_amount' : takeAmount,
    'take_unit' : takeUnit
  };
}
