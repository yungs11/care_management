import 'package:care_management/const/colors.dart';
import 'package:flutter/material.dart';

class CardTitle extends StatelessWidget {
  final String title;
  const CardTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
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
                style: TextStyle(fontWeight: FontWeight.w700),
                //textAlign: TextAlign.c,
              ),
              Text(
                '오늘',
                style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey),
                //textAlign: TextAlign.left,
              ),
            ],
          ),
        ));
  }
}
