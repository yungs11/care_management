import 'package:care_management/const/colors.dart';
import 'package:flutter/material.dart';

class CardList extends StatelessWidget {
  final String title;
  final String takingTime;
  String? dayOrNight;

  CardList({super.key, required this.title, required this.takingTime});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [renderCardList()],
    );
  }

  Widget renderCardList() {
    return Container(
      height: 70.0,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
            flex: 1,
            child: IconButton(
                onPressed: () {}, icon: Icon(Icons.circle_outlined, color: PRIMARY_COLOR,))),
        Expanded(
          flex: 2,
          child: Text(title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                  fontSize: 15.0
              )),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Text(takingTime,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0
                  )),
              SizedBox(width: 20.0,),
              Text(
                'AM',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                    fontSize: 12.0
                ),
              ),
            ],
          ),
        ),
        IconButton(
            onPressed: () {},
            icon: ImageIcon(AssetImage('asset/icon/bottom_arrow.png'))),
      ]),
    );
  }
}
