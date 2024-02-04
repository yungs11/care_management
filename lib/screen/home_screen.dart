import 'package:care_management/layout/main_layout.dart';
import 'package:care_management/screen/login_screen.dart';
import 'package:care_management/screen/renew_password_screen.dart';
import 'package:care_management/screen/join_screen.dart';
import 'package:care_management/screen/user_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:care_management/component/account_custom.dart';
import 'package:dio/dio.dart';

//테스트용
class ScreenModel {
  final WidgetBuilder builder;
  final String name;

  ScreenModel({required this.builder, required this.name});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();


}

class _HomeScreenState extends State<HomeScreen> {

  void initState(){
    super.initState();
    fetchData();
  }

  fetchData() async{
    final result = await Dio().get('https://199e-125-242-126-203.ngrok-free.app/api/v1',
      queryParameters: {

      }
    );

    print(result  );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      ScreenModel(builder: (_) => LoginScreen(), name: '로그인'),
      ScreenModel(builder: (_) => RenewPasswordScreen(), name: '비밀번호변경'),
      ScreenModel(builder: (_) => SignUpScreen(), name: '가입하기'),
      ScreenModel(builder: (_) => UserMainScreen(), name: '메인페이지'),
    ];

    return MainLayout(
      appBartitle: '',
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTitle(titleText: '이메일을 입력해주세요 :)'),
                SizedBox(
                  height: 5.0,
                ),
                SubTitle(
                  subTitleText: '가입 혹은 로그인에 필요합니다.',
                ),
              ],
            ),
            SizedBox(
              height: 53.0,
            ),
            CustomTextField(),
            SizedBox(
              height: 60.0,
            ),
            DoneButton(
                onButtonPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => LoginScreen()));
                },
                buttonText: '확인'),
            Column(
                children: screens
                    .map((screen) => ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: screen.builder));
                          },
                          child: Text(screen.name),
                        ))
                    .toList()),
          ],
        ),
      )),
    );
  }
}
