import 'package:care_management/common/const/colors.dart';
import 'package:flutter/material.dart';

class CardTitle extends StatelessWidget {
  final String title;
  final bool isToday;
  const CardTitle({super.key, required this.title, required this.isToday});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: PRIMARY_COLOR,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(4.0), topLeft: Radius.circular(4.0)),
        ),
        height: 70.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w700),
                //textAlign: TextAlign.c,
              ),
              Text(
                isToday ? '오늘' : '',
                style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey),
                //textAlign: TextAlign.left,
              ),
            ],
          ),
        ));
  }
}
