import 'package:care_management/common/component/custom_components.dart';
import 'package:care_management/common/component/dialog.dart';
import 'package:care_management/common/const/data.dart';
import 'package:care_management/common/dio/dio.dart';
import 'package:care_management/common/layout/join_layout.dart';
import 'package:care_management/screen/auth/id_input_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpScreen extends StatefulWidget {
  final String userId;
  SignUpScreen({
    super.key,
    required this.userId,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nickNameCntrler = TextEditingController();

  final TextEditingController _passwordCntrler = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _nickNameCntrler.dispose();
    _passwordCntrler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context)
        .viewInsets
        .bottom; //시스템적 UI 때문에 가려진 UI 사이즈(키보드가 차지하는 부분)
    final dio = Dio();

    return JoinLayout(
      appBartitle: '',
      body: Padding(
        padding: EdgeInsets.only(
          left: 32.0,
          right: 32.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CustomTitle(titleText: '닉네임과 비밀번호를 입력해주세요 :)'),
            const SizedBox(
              height: 5.0,
            ),
            const SubTitle(
              subTitleText: '새로운 방문을 환영합니다.',
            ),
            const SizedBox(
              height: 53.0,
            ),
            Column(
              children: [
                CustomTextField(
                  labelText: '닉네임',
                  controller: _nickNameCntrler,
                ),
                SizedBox(
                  height: 30.0,
                ),
                CustomTextField(
                  labelText: '비밀번호',
                  controller: _passwordCntrler,
                ),
                SizedBox(
                  height: 30.0,
                ),
                /* CustomTextField(
                  labelText: '비밀번호 확인',
                  controller: _passwordCntrler2,
                ),*/
              ],
            ),
            const SizedBox(
              height: 60.0,
            ),
            DoneButton(
              onButtonPressed: () async {
                // if (_passwordCntrler.text != _passwordCntrler2.text) {}

                try {
                  print( _nickNameCntrler.text);
                  print(widget.userId);
                  print(_passwordCntrler.text);

                  final resp = await dio.post('${apiIp}/auth/signup', data: {
                    'name': _nickNameCntrler.text,
                    'email': widget.userId,
                    'password': _passwordCntrler.text
                  });

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => IdInputScreen()),
                          (route) => false);

                } on DioException catch (e) {

                  print(e.response);

                  if(e.response!.data['errors'] != null){
                    return CustomDialog.showAlert(
                        context, e.response!.data['errors'].values.toString().replaceAll(RegExp(r'\(|\)'),''));
                  }else{
                    return CustomDialog.showAlert(
                        context, e.response!.data['message']);
                  }
                }catch(e){
                  print(e);
                }
              },
              buttonText: '가입하기',
            ),
          ],
        ),
      ),
    );
  }
}
