import 'package:care_management/component/account_custom.dart';
import 'package:care_management/layout/main_layout.dart';
import 'package:flutter/material.dart';

class RenewPasswordScreen extends StatelessWidget {
  const RenewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(appBartitle: '', body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTitle(titleText: '새로운 비밀번호를 입력해주세요 :)'),
              SizedBox(
                height: 5.0,
              ),
              SubTitle(
                subTitleText: '',
              ),
              SizedBox(
                height: 53.0,
              ),
              Column(
                children: [
                  CustomTextField(),
                  SizedBox(
                    height: 30.0,
                  ),
                  CustomTextField(),
                ],
              ),
              SizedBox(
                height: 60.0,
              ),
              DoneButton(
                onButtonPressed: () {},
                buttonText: '변경하기',
              ),
            ],
          ),
        )),
    );
  }
}
