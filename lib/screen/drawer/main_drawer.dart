import 'package:care_management/common/component/dialog.dart';
import 'package:care_management/common/const/colors.dart';
import 'package:care_management/common/const/data.dart';
import 'package:care_management/common/dio/dio.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/common/secure_storage/secure_storage.dart';
import 'package:care_management/common/util/errorUtil.dart';
import 'package:care_management/screen/doseLog/dose_log_screen.dart';
import 'package:care_management/screen/auth/id_input_screen.dart';
import 'package:care_management/screen/medication_time_manage/med_time_manage_screen.dart';
import 'package:care_management/screen/prescriptionHistory/prescription_history_screen.dart';
import 'package:care_management/screen/prescriptionRegistration/prescription_bag_input_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainDrawer extends ConsumerStatefulWidget {
  const MainDrawer({super.key});

  @override
  ConsumerState<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends ConsumerState<MainDrawer> {

  String selectedMenu = "";

  @override
  Widget build(BuildContext context) {
    final dio = ref.watch(dioProvider);
    final storageProvider = ref.watch(secureStorageProvider);

    final menus = [
      ScreenModel(
          builder: (_) => MainLayout(
                appBartitle: '약봉투 등록',
                body: PrescriptionBagInputScreen(),
                addPadding: true,
              ),
          name: '약봉투 등록'),
      ScreenModel(
          builder: (_) => MainLayout(
                appBartitle: '처방 내역',
                body: PrescriptionHistoryScreen(
                    selectedDate: DateTime(2023, 12, 29)),
                addPadding: false,
              ),
          name: '처방 내역'),
      ScreenModel(
          builder: (_) => DoseLogScreen(
                selectedDate: '2023년 12월 29일 (금)',
              ),
          name: '복용 내용'),
      ScreenModel(builder: (_) => MedTimeManageScreen(), name: '복약 시간대 관리'),
    ];

    print(selectedMenu);

    return Drawer(
        //backgroundColor: ,
        child: Column(children: [
      DrawerHeader(
          child: Text(
        '좋은 하루 되세요 :)',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
        ),
      )),
      ...menus
          .map(
            (menu) => ListTile(
              // tileColor: Colors.black45,
              selectedTileColor: Colors.grey, //선택이 된 상태에서 배경색
              selectedColor: PRIMARY_COLOR, //선택이 된 상태에서 글자색
              selected: selectedMenu == menu.name, //위에 selectedCOlor로 해놓은거 반영
              onTap: () {
                setState(() {
                  selectedMenu = menu.name;
                });
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: menu.builder));
              },
              title: Text(menu.name),
            ),
          )
          .toList(),
      Spacer(),
      ListTile(
        onTap: () async{

          try{
            final resp = await dio.post('${apiIp}/auth/signout'
                , options: Options(
                  headers: {'accessToken':'true'},
                ));
            print(resp);

            await storageProvider.deleteAll();

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => IdInputScreen()),
                    (route) => false);
          }on DioException catch(e){
           CustomDialog.errorAlert(context, e);
          }
        },
        title: Align(
            alignment: Alignment.centerRight,
            child: Text(
              '로그아웃',
              style: TextStyle(
                color: Colors.grey,
              ),
            )),
      )
    ]));
  }
}
