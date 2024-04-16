import 'package:care_management/common/component/custom_components.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/common/model/medicine_item_model.dart';
import 'package:care_management/common/model/timezone_box_model.dart';
import 'package:care_management/screen/prescriptionRegistration/prescription_bag_dosage_schedule_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MedicationNoteScreen extends ConsumerStatefulWidget {
  final String timezoneId;
  final MedicineItemModel medicineItem;

  const MedicationNoteScreen({super.key, required this.medicineItem,required  this.timezoneId });

  @override
  ConsumerState<MedicationNoteScreen> createState() => _MedicationNoteScreen();
}

class _MedicationNoteScreen extends ConsumerState<MedicationNoteScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appBartitle: '약봉투 등록',
      addPadding: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Text(
              '메모가 있다면 적어주세요.(선택)',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextField(
            controller: _noteController,
            decoration: InputDecoration(
              hintText: '여기에 메모를 입력하세요...',
              border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                //borderSide: BorderSide.strokeAlignOutside(),
              ),
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null, // 멀티라인 입력 설정
          ),
          SizedBox(
            height: 120.0,
          ),
          DoneButton(
              onButtonPressed: () {
                if (_noteController.text.isNotEmpty)
                  widget.medicineItem.memo = _noteController.text;

                ref.read(timezoneProvider.notifier).addMedicineItem(widget.timezoneId, widget.medicineItem);

                final timezones = ref.watch(timezoneProvider);
                print('0000000000000000000000000');
                print(timezones.map((e) => '${e.timezoneId} ${e.timezoneTitle}'));
                print(timezones.map((e) => e.medicines!.map((el) => el.name)));

               Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) =>
                        PrescriptionBagDosageSceduleResultScreen()));
              },
              buttonText: '등록')
        ],
      ),
    );
  }
}
