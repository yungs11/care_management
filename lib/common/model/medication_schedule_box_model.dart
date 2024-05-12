import 'package:care_management/common/model/taking_medicine_item_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/**
 * 유저 메인 화면
    "timezone_id": "4d771e70-68b5-44cb-8389-eaf8976f3191",
    "plan_name": "아침",
    "time_zone": "AM 09:30",
    "pills": []
    "take_status": false,
    "memo": ""
 */

final MedicationScheduleBoxProvider = StateNotifierProvider<
    MedicationScheduleBoxNotifier,
    List<MedicationScheduleBoxModel>>((ref) => MedicationScheduleBoxNotifier());

class MedicationScheduleBoxModel {
  final String? timezoneId;
  final String? timeZoneTime; //AM 09:30
  final String? timezoneTitle; //timezone_title //plan_name
  final List<TakingMedicineItem>? pills;
  bool? takeStatus;
  String? memo;
  DateTime? takeDateTime; // 이건 그냥 빼야하나?

  MedicationScheduleBoxModel({
    this.timezoneId,
    this.timeZoneTime,
    this.timezoneTitle,
    this.pills,
    this.takeStatus,
    this.memo,
    this.takeDateTime,
  });

  // Form API /plan
  factory MedicationScheduleBoxModel.fromJson(
      {required Map<String, dynamic> json}) {
    print('@@@@@@MedicationScheduleBoxModel.fromJson@@@@');
    print(json);
    print(json['memo']);

    return MedicationScheduleBoxModel(
      timezoneId: json['timezone_id'] ?? '',
      timeZoneTime: json['time_zone'] ?? '',
      timezoneTitle: json['plan_name'] ?? '',
      pills: json['pills']
              .map<TakingMedicineItem>(
                  (item) => TakingMedicineItem.fromJson(json: item))
              .toList() ??
          '',
      takeStatus: json['take_status'] ?? false,
      memo: json['memo'] ?? '',
      takeDateTime: json['take_date'] != null ?  DateTime.parse(json['take_date']) : DateTime(0)
    );
  }

  MedicationScheduleBoxModel copyWith({
    String? timezoneId,
    String? timeZoneTime,
    String? timezoneTitle,
    List<TakingMedicineItem>? pills,
    bool? takeStatus,
    String? memo,
    DateTime? takeDateTime,
  }) {
    return MedicationScheduleBoxModel(
      timezoneId: timezoneId ?? this.timezoneId,
      timeZoneTime: timeZoneTime ?? this.timeZoneTime,
      timezoneTitle: timezoneTitle ?? this.timezoneTitle,
      pills: pills ?? this.pills,
      takeStatus: takeStatus ?? this.takeStatus,
      memo: memo ?? this.memo,
      takeDateTime: takeDateTime ?? this.takeDateTime,
    );
  }
}

class MedicationScheduleBoxNotifier
    extends StateNotifier<List<MedicationScheduleBoxModel>> {
  MedicationScheduleBoxNotifier()
      : super([]);

  void initMedicationBoxModel(List<MedicationScheduleBoxModel> model) {
    state = model;
  }

}
