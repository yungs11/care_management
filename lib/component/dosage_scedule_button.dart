import 'package:care_management/const/colors.dart';
import 'package:flutter/material.dart';

class DosageScheduleButton extends StatelessWidget {
  final String scheduleTitle;
  final VoidCallback onPressed;
  final bool isBoxSelected;

  const DosageScheduleButton(
      {super.key,
      required this.scheduleTitle,
      required this.onPressed,
      required this.isBoxSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: FractionalOffset.centerLeft,
          child: Text(
            scheduleTitle,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        /* Ink(
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: PRIMARY_COLOR, width: 2.0))),
          child: IconButton(
            icon: Icon(Icons.add),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 20.0),
            onPressed: () {},
          ),
        ),*/
        Container(
          margin: EdgeInsets.only(bottom: 15.0),
          width: double.infinity,
          height: 130,
          child: TextButton(
            style: TextButton.styleFrom(
              //padding: EdgeInsets.symmetric(vertical: 20.0),,
              //    backgroundColor: Colors.green,
              foregroundColor: isBoxSelected ? PRIMARY_COLOR : NON_SELECTED_COLOR,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                    color: isBoxSelected ? PRIMARY_COLOR : NON_SELECTED_COLOR,
                    width: 2.0),
              ),
            ),
            child: Icon(Icons.add, size: 24),
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}
