import 'package:care_management/common/component/card_title.dart';
import 'package:care_management/common/component/main_card_list.dart';
import 'package:care_management/common/const/colors.dart';
import 'package:care_management/common/model/medication_schedule_box_model.dart';
import 'package:care_management/common/util/formatUtil.dart';
import 'package:care_management/screen/calendar/calendar_screen.dart';
import 'package:care_management/screen/userMain/service/userMain_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final selectedDayProvider =
    StateProvider<DateTime>((ref) => DateTime.now().toUtc());

final fetchDataProvider =
    FutureProvider<List<MedicationScheduleBoxModel>>((ref) async {
  final selectedDay = ref.watch(selectedDayProvider);
  List<MedicationScheduleBoxModel> scheduleBoxModel = [];

  final umservice = ref.read(userMainServiceProvider);

  final cardList = await umservice
      .fetchCardList(DateFormat('yyyy-MM-dd').format(selectedDay));

  scheduleBoxModel = cardList
      .map<MedicationScheduleBoxModel>(
          (e) => MedicationScheduleBoxModel.fromJson(json: e))
      .toList();

  ref
      .read(MedicationScheduleBoxProvider.notifier)
      .initMedicationBoxModel(scheduleBoxModel);

  print(
      '>>>>>>>>>>> ${scheduleBoxModel.map((e) => e.pills!.map((ek) => print(ek.pillName)))}');

  return scheduleBoxModel;
});

class UserMainScreen extends ConsumerStatefulWidget {
  const UserMainScreen({super.key});

  @override
  ConsumerState<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends ConsumerState<UserMainScreen> {
  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(fetchDataProvider);

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
          Expanded(
            child: asyncValue.when(
              data: (data) => renderPillCard(data),
              loading: () => Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('오류가 발생하였습니다: $err')),
            ),
          ),
        ],
      ),
    ));
  }

  Widget renderDateHeader(BuildContext context) {
    final selectedDay = ref.watch(selectedDayProvider);
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
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => CalendarScreen(
                    searchDay: selectedDay,
                  )));
        },
        icon: ImageIcon(AssetImage('asset/icon/calendar.png')),
      )
    ]);
  }

  List<Widget> renderDateBox() {
    final selectedDay = ref.watch(selectedDayProvider);
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
                ref.read(selectedDayProvider.notifier).state =
                    dateBoxData[index]['date'];
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

  Widget renderPillCard(
      List<MedicationScheduleBoxModel> takingTimezoneBoxList) {
    final selectedDay = ref.watch(selectedDayProvider);
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
                            selectedDay: selectedDay,
                            title: takingTimezoneBox.timezoneTitle!,
                            take_status: takingTimezoneBox.takeStatus!,
                            timezoneId: takingTimezoneBox.timezoneId!,
                            memo: takingTimezoneBox.memo == null
                                ? ''
                                : takingTimezoneBox.memo,
                            takingTime:
                                takingTimezoneBox.takeDateTime ?? DateTime(0),
                            medicineList: takingTimezoneBox.pills!,
                            onReloadRequest: fetchDataProvider,
                          ))
                      .toList(),
                )),
          ),
        )
      ],
    );
  }
}
