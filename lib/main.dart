import 'package:care_management/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); //flutter framework가 준비가 되었는지 기다림. (runApp하면 자동으로 실행함.)

  await initializeDateFormatting();

  runApp(MaterialApp(
      theme: ThemeData(fontFamily: 'Pretendard'),
      home: const HomeScreen(),

  ));
}
  /* theme: ThemeData(
      fontFamily: 'Pretendard',
      textTheme: TextTheme(
          *//*headline1: TextStyle(
            color: Colors.white,
            fontFamily: 'parisienne',
            fontSize: 80,
          ),
          headline2:TextStyle(
              color: Colors.white,
              fontSize: 50.0,
              fontWeight: FontWeight.w700),
          bodyText1: TextStyle(
              color: Colors.white,
              fontSize: 30),
          bodyText2: TextStyle(
              color: Colors.white,
              fontSize: 20.0)
      ),
    ),*/