import 'package:care_management/common/const/colors.dart';
import 'package:care_management/common/model/medication_schedule_box_model.dart';
import 'package:care_management/common/model/taking_medicine_item_model.dart';
import 'package:care_management/common/util/formatUtil.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainCardList extends StatefulWidget {
  final String title;
  DateTime takingTime;
  final String? memo;
  final List<TakingMedicineItem> medicineList;

  bool takeYN = false;


  MainCardList(
      {super.key,
      required this.title,
      required this.takingTime,
      this.memo,
      required this.medicineList});

  @override
  State<MainCardList> createState() => _MainCardListState();
}

class _MainCardListState extends State<MainCardList> {
  String? dayOrNight;

  @override
  void dispose() {
    // TODO: implement dispose
    for (TakingMedicineItem medicine in widget.medicineList) {
      medicine.controller.dispose();
    }
    super.dispose();
  }

  void _updateTakingCount(TakingMedicineItem pill, double value) {
    setState(() {
      pill.controller.text = FormatUtil.doubleToString(value);
    });
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
      title: renderTitleTakingTiming(widget.title, widget.takingTime),
      initiallyExpanded: false,
      children: <Widget>[
        const Divider(
          height: 3,
          color: Color(0xffddddddd),
        ),
        ...medicineList.map((medicine) => renderPillItem(medicine)),
        renderMemo(widget.memo!),
      ],
    );
  }

  Widget renderTitleTakingTiming(String timingTitle, DateTime timingTime) {
    return Container(
      height: 70.0,
      padding: EdgeInsets.only(left: 0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          width: 20.0,
          child: IconButton(
              onPressed: () {
                setState(() {
                  final now = DateTime.now().toLocal();
                  widget.takeYN = !widget.takeYN;
                  for (TakingMedicineItem medicine in widget.medicineList) {
                    medicine.takingYN = widget.takeYN;
                  }

                  if (widget.takeYN) {
                    widget.takingTime = now;
                  } else {
                    widget.takingTime = DateTime(0);
                  }

                  for (TakingMedicineItem medicine in widget.medicineList) {
                    medicine.takingTime = widget.takingTime;
                  }
                });
              },
              icon: Icon(
                Icons.circle_outlined,
                color: widget.takeYN ? PRIMARY_COLOR : Colors.grey,
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
            children: widget.takeYN
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
    //_textController.text= pill['takingCount'].toString() ?? '';

    return SizedBox(
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        renderPillTakingYNIcon(pill),
        renderPillName(pill),
        renderPillTakingTime(pill),
        renderPillDoseCounter(pill),
      ]),
    );
  }

  Widget renderPillTakingYNIcon(pill) {
    return Expanded(
      flex: 1,
      child: IconButton(
          onPressed: () {
            setState(() {
              final now = DateTime.now().toLocal();
              pill.takingYN = !pill.takingYN;
              if (pill.takingYN) {
                pill.takingTime = DateTime.now();
              } else {
                pill.takingTime = DateTime(0);
              }
            });
          },
          icon: Icon(
            Icons.circle_outlined,
            color: pill.takingYN ? PRIMARY_COLOR : Colors.grey,
            size: 10.0,
          )),
    );
  }

  Widget renderPillName(pill) {
    return Expanded(
      flex: 2,
      child: Text(pill.name,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)),
    );
  }

  Widget renderPillTakingTime(pill) {
    return Expanded(
      child: Row(
        children: pill.takingYN
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
                if (pill.takingCount - 1 < 0) {
                  pill.takingCount = 0;
                } else {
                  pill.takingCount -= 1;
                }
                _updateTakingCount(pill, pill.takingCount);
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
                pill.takingCount += 1;

                _updateTakingCount(pill, pill.takingCount);
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

  Widget renderMemo(String memo) {
    return Container(
      margin: const EdgeInsets.only(left: 13.0),
      child: Row(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(45,25),
              padding: EdgeInsets.zero,
              backgroundColor: PRIMARY_COLOR, // 터키색 배경
              foregroundColor: Colors.white, // 텍스트 색상
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0), // 둥근 모서리 반경
              ),
            ),
            onPressed: () {

            },
            child: Text(
              '메모',
              style: TextStyle(
                fontSize: 10, // 폰트 크기
              ),
            ),
          )
        ],
      ),
    );
  }
}
