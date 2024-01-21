import 'package:flutter/material.dart';
import 'package:care_management/const/colors.dart';

class CustomTitle extends StatelessWidget {
  final String titleText;

  const CustomTitle({super.key, required this.titleText});

  @override
  Widget build(BuildContext context) {
    return Text(
      titleText,
      style: TextStyle(
        fontSize: 24.0,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w900,
        //fontFamily:
      ),
    );
  }
}

class SubTitle extends StatelessWidget {
  final String subTitleText;
  const SubTitle({super.key, required this.subTitleText});

  @override
  Widget build(BuildContext context) {
    return Text(
      subTitleText,
      style: TextStyle(
        fontSize: 15,
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0x33000000), width: 1.5),
        ),
        /*border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 3),
        ),*/
      ),
    );
  }
}

class DoneButton extends StatelessWidget {
  final VoidCallback onButtonPressed;
  final String buttonText;

  const DoneButton(
      {super.key, required this.onButtonPressed, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onButtonPressed,
        style: ElevatedButton.styleFrom(
          primary: PRIMARY_COLOR,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          padding: EdgeInsets.all(32.0),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            color: Colors.white,
          ),
        ));
  }
}
