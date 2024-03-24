import 'package:care_management/common/model/schedule_medicine_model.dart';

class PrescriptionScheduleBoxModel{
  final String title;
  final List<MedicationItem>? medicines;

  PrescriptionScheduleBoxModel({required this.title , this.medicines});
}