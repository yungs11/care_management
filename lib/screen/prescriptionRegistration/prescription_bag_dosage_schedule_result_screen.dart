import 'package:care_management/common/component/custom_components.dart';
import 'package:care_management/common/component/dialog.dart';
import 'package:care_management/common/component/dosage_scedule_list.dart';
import 'package:care_management/common/const/colors.dart';
import 'package:care_management/common/const/data.dart';
import 'package:care_management/common/dio/dio.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/common/model/prescription_model.dart';
import 'package:care_management/common/model/timezone_box_model.dart';
import 'package:care_management/common/model/medicine_item_model.dart';
import 'package:care_management/common/util/errorUtil.dart';
import 'package:care_management/screen/search/medicine_search_dialog.dart';
import 'package:care_management/screen/user_main_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrescriptionBagDosageSceduleResultScreen extends ConsumerStatefulWidget {
  const PrescriptionBagDosageSceduleResultScreen({super.key});

  @override
  ConsumerState<PrescriptionBagDosageSceduleResultScreen> createState() =>
      _PrescriptionBagDosageSceduleResultScreenState();
}

class _PrescriptionBagDosageSceduleResultScreenState
    extends ConsumerState<PrescriptionBagDosageSceduleResultScreen> {
  bool isCopyMode = false;
  int selectedBoxId = -1; //선택된 박스 ID
  int targetBoxId = -1; // 복사 대상 박스 ID

  List<MedicineItemModel> copiedMedicine = [];
  List<MedicineItemModel> copiedToMedicine = [];
/*
  Map<int, TimezonBoxModel> medicinesPerBox = {
    1: TimezonBoxModel(timezoneTitle: '아침 (08:00)', medicines: [
      MedicineItemModel(name: '코푸시럽', selected: true),
      MedicineItemModel(name: '잘티진정', selected: false),
      MedicineItemModel(name: '잘티콜록정', selected: false),
      MedicineItemModel(name: '잘티콜록정', selected: false),
      MedicineItemModel(name: '잘티콜록정', selected: false),
    ], timezoneId: '11'),
    2: TimezonBoxModel(timezoneTitle: '점심 (12:00)', medicines: [

    ], timezoneId: '22'),
  };*/

  @override
  Widget build(BuildContext context) {
    final List<TimezonBoxModel> timezoneList = ref.read(timezoneProvider);

    Map<int, TimezonBoxModel> medicinesPerBox =
        timezoneList.asMap().map((index, value) => MapEntry(index + 1, value));
    print(medicinesPerBox.entries);
    //
    List<Widget> boxes = medicinesPerBox.entries.map((entry) {
      return renderMedicineBox(entry.key, entry.value.timezoneTitle!,
          medicinesPerBox, entry.value.medicines!);
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
                          onButtonPressed: () async {
                            final timezoneList = ref.watch(timezoneProvider);
                            ref
                                .read(prescriptionProvider.notifier)
                                .updateItems(timezoneList);

                            final prescription = ref.read(prescriptionProvider);

                            print('prescription >>>> ');
                            print(prescription.prescriptionName);
                            print(prescription.hospitalName);
                            print(prescription.takeDays);
                            print(prescription.startedAt);
                            print(prescription.items!
                                .map((e) => e.timezoneTitle));
                            print(prescription.items!
                                .map((e) => e.medicines!.map((el) => el.name)));

                            final dio = ref.watch(dioProvider);

                            print(prescription.toJson());

                            try {
                              final resp = await dio.post('${apiIp}/plan',
                                  options:
                                  Options(headers: {'accessToken': 'true'}),
                                  data: prescription.toJson());



                             Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => MainLayout(
                                    appBartitle: '',
                                    body: UserMainScreen(),
                                    addPadding: false,
                                  ),
                                ),
                                    (route) => false);

                            }on DioException catch (e) {
                              CustomDialog.errorAlert(context, e);
                            } catch (e) {
                              print('-------dio 아님---------');
                              print(e);
                            }
                          },
                          buttonText: '완료'),
                    )
                  : Expanded(
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

  Widget renderMedicineBox(
      int boxId,
      String title,
      Map<int, TimezonBoxModel> medicinesPerBox,
      List<MedicineItemModel> medicines) {
    return InkWell(
      onTap: () {
        setState(() {
          if (isCopyMode && selectedBoxId > 0 && targetBoxId < 0) {
            targetBoxId = boxId;

            if (selectedBoxId != targetBoxId) {
              final selectedMedicines = medicinesPerBox[selectedBoxId]!
                  .medicines!
                  .where((medicine) => medicine.selected!)
                  .toList();

              medicinesPerBox[targetBoxId]!.medicines!.clear();
              medicinesPerBox[targetBoxId]!
                  .medicines!
                  .addAll(selectedMedicines);

              isCopyMode = false;
              selectedBoxId = -1;
              targetBoxId = -1;
            }
          } else if (isCopyMode) {
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
