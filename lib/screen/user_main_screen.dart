import 'package:care_management/common/component/dialog.dart';
import 'package:care_management/common/component/main_card_list.dart';
import 'package:care_management/common/component/card_title.dart';
import 'package:care_management/common/const/colors.dart';
import 'package:care_management/common/const/data.dart';
import 'package:care_management/common/dio/dio.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/common/model/medication_schedule_box_model.dart';
import 'package:care_management/common/model/taking_medicine_item_model.dart';
import 'package:care_management/common/util/formatUtil.dart';
import 'package:care_management/screen/search/calendar_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class UserMainScreen extends ConsumerStatefulWidget {
  const UserMainScreen({super.key});

  @override
  ConsumerState<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends ConsumerState<UserMainScreen> {
  DateTime selectedDay = DateTime.now().toUtc();
  Future<List<MedicationScheduleBoxModel>>? dataFuture;

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    dataFuture = fetchPlans();
  }


  Future<List<MedicationScheduleBoxModel>> fetchPlans() async {
    List<MedicationScheduleBoxModel> scheduleBoxModel = [];

    final dio = ref.watch(dioProvider);

    try {
      final resp = await dio.get('${apiIp}/plan',
          options: Options(headers: {'accessToken': 'true'}),
          queryParameters: {
            'date': DateFormat('yyyy-MM-dd').format(selectedDay)
          });
      scheduleBoxModel = resp.data['data']['plans']
          .map<MedicationScheduleBoxModel>(
              (e) => MedicationScheduleBoxModel.fromJson(json: e))
          .toList();

      //     ref.read(MedicationScheduleBoxProvider.notifier).initMedicationBoxModel(scheduleBoxModel);

      print(
          '>>>>>>>>>>> ${scheduleBoxModel.map((e) => e.pills!.map((ek) => print(ek.pillName)))}');
    } on DioException catch (e) {
      CustomDialog.errorAlert(context, e);
    } catch (e) {
      print(e);
    }

    return scheduleBoxModel;
  }
  void reloadData() {
    setState(() {
      dataFuture = fetchPlans();  // 데이터 재요청
    });
  }



  @override
  Widget build(BuildContext context) {
    print('선택날짜 >>> ${selectedDay}');

    return FutureBuilder<List<MedicationScheduleBoxModel>>(
        future: dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // 로딩 인디케이터 표시
          } else if (snapshot.hasError) {
            return Center(
                child: Text('오류가 발생하였습니다: ${snapshot.error}')); // 오류 메시지 표시
          } else {
          return SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                renderDateHeader(context),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: renderDateBox(),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                 Expanded(child: renderPillCard(snapshot.data!)),
              ],
            ),
          ));
        }});
  }

  Widget renderDateHeader(BuildContext context) {
    return Row(children: [
      Text(
        '${selectedDay.month}월, ${selectedDay.year}',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
        ),
      ),
      SizedBox(
        width: 0,
      ),
      IconButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => CalendarScreen(searchDay: selectedDay,)));
        },
        icon: ImageIcon(AssetImage('asset/icon/calendar.png')),
      )
    ]);
  }

  List<Widget> renderDateBox() {
    List dateBoxData = [
      {
        'date': selectedDay.subtract(Duration(days: 2)),
        'day': selectedDay.subtract(Duration(days: 2)).day,
        'weekday': FormatUtil.getWeekdayName(
            selectedDay.subtract(Duration(days: 2)).weekday),
      },
      {
        'date': selectedDay.subtract(Duration(days: 1)),
        'day': selectedDay.subtract(Duration(days: 1)).day,
        'weekday': FormatUtil.getWeekdayName(
            selectedDay.subtract(Duration(days: 1)).weekday),
      },
      {
        'date': selectedDay,
        'day': selectedDay.day,
        'weekday': FormatUtil.getWeekdayName(selectedDay.weekday),
      },
      {
        'date': selectedDay.add(Duration(days: 1)),
        'day': selectedDay.add(Duration(days: 1)).day,
        'weekday': FormatUtil.getWeekdayName(
            selectedDay.add(Duration(days: 1)).weekday),
      },
      {
        'date': selectedDay.add(Duration(days: 2)),
        'day': selectedDay.add(Duration(days: 2)).day,
        'weekday': FormatUtil.getWeekdayName(
            selectedDay.add(Duration(days: 2)).weekday),
      },
    ];

    return List.generate(
        dateBoxData.length,
        (index) => InkWell(
              onTap: () {
                  selectedDay = dateBoxData[index]['date'];
                  reloadData();
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color:
                          index == 2 ? PRIMARY_COLOR : const Color(0xFFE0E0E0),
                      width: 3.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                width: 55.0,
                height: 82.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dateBoxData[index]['day'].toString(),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      dateBoxData[index]['weekday'].toString(),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            ));
  }

  Widget renderPillCard(List<MedicationScheduleBoxModel> takingTimezoneBoxList) {
    String yyyyMMDDSelectedDay = DateFormat('yyyyMMdd').format(selectedDay);
    String yyyyMMDDNowDay =
        DateFormat('yyyyMMdd').format(DateTime.now().toUtc());

    print('지금날짜 >>>> ${yyyyMMDDNowDay}');

    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CardTitle(
            title:
                '${selectedDay.month}월 ${selectedDay.day}일 (${FormatUtil.getWeekdayName(selectedDay.weekday)})',
            isToday: yyyyMMDDSelectedDay == yyyyMMDDNowDay),
        Expanded(
          child: SingleChildScrollView(
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 1.0),
              //border radius 주기위해!
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(4.0),
                      bottomRight: Radius.circular(4.0))),
              //color: lightColor,
              child: Column(
                  children: takingTimezoneBoxList
                      .map((takingTimezoneBox) => MainCardList(
                    selectedDay : selectedDay,
                          title: takingTimezoneBox.timezoneTitle!,
                        take_status: takingTimezoneBox.takeStatus!,
                        timezoneId: takingTimezoneBox.timezoneId!,
                          memo: takingTimezoneBox.memo == null
                              ? ''
                              : takingTimezoneBox.memo,
                          takingTime: takingTimezoneBox.takeDateTime ?? DateTime(0),
                          medicineList: takingTimezoneBox.pills!,
                          onReloadRequest: reloadData,))
                      .toList(),
                )
            ),
          ),
        )
      ],
    );
  }
}
