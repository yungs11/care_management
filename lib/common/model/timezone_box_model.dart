import 'package:care_management/common/model/medicine_item_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/**처방전 등록 페이지 (화면 보여주는 용임)
 * title : 아침
 * medicines : 약 리스트
 *
 * Map<int, PrescriptionScheduleBoxModel> medicinesPerBox = {
    1: PrescriptionScheduleBoxModel(title: '아침 (08:00)', medicines: [
    medicineItem(name: '코푸시럽', selected: true),
    medicineItem(name: '잘티진정', selected: false),
    medicineItem(name: '잘티콜록정', selected: false),
    medicineItem(name: '잘티콜록정', selected: false),
    medicineItem(name: '잘티콜록정', selected: false),
    ]),
    2: PrescriptionScheduleBoxModel(title: '점심 (12:00)', medicines: [

    ]),
    };
 *
 */


final timezoneProvider = StateNotifierProvider<TimezoneNotifier, List<TimezonBoxModel>>((ref) => TimezoneNotifier());


class TimezonBoxModel{
  final String? timezoneId;
  final String? timezoneTitle;
  final List<MedicineItemModel>? medicines;

  TimezonBoxModel( { this.timezoneId,  this.timezoneTitle , this.medicines= const []});


  TimezonBoxModel copyWith({
    String? timezoneId,
    String? timezoneTitle,
    List<MedicineItemModel>? medicines,
  }) {
    return TimezonBoxModel(
      timezoneId: timezoneId ?? this.timezoneId,
      timezoneTitle: timezoneTitle ?? this.timezoneTitle,
      medicines: medicines ?? this.medicines,
    );
  }

  Map<String, dynamic> toJson() => {
    'timezone_id': timezoneId,
    'medicines': medicines?.map((item) => item.toJson()).toList(),
  };
}

class TimezoneNotifier extends StateNotifier<List<TimezonBoxModel>> {
  TimezoneNotifier() : super([]);

// 새로운 타임존을 추가
  void addTimezone(TimezonBoxModel newTimezone) {
    // 타임존 ID가 이미 존재하는지 확인
    final exists = state.any((timezone) => timezone.timezoneId == newTimezone.timezoneId);

    if (!exists) {
      // 존재하지 않는 경우, 새 타임존 추가
      state = [
        ...state,
        newTimezone,
      ];
    } else {
      // 존재하는 경우, 로그 출력 또는 에러 처리
      //print('Timezone with ID ${newTimezone.timezoneId} already exists.');
      /*state = state.map((timezone) {
        if (timezone.timezoneId == newTimezone.timezoneId) {
          return newTimezone;
        }
        return timezone;
      }).toList();*/
    }
  }



// 특정 timezone에 MedicineItem로 업데이트하는 메소드
  void addMedicineItem(String timezoneId, MedicineItemModel newItem) {
    print('----변경전1---');
    print(state);
    state = state.map((timezone) {
      if (timezone.timezoneId == timezoneId) {
        return TimezonBoxModel(
            timezoneId: timezone.timezoneId,
            timezoneTitle: timezone.timezoneTitle,
            medicines: [...timezone.medicines!, newItem]
        );
      }
      return timezone;
    }).toList();

    print('----변경후---');
    print(state);
  }

// 특정 timezone에 MedicineItem로 업데이트하는 메소드
  void updateMedicineItem(String timezoneId, List<MedicineItemModel> newItem) {
    state = state.map((timezone) {
      if (timezone.timezoneId == timezoneId) {
        return TimezonBoxModel(
            timezoneId: timezone.timezoneId,
            timezoneTitle: timezone.timezoneTitle,
            medicines: newItem
        );
      }
      return timezone;
    }).toList();
  }

}
