import 'package:care_management/common/const/colors.dart';
import 'package:care_management/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //flutter framework가 준비가 되었는지 기다림. (runApp하면 자동으로 실행함.)

  await initializeDateFormatting();

  runApp(ProviderScope(
    child: MaterialApp(
      //한글 다이어그램 지정
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate, //for 안드로이드
        GlobalCupertinoLocalizations.delegate, //for IOS
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko', 'KO'),
      ],
      locale: Locale('ko'),
      theme: ThemeData(fontFamily: 'Pretendard', primaryColor: PRIMARY_COLOR,
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
      )),
      home: const HomeScreen(),
    ),
  ));
}
/* theme: ThemeData(
      fontFamily: 'Pretendard',
      textTheme: TextTheme(
          */ /*headline1: TextStyle(
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
