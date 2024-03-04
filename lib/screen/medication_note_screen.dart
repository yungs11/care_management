import 'package:care_management/component/custom_components.dart';
import 'package:care_management/layout/main_layout.dart';
import 'package:care_management/screen/prescription_bag_dosage_schedule_result_screen.dart';
import 'package:flutter/material.dart';

class MedicationNoteScreen extends StatefulWidget {
  const MedicationNoteScreen({super.key});

  @override
  State<MedicationNoteScreen> createState() => _MedicationNoteScreen();
}

class _MedicationNoteScreen extends State<MedicationNoteScreen> {
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
          SizedBox(height: 20.0,),
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
          SizedBox(height: 120.0,),
          DoneButton(onButtonPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_)=>PrescriptionBagDosageSceduleResultScreen()));
          }, buttonText: '등록')
        ],
      ),
    );
  }
}
