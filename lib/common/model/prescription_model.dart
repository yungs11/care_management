import 'package:care_management/common/model/medicine_item_model.dart';
import 'package:care_management/common/model/timezone_box_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final prescriptionProvider =
    StateNotifierProvider<PrescriptionNotifier, PrescriptionModel>(
        (ref) => PrescriptionNotifier());

class PrescriptionModel {
  final String? prescriptionName;
  final String? hospitalName;
  final String? startedAt;
  final int? takeDays;
//final DateTime finishedAt;
  final List<TimezonBoxModel>? items;
  //final String? memo;

  PrescriptionModel({
    this.prescriptionName,
    this.hospitalName,
    this.startedAt,
    this.takeDays,
    this.items,
    //this.memo,
  });

  PrescriptionModel copyWith({
    String? prescriptionName,
    String? hospitalName,
    String? startedAt,
    int? takeDays,
    List<TimezonBoxModel>? items,
  }) {
    return PrescriptionModel(
      prescriptionName: prescriptionName ?? this.prescriptionName,
      hospitalName: hospitalName ?? this.hospitalName,
      startedAt: startedAt ?? this.startedAt,
      takeDays: takeDays ?? this.takeDays,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': prescriptionName,
        'hospital': hospitalName,
        'started_at': startedAt,
        'take_days': takeDays,
        //'memo' :
        'timezones': items?.map((item) => item.toJson()).toList(),
      };
}

class PrescriptionNotifier extends StateNotifier<PrescriptionModel> {
  PrescriptionNotifier() : super(PrescriptionModel());

  void initPrescription(){
    state = PrescriptionModel();
  }

  void updatePrescriptionName(String name) {
    state = state.copyWith(prescriptionName: name);
  }

  void updateHospitalName(String name) {
    state = state.copyWith(hospitalName: name);
  }

  void updateStartedAt(String date) {
    state = state.copyWith(startedAt: date);
  }

  void updateTakDays(int days) {
    state = state.copyWith(takeDays: days);
  }

  void updateItems(List<TimezonBoxModel> medicineList) {
    state = state.copyWith(items: medicineList);
  }
}

/*
{
"hospital_name": "건대병원",
"take_days": 20,
"started_at": "2024-02-20",
"items": [
{
"medicine_id": "d8112164-c549-46ca-b083-ea1ae1fd87c7",
"medicine_name": "타이레놀2",
"take_time_zone": "MORNING",
"take_moment": "BEFORE",
"take_amount": 10
},
*/
