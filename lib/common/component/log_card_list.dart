import 'package:care_management/common/const/colors.dart';
import 'package:care_management/common/model/taking_medicine_item_model.dart';
import 'package:care_management/common/util/formatUtil.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/medication_schedule_box_model.dart';

class LogCardList extends StatefulWidget {
  final String title;
  DateTime takingTime;
  final List<TakingMedicineItem> medicineList;
  bool takeYN = false;

  LogCardList(
      {super.key,
      required this.title,
      required this.takingTime,
      required this.medicineList});

  @override
  State<LogCardList> createState() => _LogCardListState();
}

class _LogCardListState extends State<LogCardList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        child: renderExpansionCard(),
      ),
    );
  }

  Widget renderExpansionCard() {
    return ExpansionTile(
      title:
          renderTitleTakingTiming(widget.title, widget.takingTime.toString()),
      initiallyExpanded: false,
      children: <Widget>[
        /*  const Divider(
          height: 3,
          color: Color(0xffddddddd),
        ),*/
        DataTable(
            columnSpacing: 10.0,
            headingRowHeight: 25.0,
            horizontalMargin: 0,
            columns: const <DataColumn>[
              DataColumn(label: Text('')),
              DataColumn(label: Text('')),
              DataColumn(label: Text('')),
              DataColumn(
                  label: Text('복용분량',
                      style: const TextStyle(
                          color: PRIMARY_COLOR,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0))),
              DataColumn(
                  label: Text('남은양',
                      style: const TextStyle(
                          color: PRIMARY_COLOR,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0))),
            ],
            rows: widget.medicineList.map((e) => renderPillItem(e)).toList())
      ],
    );
  }

  Widget renderTitleTakingTiming(String timingTitle, String timingTime) {
    return SizedBox(
      height: 70.0,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
            flex: 1,
            child: widget.takeYN
                ? Icon(
                    Icons.circle_outlined,
                    color: PRIMARY_COLOR,
                    size: 20.0,
                  )
                : Icon(
                    Icons.close,
                    color: Colors.indigo,
                    size: 20.0,
                  )),
        Expanded(
          flex: 2,
          child: Text(widget.title,
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0)),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
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
            ],
          ),
        ),
      ]),
    );
  }

  DataRow renderPillItem(TakingMedicineItem pill) {
    //_textController.text= pill['takingCount'].toString() ?? '';

    return DataRow(
      cells: <DataCell>[
        //  DataCell(renderPillTakingYNIcon(pill)),
        //  DataCell(renderPillName(pill)),
        //  DataCell(renderPillTakingTime(pill)),
        DataCell(Container(width: 30.0, child: renderPillTakingYNIcon(pill))),
        DataCell(Container(width: 120.0, child: renderPillName(pill))),
        DataCell(Container(width: 80.0, child: renderPillTakingTime(pill))),
        DataCell(Container(width: 20.0, child: Text('1개'))),
        DataCell(Container(width: 40.0, child: Text('10일분'))),
      ],
    );
  }

  Widget renderPillTakingYNIcon(pill) {
    return pill.takingYN
        ? Icon(
            Icons.circle_outlined,
            color: PRIMARY_COLOR,
            size: 10.0,
          )
        : Icon(
            Icons.close,
            color: Colors.indigo,
            size: 10.0,
          );
  }

  Widget renderPillName(pill) {
    return Text(pill.name,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0));
  }

  Widget renderPillTakingTime(pill) {
    return Row(
      children: [
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
              color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 12.0),
        ),
      ],
    );
  }
}
