import 'package:care_management/component/custom_components.dart';
import 'package:care_management/component/dosage_scedule_button.dart';
import 'package:care_management/component/dosage_scedule_list.dart';
import 'package:care_management/layout/main_layout.dart';
import 'package:care_management/screen/dosage_input_screen.dart';
import 'package:care_management/screen/medicine_search_dialog.dart';
import 'package:flutter/material.dart';

class PrescriptionBagDosageSceduleResultScreen extends StatelessWidget {
  const PrescriptionBagDosageSceduleResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
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
          DosageScheduleList(
            scheduleTitle: '아침 (08:00)',
            onPressed: () {
              print('000');
              _showPopup(context);
            },
            isSelected: true,
          ),
          DosageScheduleButton(
            scheduleTitle: '점심 (08:00)',
            onPressed: () {},
            isSelected: false,
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                  child: ElevatedButton(
                      onPressed: (){},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // 테마에 맞는 버튼 색상
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Color(0x66000000)),
                            borderRadius: BorderRadius.circular(5.0)),
                        padding: const EdgeInsets.all(32.0),
                      ),
                      child: Text(
                        '약 복사',
                      )),),
              SizedBox(width: 10.0,),
              Expanded(
                flex: 1,
                child: DoneButton(
                    onButtonPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => DosageInputScreen()));
                    },
                    buttonText: '완료'),
              ),
            ],
          ),
        ],
      ),
    );
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
