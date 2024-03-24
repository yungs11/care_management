import 'package:care_management/common/model/medication_schedule_box_model.dart';
import 'package:care_management/common/model/schedule_medicine_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final medicineItemListProvider = StateNotifierProvider<MedicationSceduleBoxNotifier, MedicationScheduleBoxModel>((ref) => MedicationSceduleBoxNotifier());

class MedicationSceduleBoxNotifier extends StateNotifier<MedicationScheduleBoxModel> {
MedicationSceduleBoxNotifier() : super(MedicationScheduleBoxModel(title: '', medicines: null, takeDateTime: null));
}