
import 'package:care_management/screen/doseLog/dose_log_screen.dart';
import 'package:care_management/screen/prescriptionHistory/prescription_his_detail_screen.dart';
import 'package:care_management/screen/prescriptionHistory/prescription_history_screen.dart';
import 'package:care_management/screen/prescriptionRegistration/prescription_bag_input_screen.dart';
import 'package:care_management/screen/userMain/user_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TabInfo{
  final Widget screen;
  final String iconImaPath; //tab에 보여줄 아이콘 이미지 패스
  final String label; //아이콘 밑에 보여줄 레이블
  final String appBartitle;
  final bool addPadding;


  const TabInfo({
    required this.iconImaPath,
    required this.label,
    required this.screen,
    required this.appBartitle,
    required this.addPadding,
  });
}

final TABS= [
  TabInfo(
          iconImaPath: 'asset/icon/pinpaper-plus.png',
          label: '약봉투 등록',
          screen : const PrescriptionBagInputScreen(),
          appBartitle: '처방전 등록',
          addPadding: true
      ),
  TabInfo(
          iconImaPath: 'asset/icon/capsule-blister.png',
          label: '오늘 관리',
          screen: const UserMainScreen(),
          addPadding: false,
          appBartitle: ''
      ),
  TabInfo(
          iconImaPath: 'asset/icon/pinpaper-filled.png',
          label: '처방 내역',
          screen: PrescriptionHistoryDetailScreen(selectedDate: DateFormat('yyyy-MM-dd').format(DateTime.now().toUtc()),),
          addPadding: false,
          appBartitle: '처방 내역',
      ),
];

