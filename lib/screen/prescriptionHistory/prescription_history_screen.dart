import 'package:care_management/common/const/colors.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/common/model/medication_schedule_box_model.dart';
import 'package:care_management/common/model/taking_medicine_item_model.dart';
import 'package:care_management/common/util/formatUtil.dart';
import 'package:flutter/material.dart';

class PrescriptionHistoryScreen extends StatelessWidget {
  final DateTime selectedDate;

  const PrescriptionHistoryScreen({super.key, required this.selectedDate});




  @override
  Widget build(BuildContext context) {
    List<MedicationScheduleBoxModel> pillListPerSchedules = [
      MedicationScheduleBoxModel(
        title: '아침 약',
        takeDateTime: DateTime(2023, 12, 29, 09, 55, 0),
        medicines: <TakingMedicineItem>[
          TakingMedicineItem(
            name: '코푸시럽',
            takingTime: DateTime(2023, 12, 29, 09, 55, 0),
            takingCount: 1,
            takingYN: true,
            controller: TextEditingController(text: 1.toString()),
          ),
          TakingMedicineItem(
            name: '모비드캡슐',
            takingTime: DateTime(2023, 12, 29, 09, 55, 0),
            takingCount: 1,
            takingYN: false,
            controller: TextEditingController(text: 1.toString()),
          ),
          TakingMedicineItem(
            name: '무코레바정',
            takingTime: DateTime(2023, 12, 29, 09, 55, 0),
            takingCount: 1,
            takingYN: false,
            controller: TextEditingController(text: 1.toString()),
          ),
          TakingMedicineItem(
            name: '트라몰서방정',
            takingTime: DateTime(2023, 12, 29, 09, 55, 0),
            takingCount: 0.5,
            takingYN: false,
            controller: TextEditingController(text: 0.5.toString()),
          ),
        ],
      ),
      MedicationScheduleBoxModel(
          title: '점심 약',
          takeDateTime: DateTime(2023, 12, 29, 12, 55, 0),
          medicines: <TakingMedicineItem>[
            TakingMedicineItem(
              name: '코푸시럽',
              takingTime: DateTime(2023, 12, 29, 12, 55, 0),
              takingCount: 1,
              takingYN: true,
              controller: TextEditingController(text: 1.toString()),
            ),
            TakingMedicineItem(
              name: '모비드캡슐',
              takingTime: DateTime(2023, 12, 29, 12, 55, 0),
              takingCount: 1,
              takingYN: false,
              controller: TextEditingController(text: 1.toString()),
            ),
            TakingMedicineItem(
              name: '무코레바정',
              takingTime: DateTime(2023, 12, 29, 12, 55, 0),
              takingCount: 1,
              takingYN: false,
              controller: TextEditingController(text: 1.toString()),
            ),
            TakingMedicineItem(
              name: '트라몰서방정',
              takingTime: DateTime(2023, 12, 29, 12, 55, 0),
              takingCount: 0.5,
              takingYN: false,
              controller: TextEditingController(text: 0.5.toString()),
            ),
          ]),
      MedicationScheduleBoxModel(
        title: '저녁 약',
        takeDateTime: DateTime(2023, 12, 29, 19, 55, 0),
        medicines: <TakingMedicineItem>[
          TakingMedicineItem(
            name: '코푸시럽',
            takingTime: DateTime(2023, 12, 29, 19, 55, 0),
            takingCount: 1,
            takingYN: true,
            controller: TextEditingController(text: 1.toString()),
          ),
          TakingMedicineItem(
            name: '모비드캡슐',
            takingTime: DateTime(2023, 12, 29, 19, 55, 0),
            takingCount: 1,
            takingYN: false,
            controller: TextEditingController(text: 1.toString()),
          ),
          TakingMedicineItem(
            name: '무코레바정',
            takingTime: DateTime(2023, 12, 29, 19, 55, 0),
            takingCount: 1,
            takingYN: false,
            controller: TextEditingController(text: 1.toString()),
          ),
          TakingMedicineItem(
            name: '트라몰서방정',
            takingTime: DateTime(2023, 12, 29, 19, 55, 0),
            takingCount: 0.5,
            takingYN: false,
            controller: TextEditingController(text: 0.5.toString()),
          ),
        ],
      )
    ];

    return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
              Align(alignment:Alignment.centerLeft, child: SizedBox(width: 140.0, child: renderSelectedDate(selectedDate))),

              ...pillListPerSchedules.map((pillListPerTimeBox) => Column(
                children: [
                  SizedBox(height: 20.0,),
                  renderMedicinePerTImeBox(pillListPerTimeBox),
                ],
              )).toList(),
            ]),
          ));
  }
}

Widget renderSelectedDate(DateTime selectedDate){
  return  Container(
    decoration: BoxDecoration(
      border: Border.all(
          color: PRIMARY_COLOR, width: 3.0),
      borderRadius: BorderRadius.circular(15.0),

    ),
    //padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
    height: 45.0,
    child: Center(
      child: Text(
       '${selectedDate.year} / ${selectedDate.month} / ${selectedDate.day}',
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    ),
  );;
}


Widget renderMedicinePerTImeBox(MedicationScheduleBoxModel pillListPerTimeBox){
   TextStyle headerFontstyle = const TextStyle(
      color: PRIMARY_COLOR,
      fontWeight: FontWeight.w500,
      fontSize: 12.0);

  return
    DataTable(
      columnSpacing: 10.0,
      headingRowHeight: 20.0,
      horizontalMargin: 0,
      columns: <DataColumn>[
        DataColumn(label: Text(pillListPerTimeBox.title, style: TextStyle( fontSize: 15.0, fontWeight: FontWeight.w500),)),
        DataColumn(label: Text('')),
        DataColumn(label: Text('1회분량',style: headerFontstyle,)),
        DataColumn(
            label: Text('남은양',
                style: headerFontstyle)),
        DataColumn(
            label: Text('처방량',
                style: headerFontstyle)),
      ],
      rows: pillListPerTimeBox.medicines!.map((e) => renderPillItem(e)).toList(),
    );



}

DataRow renderPillItem(TakingMedicineItem pill) {
  //_textController.text= pill['takingCount'].toString() ?? '';

  return DataRow(
    cells: <DataCell>[
      DataCell(Container(width: 50.0, child: renderPillTakingYNIcon(pill))),
      DataCell(Container(width: 150.0, child: renderPillName(pill))),
      DataCell(Container(width: 40.0, child:  Text('1개'))),
      DataCell(Container(width: 40.0, child: Text('5일분'))),
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

