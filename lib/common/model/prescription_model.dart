import 'package:care_management/common/model/medicine_item_model.dart';
import 'package:care_management/common/model/timezone_box_model.dart';
import 'package:care_management/common/util/formatUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';


final prescriptionProvider =
    StateNotifierProvider<PrescriptionNotifier, PrescriptionModel>(
        (ref) => PrescriptionNotifier());

List<Color> prescriptionColorsMap = [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.purple
];
int prescriptionIdx = 0;

class PrescriptionModel {
  final String? prescriptionId;
  final String? prescriptionName;
  final String? hospitalName;
  final DateTime? startedAt;
  final DateTime? finishedAt;
  final int? takeDays;
  final List<TimezoneBoxModel>? items;
  Color? markerColor;
  int? markerTop;
  List<String>? takeDatesList;
  //final String? memo;

  PrescriptionModel({
    this.prescriptionId,
    this.prescriptionName,
    this.hospitalName,
    this.startedAt,
    this.finishedAt,
    this.takeDays,
    this.items,
    this.markerColor,
    this.markerTop,
    this.takeDatesList,
    //this.memo,
  });

  PrescriptionModel copyWith({
    String? prescriptionId,
    String? prescriptionName,
    String? hospitalName,
    DateTime? startedAt,
    DateTime? finishedAt,
    int? takeDays,
    List<TimezoneBoxModel>? items,
    Color? markerColor,
    int? markerTop,
    List<String>? takeDatesList,
  }) {
    return PrescriptionModel(
      prescriptionId: prescriptionId ?? this.prescriptionId,
      prescriptionName: prescriptionName ?? this.prescriptionName,
      hospitalName: hospitalName ?? this.hospitalName,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      takeDays: takeDays ?? this.takeDays,
      items: items ?? this.items,
      markerColor: markerColor ?? this.markerColor,
      markerTop: markerTop ?? this.markerTop,
      takeDatesList: takeDatesList ?? this.takeDatesList,
    );
  }

  static initialMarkerColor(){
     prescriptionIdx = 0;
  }


  /**
   * 처방전 목록 조회해올 때
   */

  factory PrescriptionModel.fromJson({required Map<String, dynamic> json}) {
    print('prescriptionIdx >>> ${prescriptionIdx}');
    return PrescriptionModel(
      prescriptionId: json['id'] ?? '',
      prescriptionName: json['name'] ?? '',
      hospitalName: json['hospital'] ?? '',
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'])
          : null,
      finishedAt: json['finished_at'] != null
          ? DateTime.parse(json['finished_at'])
          : null,
      takeDays: json['take_days'].toInt(),
      markerColor: prescriptionColorsMap[prescriptionIdx++ % prescriptionColorsMap.length],
      markerTop: prescriptionIdx,
      takeDatesList: FormatUtil.getDatesBetween(DateTime.parse(json['started_at']), DateTime.parse(json['finished_at'])),
    );


  }

  /**
   * 처방전 등록할 때
   */
  Map<String, dynamic> toJson() => {
        'name': prescriptionName,
        'hospital': hospitalName,
        'started_at': DateFormat('yyyy-MM-dd').format(startedAt!),
        //'finished_at' : finishedAt,
        'take_days': takeDays,
        //'memo' :
        'timezones': items?.map((item) => item.toJson()).toList(),
      };
}

class PrescriptionNotifier extends StateNotifier<PrescriptionModel> {
  PrescriptionNotifier() : super(PrescriptionModel());

  void initPrescription() {
    state = PrescriptionModel();
  }

  void updatePrescriptionName(String name) {
    state = state.copyWith(prescriptionName: name);
  }

  void updateHospitalName(String name) {
    state = state.copyWith(hospitalName: name);
  }

  void updateStartedAt(String date) {
    state = state.copyWith(startedAt: DateTime.parse(date));
  }

  void updateTakDays(int days) {
    state = state.copyWith(takeDays: days);
  }

  void updateItems(List<TimezoneBoxModel> timezoneList) {
    state = state.copyWith(items: timezoneList);
  }

  void updateFilteredItems(List<TimezoneBoxModel> timezoneList) {
    state = state.copyWith(items: filteredTimezoneList(timezoneList));
  }

// 함수 정의: 약 복용 시간대와 그 시간대의 약들이 'selected' 상태인 것만 필터링하여 반환
  List<TimezoneBoxModel> filteredTimezoneList(
    List<TimezoneBoxModel> originalTimezone,
  ) {
    List<TimezoneBoxModel> filteredTimezoneBoxes =
        originalTimezone.map((timezoneBox) {
              List<MedicineItemModel> selectedMedicines = timezoneBox.medicines
                      ?.where((medicine) => medicine.selected ?? false)
                      .toList() ??
                  [];

              return timezoneBox.copyWith(medicines: selectedMedicines);
            }).toList() ??
            [];

    // 약이 비어져 있지 않은 시간대만 선택
    filteredTimezoneBoxes = filteredTimezoneBoxes
        .where((box) => box.medicines?.isNotEmpty ?? false)
        .toList();

    return filteredTimezoneBoxes;
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
