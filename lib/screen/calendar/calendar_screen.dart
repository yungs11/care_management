import 'package:care_management/common/component/dialog.dart';
import 'package:care_management/common/const/colors.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/common/model/prescription_model.dart';
import 'package:care_management/screen/calendar/service/calendar_service.dart';
import 'package:care_management/screen/prescriptionHistory/prescription_history_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

// 처방전의 유효 기간 동안 날짜와 이름을 맵핑
void mapPrescriptionsToDates(List<PrescriptionModel> prescriptions) {
  Map<DateTime, List<Event>> events = {};

  for (var prescription in prescriptions) {
    for (var date in prescription.takeDatesList!) {
      // 날짜를 YYYY-MM-DD 형식으로 일관되게 처리
      DateTime normalizedDate = DateTime.parse(date).toUtc();
      if (!events.containsKey(normalizedDate)) {
        events[normalizedDate] = [];
      }
      events[normalizedDate]!.add(Event(prescription.prescriptionName!));
    }
  }

  // 결과 확인을 위한 출력
  events.forEach((key, value) {
    print('Date: $key, Prescriptions: $value');
  });
}

final focusedDayProvider = StateProvider<DateTime>((ref) =>
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));

final fetchDataProvider = FutureProvider<List<PrescriptionModel>>((ref) async {
  List<PrescriptionModel> prescriptionList = [];

  print('focusedDay >>> ${ref.watch(focusedDayProvider)}');
  final focusedDay = ref.watch(focusedDayProvider);

  final calService = ref.read(calendarServiceProvider);

  try {
    final prescriptionPerMonthList = await calService
        .fetchPrescriptionsPerMonth(focusedDay.year, focusedDay.month);
    PrescriptionModel.initialMarkerColor();
    prescriptionList = prescriptionPerMonthList
        .map<PrescriptionModel>((e) => PrescriptionModel.fromJson(json: e))
        .toList();

    //     ref.read(MedicationScheduleBoxProvider.notifier).initMedicationBoxModel(scheduleBoxModel);

    mapPrescriptionsToDates(prescriptionList);

    print(
        '>>>>>>>>>>>처방전이름 ${prescriptionList.map((e) => e.prescriptionName)}');
    print('>>>>>>>>>>>시작일시 ${prescriptionList.map((e) => e.startedAt)}');
  } on DioException catch (e) {
    ref.watch(dialogProvider.notifier).errorAlert(e);
  } catch (e) {
    print(e);
  }

  return prescriptionList;
});

class CalendarScreen extends ConsumerStatefulWidget {
  final DateTime? searchDay;
  const CalendarScreen({
    super.key,
    required this.searchDay,
  });

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime? selectedDay;
  late final ValueNotifier<List<Event>> _selectedEvents;
  Map<DateTime, List<Event>>? _events;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _selectedEvents.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('selecetdDay>>>>> ${widget.searchDay}');

    _selectedEvents = ValueNotifier(_getEventsForDay(widget.searchDay!));
    _events = {
      DateTime(2024, 06, 09).toUtc(): [Event('기쁨병원 약봉투'), Event('약봉투2')],
      DateTime(2024, 06, 10).toUtc(): [Event('건강하자')],
      DateTime(2024, 06, 11).toUtc(): [
        Event('약봉투2'),
        Event('약봉투3'),
        Event('건강건강')
      ],
    };
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    /*  if (widget.searchDay != null)
      ref.read(focusedDayProvider.notifier).state = widget.searchDay!;*/
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    //String dayT=DateFormat('yyyy-MM-dd').format(day);
    //Map<String, dynamic> events = context.read<EventsProvider>().getEvents();
    if (_events == null)
      return [];
    else
      return _events![day] ?? [];

    //return _events![day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(fetchDataProvider);
    final focusedDay = ref.watch(focusedDayProvider);

