import 'package:care_management/common/layout/join_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:care_management/common/component/custom_components.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

  /*
    final emulatorIp = '10.0.2.2:3000';
    final simulatorIp = '127.0.0.1:3000';

    final ip = Platform.isIOS? simulatorIp : emulatorIp;*/

    return JoinLayout(
      appBartitle: '',
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CustomTitle(titleText: '비밀번호를 입력해주세요 :)'),
            const SizedBox(
              height: 5.0,
            ),
            const SubTitle(
              subTitleText: '환영합니다.',
            ),
            const SizedBox(
              height: 53.0,
            ),
            const CustomTextField(labelText: '',),
            const SizedBox(
              height: 60.0,
            ),
            DoneButton(
              onButtonPressed: () async {
              /*  final rawString = 'test@codefactory.ai:testtest';

                Codec<String, String> stringToBase64 = utf8.fuse(base64);

                String token = stringToBase64.encode(rawString);*/

                Map<String, dynamic> body =  {
                  "email": "lafin716@naver.com",
                  "password": "test",
                  "auto_login": true
                };
                String str = body.toString();

                final resp = await Dio().post(
                    'http://192.168.217.128:8080/api/v1/auth/signin',
                    data: body);

                print(resp.data);
              },
              buttonText: '로그인',
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
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
