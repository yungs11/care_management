import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/screen/DoseLog/dose_log_screen.dart';
import 'package:care_management/screen/medication_time_manage/med_time_manage_screen.dart';
import 'package:care_management/screen/prescriptionHistory/prescription_history_screen.dart';
import 'package:care_management/screen/medication_time_manage/med_time_manage_input_screen.dart';
import 'package:care_management/screen/search/calendar_screen.dart';
import 'package:care_management/screen/auth/login_screen.dart';
import 'package:care_management/screen/prescriptionRegistration/prescription_bag_dosage_schedule_screen.dart';
import 'package:care_management/screen/prescriptionRegistration/prescription_bag_input_screen.dart';
import 'package:care_management/screen/auth/renew_password_screen.dart';
import 'package:care_management/screen/auth/join_screen.dart';
import 'package:care_management/screen/user_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:care_management/common/component/custom_components.dart';
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
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    final result = await Dio().get(
        'https://199e-125-242-126-203.ngrok-free.app/api/v1',
        queryParameters: {});

    print(result);
  }

  @override
  Widget build(BuildContext context) {
    /*TextEditingController controller =
    TextEditingController();
    ;*/

    final screens = [
      ScreenModel(builder: (_) => const LoginScreen(), name: '로그인'),
      ScreenModel(builder: (_) => const RenewPasswordScreen(), name: '비밀번호변경'),
      ScreenModel(builder: (_) => const SignUpScreen(), name: '가입하기'),
      ScreenModel(builder: (_) => const UserMainScreen(), name: '메인페이지'),
      ScreenModel(builder: (_) => const CalendarScreen(), name: '날짜선택페이지'),
      ScreenModel(
          builder: (_) => const PrescriptionBagInputScreen(),
          name: '약봉투 등록 페이지'),
      ScreenModel(
          builder: (_) => const PrescriptionBagDosageSceduleScreen(),
          name: '복약계획 등록 페이지'),
      ScreenModel(
          builder: (_) => const DoseLogScreen(selectedDate: '2023년 12월 29일 (금)',),
          name: '복용 내역 페이지'),
      ScreenModel(
          builder: (_) => PrescriptionHistoryScreen(selectedDate: DateTime(2023,12,29),),
          name: '처방 내역 페이지'),
      ScreenModel(
          builder: (_) => MedTimeManageScreen(),
          name: '복약 시간대 관리 페이지'),
    ];

    return MainLayout(
      appBartitle: '',
      addPadding: true,
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
            ),
            const SizedBox(
              height: 60.0,
            ),
            DoneButton(
                onButtonPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
                buttonText: '확인'),
            Column(
                children: screens
                    .map((screen) => ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: screen.builder));
                          },
                          child: Text(screen.name),
                        ))
                    .toList()),
          ],
        ),
      ),
    );
  }
}
