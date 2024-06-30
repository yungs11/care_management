import 'package:care_management/common/component/custom_components.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/screen/auth/join_screen.dart';
import 'package:care_management/screen/auth/login_screen.dart';
import 'package:care_management/screen/auth/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IdInputScreen extends ConsumerStatefulWidget {
  const IdInputScreen({super.key});

  @override
  ConsumerState<IdInputScreen> createState() => _IdInputScreenState();
}

class _IdInputScreenState extends ConsumerState<IdInputScreen> {
  String userId = '';
  TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*final screens = [
      ScreenModel(builder: (_) => const RenewPasswordScreen(), name: '비밀번호변경'),
      ScreenModel(
          builder: (_) => SignUpScreen(
                userId: textController.text,
              ),
          name: '가입하기'),
      ScreenModel(builder: (_) => const UserMainScreen(), name: '메인페이지'),
      ScreenModel(builder: (_) => const CalendarScreen(), name: '날짜선택페이지'),
      ScreenModel(
          builder: (_) => const PrescriptionBagInputScreen(),
          name: '약봉투 등록 페이지'),
      ScreenModel(
          builder: (_) => const PrescriptionBagDosageSceduleScreen(),
          name: '복약계획 등록 페이지'),
      ScreenModel(
          builder: (_) => const DoseLogScreen(
                selectedDate: '2023년 12월 29일 (금)',
              ),
          name: '복용 내역 페이지'),
    ];*/

    return MainLayout(
      appBartitle: '',
      addPadding: true,
      showBottomNavigator: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Column(
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
            const SizedBox(
              height: 53.0,
            ),
            CustomTextField(
              labelText: '',
              controller: textController,
            ),
            const SizedBox(
              height: 60.0,
            ),
            DoneButton(
                onButtonPressed: () async {
                  final authService = ref.read(authServiceProvider);
                  final resp = await authService.checkUser(textController.text);
                  if (resp == 'login') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => LoginScreen(
                              userId: textController.text,
                            )));
                  } else if (resp == 'join') {
                    //가입이 가능한 상태(중복 이메일 없음)
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => SignUpScreen(
                              userId: textController.text,
                            )));
                  }
                },
                buttonText: '확인'),
            /* Column(
                children: screens
                    .map((screen) => ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: screen.builder));
                          },
                          child: Text(screen.name),
                        ))
                    .toList()),*/
          ],
        ),
      ),
    );
  }
}
