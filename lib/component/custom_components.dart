import 'package:flutter/material.dart';
import 'package:care_management/const/colors.dart';
import 'package:flutter/services.dart';

class CustomTitle extends StatelessWidget {
  final String titleText;

  const CustomTitle({super.key, required this.titleText});

  @override
  Widget build(BuildContext context) {
    return Text(
      titleText,
      style: const TextStyle(
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
      style: const TextStyle(
        fontSize: 15,
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String? suffixText;
  final bool? isNumber;
  //final String hintText;
  final TextEditingController? controller;

  const CustomTextField(
      {super.key,
      required this.labelText,
      //  required this.hintText,
      this.controller, this.suffixText, this.isNumber = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
       /* Expanded(
            child: Text(labelText,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0))),
        SizedBox(height: 8.0),*/
        Expanded(
          flex: 3,
          child: TextField(
            controller: controller,
            keyboardType: !isNumber! ? TextInputType.text : TextInputType.number,
            textAlign: TextAlign.right,
            inputFormatters: !isNumber! ? [] : [
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              labelText: labelText,
            //  icon: Text(labelText, style: TextStyle(fontSize: 16.0),),
            //  prefix: Text('뭐지?'),
              suffix: Text(suffixText ?? ''),
              labelStyle: TextStyle(fontSize: 16.0, ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0x33000000), width: 1.5),
              ),
              /*border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 3),
              ),*/
            ),
          ),
        ),
      ],
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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: onButtonPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor, // 테마에 맞는 버튼 색상
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            padding: const EdgeInsets.all(32.0),
          ),
          child: Text(
            buttonText,
          )),
    );
  }
}

class CustomDatePicker extends StatefulWidget {
  final String labelText;
  //final String hintText;
  final TextEditingController dateController;

  const CustomDatePicker(
      {super.key,
        required this.labelText,
        //  required this.hintText,
        required this.dateController});

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();


}

class _CustomDatePickerState extends State<CustomDatePicker> {


  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Theme.of(context).primaryColor.withAlpha(128), // 헤더 배경 색상
            //accentColor: Colors.blue, // 선택된 날짜 및 현재 날짜 색상
            colorScheme: ColorScheme.light(primary: Theme.of(context).primaryColor.withOpacity(0.5)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },

    );
    if (picked != null && picked != DateTime.now())
      setState(() {
        widget.dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        /* Expanded(
            child: Text(labelText,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0))),
        SizedBox(height: 8.0),*/
        Expanded(
          flex: 3,
          child: InkWell(
            onTap: () => _selectDate(context),
            child: IgnorePointer(
              child: TextField(
                controller: widget.dateController,
                keyboardType: TextInputType.datetime,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  labelStyle: TextStyle(fontSize: 16.0, ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0x33000000), width: 1.5),
                  ),
                  /*border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 3),
                  ),*/
                ),
              ),
            ),
          ),
        ),
      ],
    );;
  }
}

