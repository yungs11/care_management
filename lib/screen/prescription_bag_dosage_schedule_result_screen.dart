import 'package:care_management/component/custom_components.dart';
import 'package:care_management/component/dosage_scedule_button.dart';
import 'package:care_management/component/dosage_scedule_list.dart';
import 'package:care_management/const/colors.dart';
import 'package:care_management/layout/main_layout.dart';
import 'package:care_management/model/medicine_per_box_model.dart';
import 'package:care_management/model/schedule_medicine_model.dart';
import 'package:care_management/screen/dosage_input_screen.dart';
import 'package:care_management/screen/medicine_search_dialog.dart';
import 'package:flutter/material.dart';

class PrescriptionBagDosageSceduleResultScreen extends StatefulWidget {
  const PrescriptionBagDosageSceduleResultScreen({super.key});

  @override
  State<PrescriptionBagDosageSceduleResultScreen> createState() =>
      _PrescriptionBagDosageSceduleResultScreenState();
}

class _PrescriptionBagDosageSceduleResultScreenState
    extends State<PrescriptionBagDosageSceduleResultScreen> {
  bool isCopyMode = false;
  int selectedBoxId = -1; //선택된 박스 ID
  int targetBoxId = -1; // 복사 대상 박스 ID

  List<ScheduleMedicine> copiedMedicine = [];
  List<ScheduleMedicine> copiedToMedicine = [];
  Map<int, MedicinePerBox> medicinesPerBox = {
    1: MedicinePerBox(title: '아침 (08:00)', medicines: [
      ScheduleMedicine(name: '코푸시럽', selected: true),
      ScheduleMedicine(name: '잘티진정', selected: false),
      ScheduleMedicine(name: '잘티콜록정', selected: false)
    ]),
        2: MedicinePerBox(title: '점심 (12:00)', medicines: [

        ]),
  };

  @override
  Widget build(BuildContext context) {
    print(medicinesPerBox.entries);
    //
    List<Widget> boxes = medicinesPerBox.entries.map((entry) {
      return renderMedicineBox(entry.key, entry.value.title, entry.value.medicines);
    }).toList();

    return MainLayout(
      appBartitle: '복약 계획',
      addPadding: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          isCopyMode
              ? selectedBoxId > 0 && targetBoxId < 0
                  ? Column(
                      children: [
                        Text(
                          '붙여넣기 할 시간대를 선택해주세요.',
                          style:
                              TextStyle(fontSize: 22.0, color: PRIMARY_COLOR),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Text(
                          '복사할 약을 선택해주세요.',
                          style:
                              TextStyle(fontSize: 22.0, color: PRIMARY_COLOR),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    )
              : Row(
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
         ...boxes,
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: !isCopyMode
                    ? ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isCopyMode = true;
                          });
                        },
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
                        ))
                    : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isCopyMode = false;

                          });
                        },
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
                          '취소',
                        )),
              ),
              SizedBox(
                width: 10.0,
              ),
              !isCopyMode
                  ? Expanded(
                      flex: 1,
                      child: DoneButton(
                          onButtonPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => DosageInputScreen()));
                          },
                          buttonText: '완료'),
                    )
                  :
                      Expanded(
                          flex: 1,
                          child: DoneButton(
                              onButtonPressed: () {
                                setState(() {
                                 // isCopyBox2Selected = true;
                                });
                              },
                              buttonText: '복사'),
                        ),
            ],
          ),
        ],
      ),
    );
  }

  Widget renderMedicineBox(int boxId,  String title, List<ScheduleMedicine> medicines) {
      return InkWell(
        onTap: () {
          setState(() {
           if(isCopyMode && selectedBoxId > 0 && targetBoxId < 0){
              targetBoxId = boxId;


              if(selectedBoxId != targetBoxId){
                final selectedMedicines = medicinesPerBox[selectedBoxId]!.
                medicines.where((medicine) => medicine.selected)
                    .toList();

                medicinesPerBox[targetBoxId]!.medicines.clear();
                medicinesPerBox[targetBoxId]!.medicines.addAll(selectedMedicines);

                isCopyMode = false;
                selectedBoxId = -1;
                targetBoxId = -1;
              }
            }else if(isCopyMode){
             selectedBoxId = boxId;
           }


          });
        },
        focusColor: Colors.pink,
        child: DosageScheduleList(
          scheduleTitle: title,
          onPressed: () {
            print('000');
            _showPopup(context);
          },
          isBoxSelected: false,
          isCopyMode: isCopyMode,
          medicines: medicines,
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
