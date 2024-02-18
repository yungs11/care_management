import 'package:care_management/component/account_custom.dart';
import 'package:care_management/component/card_list.dart';
import 'package:care_management/component/card_title.dart';
import 'package:care_management/const/colors.dart';
import 'package:care_management/layout/main_layout.dart';
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

    return MainLayout(
      appBartitle: '',
      body: SafeArea(
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
            Expanded(child: renderPillCard()),
          ],
        ),
      )),
    );
    ;
  }

  Widget renderDateHeader() {
    return Row(children: [
      Text(
        '12월, 2023',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(
        width: 10.0,
      ),
      ImageIcon(AssetImage('asset/icon/calendar.png')),
    ]);
  }

  Widget renderDateBox(mapData, isSelected) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: isSelected ? PRIMARY_COLOR : Color(0xFFE0E0E0), width: 3.0),
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      width: 55.0,
      height: 82.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            mapData['date'],
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            mapData['day'],
            style: TextStyle(fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  Widget renderPillCard() {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CardTitle(title: '12월 29일 (금)'),
        Expanded(
          child: SingleChildScrollView(
            child: Card(
            
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              //border radius 주기위해!
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(4.0),
                      bottomRight: Radius.circular(4.0))),
              //color: lightColor,
              child: Column(
                children: [
                  CardList(
                    title: '아침 식전',
                    takingTime: '09:05',
                  ),
                  CardList(
                    title: '점심 식후',
                    takingTime: '12:05',
                  ),
                  CardList(
                    title: '저녁 식후',
                    takingTime: '19:05',
                  ),
            
            
                ],
              )
            ),
          ),
        )
      ],
    );
  }
}
