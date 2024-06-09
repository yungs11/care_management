import 'package:care_management/common/component/dialog.dart';
import 'package:care_management/common/const/colors.dart';
import 'package:care_management/common/const/data.dart';
import 'package:care_management/common/dio/dio.dart';
import 'package:care_management/common/model/medication_schedule_box_model.dart';
import 'package:care_management/common/model/taking_medicine_item_model.dart';
import 'package:care_management/common/util/formatUtil.dart';
import 'package:care_management/screen/user_main_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MainCardList extends ConsumerStatefulWidget {
  final String title;
  final String timezoneId;
  DateTime takingTime;
  final DateTime selectedDay;
  final String? memo;
  final List<TakingMedicineItem> medicineList;
  bool take_status;
  FutureProvider<List<MedicationScheduleBoxModel>>? onReloadRequest;
  bool expandCard;

  MainCardList({
    super.key,
    required this.title,
    required this.timezoneId,
    required this.takingTime,
    required this.selectedDay,
    this.memo,
    required this.medicineList,
    this.take_status = false,
    this.onReloadRequest,
    this.expandCard = false,
  });

  @override
  ConsumerState<MainCardList> createState() => _MainCardListState();
}

class _MainCardListState extends ConsumerState<MainCardList> {
  String? dayOrNight;

  @override
  void dispose() {
    // TODO: implement dispose
    for (TakingMedicineItem medicine in widget.medicineList) {
      medicine.controller!.dispose();
    }
    super.dispose();
  }

