import 'package:care_management/component/custom_components.dart';
import 'package:care_management/layout/main_layout.dart';
import 'package:care_management/screen/medication_note_screen.dart';
import 'package:flutter/material.dart';

class DosageInputScreen extends StatefulWidget {
  const DosageInputScreen({super.key});

  @override
  State<DosageInputScreen> createState() => _DosageInputScreenState();
}

class _DosageInputScreenState extends State<DosageInputScreen> {
  int _selectedDose = 1; // 초기 복용량 값

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
              '1회 복용량은 얼마인가요?',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 70.0,
                height: 60.0,
                child: DropdownButton<int>(
                  isExpanded: true,
                  icon: Image(image: AssetImage("asset/icon/bottom_arrow.png"),),

                  value: _selectedDose,
                  underline: Container(
                    height: 1,
                    color: Color(0x67000000),
                  ),
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedDose = newValue!;
                    });
                  },
                  items:
                      <int>[1, 2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(value.toString(),style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w300,
                          ),),
                          SizedBox(
                              width: 8), // For spacing between the text and the icon

                        ],

                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(width: 10.0,),
              Text('정',style: TextStyle(
                fontSize: 20.0,

              ),),
            ],
          ),
          SizedBox(
            height: 120.0,
          ),
          DoneButton(onButtonPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_)=>MedicationNoteScreen()));
          }, buttonText: '다음')
        ],
      ),
    );
  }
}
