import 'dart:convert';

import 'package:care_management/common/component/dialog.dart';
import 'package:care_management/common/const/data.dart';
import 'package:care_management/common/dio/dio.dart';
import 'package:care_management/common/layout/join_layout.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/common/secure_storage/secure_storage.dart';
import 'package:care_management/screen/auth/id_input_screen.dart';
import 'package:care_management/screen/auth/renew_password_screen.dart';
import 'package:care_management/screen/user_main_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:care_management/common/component/custom_components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final String userId;

  const LoginScreen({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dio = ref.watch(dioProvider);
    print('userId > ${widget.userId}');

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
            CustomTextField(
              labelText: '',
              controller: _textController,
            ),
            const SizedBox(
              height: 60.0,
            ),
            DoneButton(
              onButtonPressed: () async {
                //id, pwd
                final rawString = '${widget.userId}:${_textController.text}';

                print(rawString);
                Codec<String, String> stringToBase64 = utf8.fuse(base64);
                String token = stringToBase64.encode(rawString);

                Map<String, dynamic> body = {
                  "email":
                      widget.userId, //'lafin716@naver.com', //widget.userId,
                  "password":
                      _textController.text, //'test', //_textController.text,
                  "auto_login": true
                };

                print('${apiIp}/auth/signin');

                try {
                  final resp = await dio.post('${apiIp}/auth/signin',
                      /*options: Options(headers: {
                        'authorization': 'Bearer $token',
                      }),*/
                      data: body);

                  print(resp);

                  final responseData = resp.data['data']; // 최상위 'data' 필드에 접근
                  final refreshToken = responseData[
                      'refresh_token']; // 'data' 객체 내의 'refresh_token'
                  final accessToken = responseData[
                      'access_token']; // 'data' 객체 내의 'access_token'

                  final storage = ref.read(secureStorageProvider);

                  await storage.write(
                      key: REFRESH_TOKEN_KEY, value: refreshToken);
                  await storage.write(
                      key: ACCESS_TOKEN_KEY, value: accessToken);

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => MainLayout(
                          appBartitle: '',
                          body: UserMainScreen(),
                          addPadding: false,
                        ),
                      ),
                      (route) => false);
                } on DioException catch (e) {
                  print(e.response);
                  if (e.response!.data['errors'] != null) {
                    return CustomDialog.showAlert(
                        context,
                        e.response!.data['errors'].values
                            .toString()
                            .replaceAll(RegExp(r'\(|\)'), ''));
                  } else {
                    return CustomDialog.showAlert(
                        context, e.response!.data['message']);
                  }
                } catch (e) {
                  print(e);
                }
              },
              buttonText: '로그인',
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => RenewPasswordScreen(
                      userId: widget.userId,
                    )));
              },
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
