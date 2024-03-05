import 'package:care_management/model/schedule_medicine_model.dart';

class MedicinePerBox{
  final String title;
  final List<ScheduleMedicine> medicines;

  MedicinePerBox({required this.title , required this.medicines});
}