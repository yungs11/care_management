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
import 'package:care_management/screen/prescriptionRegistration/medicine_search_screen.dart';
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
  String? selectedBoxId = null; //선택된 박스 ID
  String? targetBoxId = null; // 복사 대상 박스 ID

  List<MedicineItemModel> copiedMedicine = [];
  List<MedicineItemModel> copiedToMedicine = [];

  @override
  void dispose() {
    print('-------PrescriptionBagDosageSceduleResultScreen dispose-------');
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('-------PrescriptionBagDosageSceduleResultScreen build-------');


    final List<TimezoneBoxModel> timezoneList = ref.read(timezoneProvider);

    /* Map<int, TimezonBoxModel> medicinesPerBox =
        timezoneList.asMap().map((index, value) => MapEntry(index + 1, value));
    print(medicinesPerBox.entries);*/
    //
    print('build---------------');
    List<Widget> boxes = timezoneList.map((e) {
      return renderMedicineBox(
          e.timezoneId!, e.timezoneTitle!, timezoneList, e.medicines!);
    }).toList();

    print(boxes);
    boxes.map((e) => print('ㅇㄹㅇㄹ ${e}'));

    print('###########');
    print(selectedBoxId );
    print(targetBoxId );

    return MainLayout(
      appBartitle: '복약 계획',
      addPadding: true,
      body: SingleChildScrollView(
        // 스크롤 영역 추가
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            isCopyMode
                ? selectedBoxId != null && targetBoxId == null
                    ? renderSelectMedicineHeader()
                    : renderCopyMedicineHeader()
                : renderDefaultHeader(),
            ...boxes,
            SizedBox(
              height: 20.0,
            ),
            renderButtons(),
          ],
        ),
      ),
    );
  }

  Widget renderMedicineBox(
      String timezoneId,
      String timezoneTitle,
      List<TimezoneBoxModel> copiedTimezoneList,
      List<MedicineItemModel> medicines) {
    print('--------renderMedicineBox ${copiedTimezoneList[0].medicines!.length} ${copiedTimezoneList[1].medicines!.length}');
    //copiedTimezoneList.map((e) => print('${e.timezoneTitle} ${e.medicines}'));

    return InkWell(
      onTap: () {
        if (isCopyMode && selectedBoxId != null && targetBoxId == null) {
          setState(() {
            targetBoxId = timezoneId;

            if (selectedBoxId != targetBoxId) {
              final selectedMedicines = copiedTimezoneList
                  .where(
                      (timezoneBox) => timezoneBox.timezoneId == selectedBoxId)
                  .first
                  .medicines!
                  .where((medicine) => medicine.selected!)
                  .toList();

              //특정 타임존에 medicineList 업데이트
              ref
                  .read(timezoneProvider.notifier)
                  .updateMedicineItem(targetBoxId!,selectedMedicines);

              isCopyMode = false;
              selectedBoxId = null;
              targetBoxId = null;
            }
          });
        } else if (isCopyMode) {
          setState(() {
            selectedBoxId = timezoneId;
          });
        }
      },
      focusColor: Colors.pink,
      child: DosageScheduleList(
        timezoneTitle: timezoneTitle,
        onPressed: () {
          print('000');
          _showPopup(context);
        },
        isBoxSelected: false,
        isCopyMode: isCopyMode,
        medicines: medicines,
        timezoneId: timezoneId,
      ),
    );
  }

  Widget renderButtons() {
    return Row(
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
                      selectedBoxId = null;
                      targetBoxId = null;
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


                    //처방전에 timezoneList 업데이트
                      ref
                          .read(prescriptionProvider.notifier)
                          .updateFilteredItems(timezoneList);

                      final prescription = ref.read(prescriptionProvider);

                      print('prescription >>>> ');
                      final dio = ref.watch(dioProvider);

                      print(prescription.toJson());

                      try {
                        final resp = await dio.post('${apiIp}/plan',
                            options: Options(headers: {'accessToken': 'true'}),
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
                      } on DioException catch (e) {
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
    );
  }

  Widget renderDefaultHeader() {
    return Row(
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
    );
  }

  Widget renderSelectMedicineHeader() {
    return Column(
      children: [
        Text(
          '붙여넣기 할 시간대를 선택해주세요.',
          style: TextStyle(fontSize: 22.0, color: PRIMARY_COLOR),
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
  }

  Widget renderCopyMedicineHeader() {
    return Column(
      children: [
        Text(
          '복사할 시간대를 선택해주세요.',
          style: TextStyle(fontSize: 22.0, color: PRIMARY_COLOR),
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
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
