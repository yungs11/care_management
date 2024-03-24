import 'package:care_management/common/component/log_card_list.dart';
import 'package:care_management/common/component/main_card_list.dart';
import 'package:care_management/common/component/card_title.dart';
import 'package:care_management/common/const/colors.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/common/model/medication_schedule_box_model.dart';
import 'package:care_management/common/model/taking_medicine_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DoseLogScreen extends StatelessWidget {
  final String selectedDate;

  const DoseLogScreen({super.key, required this.selectedDate});

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

    return MainLayout(
      appBartitle: '',
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            renderDateHeader(selectedDate),
            const SizedBox(
              height: 50.0,
            ),
            Expanded(child: renderPillCard(pillListPerSchedules)),
          ],
        ),
      )),
    );
  }

  Widget renderDateHeader(String selectedDate) {
    return Text(
      selectedDate,
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget renderPillCard(List<MedicationScheduleBoxModel> pillListPerSchedules) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const CardTitle(title: ''),
        Expanded(
          child: SingleChildScrollView(
            child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 1.0),
                //border radius 주기위해!
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(4.0),
                        bottomRight: Radius.circular(4.0))),
                //color: lightColor,
                child: Column(
                  children:
                  pillListPerSchedules.map((pillListPerTimeBox)=> LogCardList(title: pillListPerTimeBox.title, takingTime: pillListPerTimeBox.takeDateTime!, medicineList : pillListPerTimeBox.medicines!)).toList()

                )),
          ),
        )
      ],
    );
  }
}
