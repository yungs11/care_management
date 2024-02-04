import 'package:care_management/layout/join_layout.dart';
import 'package:care_management/layout/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:care_management/component/account_custom.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return JoinLayout(
      appBartitle: '',
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTitle(titleText: '비밀번호를 입력해주세요 :)'),
            SizedBox(
              height: 5.0,
            ),
            SubTitle(
              subTitleText: '환영합니다.',
            ),
            SizedBox(
              height: 53.0,
            ),
            CustomTextField(),
            SizedBox(
              height: 60.0,
            ),
            DoneButton(
              onButtonPressed: () {},
              buttonText: '로그인',
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                '비밀번호를 잊으셨나요?',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            )
          ],
        ),
      )),
    );
  }
}
