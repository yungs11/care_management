import 'package:care_management/common/model/taking_medicine_item_model.dart';


/**
 * 유저 메인 화면
 * title : 아침
 * takeDateTime : take한 시간
 * medicines : 약 리스트
 * memo : 메모
 */
class MedicationScheduleBoxModel{
  final String title;
  final DateTime? takeDateTime;
  final String? memo;
  final List<TakingMedicineItem>? medicines;

  MedicationScheduleBoxModel({required this.title , this.takeDateTime, this.memo, this.medicines});
}  