import 'package:care_management/common/component/main_card_list.dart';
import 'package:care_management/common/component/card_title.dart';
import 'package:care_management/common/const/colors.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/common/model/medication_schedule_box_model.dart';
import 'package:care_management/common/model/taking_medicine_item_model.dart';
import 'package:flutter/material.dart';

class UserMainScreen extends StatelessWidget {
  const UserMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List tempDateBoxData = [
      {
        'date': '27',
        'day': '수',
      },
      {
        'date': '28',
        'day': '목',
      },
      {
        'date': '29',
        'day': '금',
      },
      {
        'date': '30',
        'day': '토',
      },
      {
        'date': '31',
        'day': '일',
      },
    ];

    List<MedicationScheduleBoxModel> pillListPerSchedules = [
      MedicationScheduleBoxModel(
        title: '아침 약',
        memo: '먹는데 어렵지 않았따!',
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
          memo: '재밌다!',
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
        memo: '건강해졌으면 좋겠다!',
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

    return SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            renderDateHeader(),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //children: tempDateBoxData.map((e) => renderDateBox(e)).toList(),
              children: List.generate(tempDateBoxData.length,
                  (i) => renderDateBox(tempDateBoxData[i], i == 2)),
            ),
            const SizedBox(
              height: 50.0,
            ),
            Expanded(child: renderPillCard(pillListPerSchedules)),
          ],
        ),
      ));
  }

  Widget renderDateHeader() {
    return const Row(children: [
      Text(
        '12월, 2023',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
        ),
      ),
      SizedBox(
        width: 10.0,
      ),
      ImageIcon(AssetImage('asset/icon/calendar.png')),
    ]);
  }

  Widget renderDateBox(mapData, isSelected) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: isSelected ? PRIMARY_COLOR : const Color(0xFFE0E0E0),
            width: 3.0),
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      width: 55.0,
      height: 82.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            mapData['date'],
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            mapData['day'],
            style: const TextStyle(fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  Widget renderPillCard(List<MedicationScheduleBoxModel> pillListPerSchedules) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const CardTitle(title: '12월 29일 (금)'),
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
                  children: pillListPerSchedules
                      .map((pillListPerTimeBox) => MainCardList(
                          title: pillListPerTimeBox.title,
                          memo: pillListPerTimeBox.memo == null? '' : pillListPerTimeBox.memo,
                          takingTime: pillListPerTimeBox.takeDateTime!,
                          medicineList: pillListPerTimeBox.medicines!))
                      .toList(),
                )),
          ),
        )
      ],
    );
  }
}