    final headerStyle = HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16.0,
        ));

    final defaultBoxDeco = BoxDecoration(
        color: Colors.grey[200], borderRadius: BorderRadius.circular(6.0));
    final defaultTextStyle = TextStyle(
      color: Color(0xFF2b2b2b),
      fontWeight: FontWeight.w500,
    );

    // 전체 화면 높이
    double screenHeight = MediaQuery.of(context).size.height;
    // AppBar와 Footer의 높이를 추정하거나 미리 알고 있는 경우
    double appBarHeight = AppBar().preferredSize.height;
    double footerHeight = 50.0; // Footer 높이를 50으로 가정
    // 사용 가능한 높이
    double availableHeight = screenHeight - appBarHeight - footerHeight;

    return MainLayout(
      appBartitle: '날짜별 약봉투',
      //  floatingActionButton: _renderFloatingActionButton(),
      body: asyncValue.when(
        data: (data) => Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*
            SizedBox(
              height: appBarHeight * 2,
            ),*/
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                //   color: BACKGROUND_COLOR,
                child: TableCalendar(
                  locale: 'ko_KR',
                  focusedDay: focusedDay,
                  firstDay: DateTime(1800),
                  lastDay: DateTime(3000),
                  onDaySelected: (selectedDay1, focusedDay1) {
                    // Call `setState()` when updating the selected day
                    if (!isSameDay(selectedDay, selectedDay1)) {
                      // Call `setState()` when updating the selected day
                      setState(() {
                        selectedDay = selectedDay1;
                        //ref.read(focusedDayProvider.notifier).state = focusedDay1;
                      });
                      _selectedEvents.value = _getEventsForDay(selectedDay1);
                    }
                    // print(selectedDay);
                    // print(focusedDay);
                    /**/
                  },
                  // 선택된 날짜를 표시하기 위한 조건
                  selectedDayPredicate: (day) {
                    return isSameDay(selectedDay, day);
                  },
                  onPageChanged: (focusedDay) {
                    // 월이 변경될 때 focusedDay 업데이트
                    print('@@@@@달력변경?@@@@@@@@ ${focusedDay}');
                    ref.read(focusedDayProvider.notifier).state = focusedDay;
                  },
                  headerStyle: headerStyle,
                  calendarStyle: CalendarStyle(
                    isTodayHighlighted: false, //오늘날짜 highlight 표시 끔
                  ),
                  eventLoader: (date) {
                    print('@#@@####');
                    print(_events);
                    print(date.toUtc());
                    print(_events![date.toUtc()]);
                    return _events![date.toUtc()] ?? [];
                  },
                  calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, foucusedDay) {
                    return _renderDefaultDate(day, defaultTextStyle);
                  }, selectedBuilder: (context, date, events) {
                    return _renderSelectedDate(date);
                  }, markerBuilder: (context, date, events) {
                    //if (events.isNotEmpty)
                    return _renderMarkerBuilder(date, data!, events);
                  }),
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Expanded(
              child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: PRIMARY_COLOR),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => PrescriptionHistoryScreen(
                                prescription: data[0],
                                selectedDate: DateFormat('yyyy-MM-dd')
                                    .format(selectedDay!),
                              ),
                            ));
                          },
                          title: Text('${value[index]}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('오류가 발생하였습니다: $err')),
      ),
    );
  }

  Widget _renderDefaultDate(DateTime day, defaultTextStyle) {
    String dayFormatted = day.day.toString().padLeft(2, '0');
    return Center(
      child: Text(
        dayFormatted,
        style: defaultTextStyle,
      ),
    );
  }

  Widget _renderSelectedDate(date) {
    String dayFormatted = date.day.toString().padLeft(2, '0');

    return Container(
        margin: const EdgeInsets.all(4.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: PRIMARY_COLOR),
          shape: BoxShape.circle,
        ),
        child: Text(
          dayFormatted,
          //style: TextStyle(),
        ));
  }

  Widget _renderMarkerBuilder(
      DateTime date, List<PrescriptionModel> prescriptionList, List events) {
    print('markerbuilder ${prescriptionList}');
    // 모든 날짜를 동일한 시간으로 설정하여 비교
    String normalizedDate = DateFormat('yyyy-MM-dd').format(date);

    for (PrescriptionModel p in prescriptionList) {
      for (String date in p.takeDatesList!) {
        print('takeList > ${date}');
        print('nomaldate > ${normalizedDate}');
        print('${p.prescriptionId} /// ${p.markerTop}');

        if (date == normalizedDate) {
          return Positioned(
            right: p.markerTop!.toDouble(),
            //top:5.0,
            //  right: colorMap.values.toList().indexOf(_medicineDates[normalizedDate])+1.toDouble(),
            //top: 1,
            top: p.markerTop!.toDouble(),
            //  top: 6.0,
            child: _buildMedicineMarker(p.markerColor!, events),
          );
        }
      }
    }

    //마커 없는 곳 크기 0인 위젯 생성
    return SizedBox.shrink();
  }

  Widget _buildMedicineMarker(Color markerColor, List events) {
//print(toMarkDates[date]);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(shape: BoxShape.circle, color: markerColor),
      width: 8.0,
      height: 8.0,
    );
  }

  Widget _renderFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: PRIMARY_COLOR,
      foregroundColor: Colors.white,
      shape: CircleBorder(),
      child: Icon(Icons.add),
    );
  }
}
