import 'package:care_management/common/component/custom_components.dart';
import 'package:care_management/common/component/dosage_scedule_button.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/screen/prescriptionRegistration/dosage_input_screen.dart';
import 'package:care_management/screen/search/medicine_search_dialog.dart';
import 'package:care_management/screen/prescriptionRegistration/medicine_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrescriptionBagDosageSceduleScreen extends StatefulWidget {
  const PrescriptionBagDosageSceduleScreen({super.key});

  @override
  State<PrescriptionBagDosageSceduleScreen> createState() =>
      _PrescriptionBagDosageSceduleScreenState();
}

class _PrescriptionBagDosageSceduleScreenState
    extends State<PrescriptionBagDosageSceduleScreen> {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: MainLayout(
      appBartitle: '복약 계획',
      addPadding: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {},
                  child: Text(
                    '+ 복약 시간대 추가',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  )),
            ],
          ),
          DosageScheduleButton(
            scheduleTitle: '아침 (08:00)',
            onPressed: () {
              print('000');
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => MedicineSearchScreen(timezoneId: '4d771e70-68b5-44cb-8389-eaf8976f3191',timezoneTitle: '아침 (08:00)',)));
            },
            isBoxSelected: true,
          ),
          DosageScheduleButton(
            scheduleTitle: '점심 (08:00)',
            onPressed: () {},
            isBoxSelected: false,
          ),
          SizedBox(
            height: 20.0,
          ),
         /* DoneButton(
              onButtonPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => DosageInputScreen(toAddigMedicine: null,)));
              },
              buttonText: '선택'),*/
        ],
      ),
    ));
  }

  void _showPopup(BuildContext context) async {
    print('1111');

    final result = await showDialog<Map>(
      context: context,
      builder: (BuildContext context) => MedicineSearchDialog(),
    );

    if (result != null) {
      print('부모 창으로 전달된 값: $result');
    }
  }
}
