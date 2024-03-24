import 'package:care_management/common/model/taking_medicine_item_model.dart';

class MedicationScheduleBoxModel{
  final String title;
  final DateTime? takeDateTime;
  final String? memo;
  final List<TakingMedicineItem>? medicines;

  MedicationScheduleBoxModel({required this.title , this.takeDateTime, this.memo, this.medicines});
}  