  void _updatetakeAmount(TakingMedicineItem pill, double value) async {
    final dio = ref.watch(dioProvider);
    try {
      final resp = await dio.patch('${apiIp}/plan/item/takeamount',
          options: Options(headers: {'accessToken': 'true'}),
          data: {
            'prescription_item_id': pill.prescriptionItemId,
            'take_amount': value,
          });

      ref.refresh(widget.onReloadRequest!);
    } on DioException catch (e) {
      ref.watch(dialogProvider.notifier).errorAlert(e);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        child: renderExpansionCard(widget.medicineList),
      ),
    );
  }

  Widget renderExpansionCard(List<TakingMedicineItem> medicineList) {
    return ExpansionTile(
      title: renderTitleTakingTiming(
          widget.title, widget.timezoneId, widget.takingTime),
      initiallyExpanded: widget.expandCard!,
      children: <Widget>[
        const Divider(
          height: 3,
          color: Color(0xffddddddd),
        ),
        ...medicineList.map((medicine) => renderPillItem(medicine)),
        MemoBox(
          memo: widget.memo!,
          timezoneId: widget.timezoneId,
          selectedDay: widget.selectedDay,
          onReloadRequest: widget.onReloadRequest,
        ),
      ],
    );
  }

  Widget renderTitleTakingTiming(
      String timingTitle, String timingId, DateTime timingTime) {
    return Container(
      height: 70.0,
      padding: EdgeInsets.only(left: 0),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          width: 70.0,
          child: IconButton(
              onPressed: () async {
                final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
                final formatedSelectedDay =
                    DateFormat('yyyy-MM-dd').format(widget.selectedDay);

                if (today != formatedSelectedDay) {
                  ref.watch(dialogProvider.notifier).showAlert('변경은 당일만 가능합니다.');
                  return;
                }
                final dio = ref.watch(dioProvider);

                try {
                  final resp = await dio.post('${apiIp}/plan/take',
                      options: Options(headers: {'accessToken': 'true'}),
                      data: {
                        'target_date': today,
                        'timezone_id': timingId,
                      });

                  print(resp);
                  ref.refresh(widget.onReloadRequest!);
                } on DioException catch (e) {
                  ref.watch(dialogProvider.notifier).errorAlert(e);
                } catch (e) {
                  print(e);
                }
              },
              icon: Icon(
                Icons.circle_outlined,
                color: widget.take_status ? PRIMARY_COLOR : Colors.grey,
              )),
        ),
        Container(
          width: 120.0,
          child: Text(widget.title,
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0)),
        ),
        Container(
          width: 80.0,
          child: Row(
            children: widget.take_status
                ? [
                    Text(FormatUtil.getTimeFromDateTime(widget.takingTime),
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 12.0)),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      FormatUtil.parseTimeToAMPM(widget.takingTime),
                      style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0),
                    ),
                  ]
                : [],
          ),
        ),
      ]),
    );
  }

  Widget renderPillItem(TakingMedicineItem pill) {
    //_textController.text= pill['takeAmount'].toString() ?? '';

    return SizedBox(
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        renderPilltakeStatusIcon(pill),
        renderPillName(pill),
        renderPillTakingTime(pill),
        renderPillDoseCounter(pill),
      ]),
    );
  }

  Widget renderPilltakeStatusIcon(pill) {
    return Expanded(
      flex: 1,
      child: IconButton(
          onPressed: () async {
            final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
            final formatedSelectedDay =
                DateFormat('yyyy-MM-dd').format(widget.selectedDay);

            if (today != formatedSelectedDay) {
              ref.watch(dialogProvider.notifier).showAlert('변경은 당일만 가능합니다.');
              return;
            }



            final dio = ref.watch(dioProvider);

            try {
              await dio.post('${apiIp}/plan/take/pill',
                  options: Options(headers: {'accessToken': 'true'}),
                  data: {
                    'pill_id': pill.takeHistoryItemId,
                  });

              print('take처리!!!!');
              print(pill.takeHistoryItemId);

              ref.refresh(widget.onReloadRequest!);

              /*
            setState(() {
              final now = DateTime.now().toLocal();
              pill.takeStatus = !pill.takeStatus;
              if (pill.takeStatus) {
                pill.takingTime = DateTime.now();
              } else {
                pill.takingTime = DateTime(0);
              }
            });
                    }
                  });  */
            } on DioException catch (e) {
              ref.watch(dialogProvider.notifier).errorAlert(e);
            } catch (e) {}
          },
          icon: Icon(
            Icons.circle_outlined,
            color: pill.takeStatus ? PRIMARY_COLOR : Colors.grey,
            size: 10.0,
          )),
    );
  }

  Widget renderPillName(pill) {
    return Expanded(
      flex: 2,
      child: Text(pill.pillName,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)),
    );
  }

  Widget renderPillTakingTime(pill) {
    return Expanded(
      child: Row(
        children: pill.takeStatus
            ? [
                Text(FormatUtil.getTimeFromDateTime(pill.takingTime),
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                      color: Colors.grey,
                    )),
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  FormatUtil.parseTimeToAMPM(pill.takingTime),
                  style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0),
                ),
              ]
            : [],
      ),
    );
  }

  Widget renderPillDoseCounter(pill) {
    return Expanded(
      flex: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.grey[300]!)),
            child: IconButton(
              onPressed: () {

                if(pill.takeStatus){
                  ref.watch(dialogProvider.notifier).showAlert('복용상태를 취소 후 변경해주세요.');
                  return;
                }

                if (pill.takeAmount - 1 < 0) {
                  pill.takeAmount = 0.0;
                  return;
                } else {
                  pill.takeAmount -= 1.0;
                }
                _updatetakeAmount(pill, pill.takeAmount);
              },
              padding: const EdgeInsets.only(bottom: 5.0), // 패딩 제거
              icon: const Icon(
                Icons.minimize_outlined,
                size: 10.0,
              ),
            ),
          ),
          SizedBox(
            width: 20,
            height: 20,
            child: TextFormField(
              controller: pill.controller,
              style: const TextStyle(fontSize: 12.0, color: Colors.black),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.zero),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.zero),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                hintText: 'Enter a number',
              ),
            ),
          ),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.grey[300]!)),
            child: IconButton(
              onPressed: () {

                if(pill.takeStatus){
                  ref.watch(dialogProvider.notifier).showAlert('복용상태를 취소 후 변경해주세요.');
                  return;
                }

                pill.takeAmount += 1;

                _updatetakeAmount(pill, pill.takeAmount);
              },
              padding: EdgeInsets.zero, // 패딩 제거
              icon: const Icon(
                Icons.add,
                size: 10.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MemoBox extends ConsumerStatefulWidget {
  final String memo;
  final DateTime selectedDay;
  final String timezoneId;
  final FutureProvider<List<MedicationScheduleBoxModel>>? onReloadRequest;

  MemoBox({
    required this.memo,
    required this.selectedDay,
    required this.timezoneId,
    required this.onReloadRequest,
  });

  @override
  ConsumerState<MemoBox> createState() => _MemoBoxState();
}

class _MemoBoxState extends ConsumerState<MemoBox> {
  bool showMemoPad = false;
  TextEditingController _memoController = TextEditingController(); // 컨트롤러 추가

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (widget.memo != '') {
      _memoController.text = widget.memo;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _memoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: MediaQuery.of(context).size.width /2 ,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: !showMemoPad
          ? Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(45, 25),
                    padding: EdgeInsets.zero,
                    backgroundColor: PRIMARY_COLOR,
                    // 터키색 배경
                    foregroundColor: Colors.white,
                    // 텍스트 색상
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // 둥근 모서리 반경
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      showMemoPad = !showMemoPad;
                    });
                  },
                  child: Text(
                    '메모',
                    style: TextStyle(
                      fontSize: 10, // 폰트 크기
                    ),
                  ),
                ),
                Text(
                  _memoController.text,
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                )
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _memoController,
                    decoration: InputDecoration(
                      //  labelText: labelText,
                      //  hintText: hintText,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xdddddd)),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(45, 25),
                    padding: EdgeInsets.zero,
                    backgroundColor: PRIMARY_COLOR,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // 둥근 모서리 반경
                    ),
                  ),
                  onPressed: () async {
                    final dio = ref.watch(dioProvider);

                    try {
                      final resp = await dio.post('${apiIp}/plan/memo',
                          options: Options(headers: {'accessToken': 'true'}),
                          data: {
                            'date': DateFormat('yyyy-MM-dd')
                                .format(widget.selectedDay),
                            'timezone_id': widget.timezoneId,
                            'memo': _memoController.text,
                          });

                      print(
                          DateFormat('yyyy-MM-dd').format(widget.selectedDay));
                      print(widget.timezoneId);
                      print(_memoController.text);
                      print(resp);

                      ref.refresh(widget.onReloadRequest!);
                    } on DioException catch (e) {
                      ref.watch(dialogProvider.notifier).errorAlert(e);
                    } catch (e) {
                      ref.watch(dialogProvider.notifier).errorExceptionAlert(e);
                    } /*
                    setState(() {
                      showMemoPad = !showMemoPad;
                    });*/
                  },
                  child: Text(
                    '저장',
                    style: TextStyle(
                      fontSize: 10, // 폰트 크기
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
