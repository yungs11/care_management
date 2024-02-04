import 'package:flutter/material.dart';

class TabInfo{
  final String iconImaPath; //tab에 보여줄 아이콘 이미지 패스
  final String label; //아이콘 밑에 보여줄 레이블

  const TabInfo({
    required this.iconImaPath,
    required this.label,

  });
}


const TABS= [
  TabInfo(iconImaPath: 'asset/icon/pinpaper-plus.png', label: '처방등록'),
  TabInfo(iconImaPath: 'asset/icon/capsule-blister.png', label: '복용내용'),
  TabInfo(iconImaPath: 'asset/icon/pinpaper-filled.png' , label: '처방 내역'),
];