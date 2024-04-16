
import 'package:care_management/screen/doseLog/dose_log_screen.dart';
import 'package:care_management/screen/prescriptionHistory/prescription_history_screen.dart';
import 'package:care_management/screen/prescriptionRegistration/prescription_bag_input_screen.dart';
import 'package:care_management/screen/user_main_screen.dart';
import 'package:flutter/material.dart';

class TabInfo{
  final Widget screen;
  final String iconImaPath; //tab에 보여줄 아이콘 이미지 패스
  final String label; //아이콘 밑에 보여줄 레이블


  const TabInfo({
    required this.iconImaPath,
    required this.label,
    required this.screen,

  });
}


final TABS= [
  TabInfo(
          iconImaPath: 'asset/icon/pinpaper-plus.png',
          label: '약봉투 등록',
          screen : const PrescriptionBagInputScreen(),
      ),
  TabInfo(
          iconImaPath: 'asset/icon/capsule-blister.png',
          label: '오늘 관리',
            screen: const UserMainScreen(),
      ),
  TabInfo(
          iconImaPath: 'asset/icon/pinpaper-filled.png',
          label: '처방 내역',
          screen: PrescriptionHistoryScreen(selectedDate: DateTime(2023,12,29),),
      ),
];

