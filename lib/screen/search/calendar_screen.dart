import 'package:care_management/common/component/dialog.dart';
import 'package:care_management/common/const/colors.dart';
import 'package:care_management/common/const/data.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/common/model/prescription_model.dart';
import 'package:care_management/common/util/formatUtil.dart';
import 'package:care_management/screen/prescriptionHistory/prescription_history_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../common/dio/dio.dart';

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
  late DateTime focusedDay;
  Future<List<PrescriptionModel>>? dataFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('설마여길또타???');

    focusedDay = widget.searchDay ??
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dataFuture = fetchPrescriptions();
  }

  Future<List<PrescriptionModel>> fetchPrescriptions() async {
    List<PrescriptionModel> prescriptionList = [];
    print('focusedDay >>> ${focusedDay}');

    final dio = ref.watch(dioProvider);

    try {
      final resp = await dio.get('${apiIp}/plan/month',
          options: Options(headers: {'accessToken': 'true'}),
          queryParameters: {
            'year': focusedDay.year,
            'month': focusedDay.month
          });
      prescriptionList = resp.data['data']['items']
          .map<PrescriptionModel>((e) => PrescriptionModel.fromJson(json: e))
          .toList();

      //     ref.read(MedicationScheduleBoxProvider.notifier).initMedicationBoxModel(scheduleBoxModel);

      print(
          '>>>>>>>>>>>처방전이름 ${prescriptionList.map((e) => e.prescriptionName)}');
      print('>>>>>>>>>>>시작일시 ${prescriptionList.map((e) => e.startedAt)}');
    } on DioException catch (e) {
      CustomDialog.errorAlert(context, e);
    } catch (e) {
      print(e);
    }

    return prescriptionList;
  }

  void reloadData() {
    setState(() {
      dataFuture = fetchPrescriptions(); // 데이터 재요청
    });
  }

  @override
  Widget build(BuildContext context) {
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
        appBartitle: '날짜선택',
        //  floatingActionButton: _renderFloatingActionButton(),
        body: FutureBuilder<List<PrescriptionModel>>(
            future: fetchPrescriptions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator()); // 로딩 인디케이터 표시
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('오류가 발생하였습니다: ${snapshot.error}')); // 오류 메시지 표시
              } else {
                return Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: appBarHeight * 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        //   color: BACKGROUND_COLOR,
                        child: TableCalendar(
                          locale: 'ko_KR',
                          focusedDay: focusedDay,
                          firstDay: DateTime(1800),
                          lastDay: DateTime(3000),
                          onDaySelected: (selectedDay, focusedDay) {
                            // print(selectedDay);
                            // print(focusedDay);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => MainLayout(
                                      appBartitle: '처방 내역',
                                      body: PrescriptionHistoryScreen(
                                        selectedDate: DateFormat('yyyy-MM-dd')
                                            .format(focusedDay),
                                      ),
                                      addPadding: false,
                                    )));
                          },
                          // 선택된 날짜를 표시하기 위한 조건
                          selectedDayPredicate: (day) {
                            return isSameDay(selectedDay, day);
                          },
                          onPageChanged: (focusedDay) {
                            // 월이 변경될 때 focusedDay 업데이트
                            print('@@@@@달력변경?@@@@@@@@ ${focusedDay}');
                            setState(() {
                              this.focusedDay = focusedDay;
                            });
                          },
                          headerStyle: headerStyle,
                          calendarStyle: CalendarStyle(
                            isTodayHighlighted: false, //오늘날짜 highlight 표시 끔
                          ),
                          calendarBuilders: CalendarBuilders(
                              defaultBuilder: (context, day, foucusedDay) {
                            return _renderDefaultDate(day, defaultTextStyle);
                          }, selectedBuilder: (context, date, events) {
                            return _renderSelectedDate(date);
                          }, markerBuilder: (context, date, events) {
                            return _renderMarkerBuilder(date, snapshot.data!);
                          }),
                        ),
                      ),
                    ),
                  ],
                );
              }
            }));
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

  /* Map<DateTime, List> _medicineDates = {
      DateTime(2024, 2, 5): ['Medicine 1'],
      DateTime(2024, 2, 6): ['Medicine 2'],
      DateTime(2024, 2, 7): ['Medicine 2'],
      DateTime(2024, 2, 8): ['Medicine 2'],
      DateTime(2024, 3, 8): ['Medicine 2'],
    };*/
  Widget _renderMarkerBuilder(
      DateTime date, List<PrescriptionModel> prescriptionList) {
    Map<String, dynamic> _medicineDates = {};

    Map<String, Color> colorMap = {};
    List<Color> colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.purple
    ];
    int colorIndex = 0;
    Set prescriptionIdSets = {};

    for (PrescriptionModel p in prescriptionList) {
      //마크 해야하는 데이터 리스트..(사이날짜 다 가져옴)
      List<String> dateList =
          FormatUtil.getDatesBetween(p.startedAt!, p.finishedAt!);
      prescriptionIdSets.add(p.prescriptionId);

      dateList.forEach((e) {
        _medicineDates[e] = p.prescriptionId!;
      });
    }

    print('##############');
    print(_medicineDates);
    //print(prescriptionIdSets);

    for (String name in prescriptionIdSets) {
      colorMap[name] = colors[colorIndex % colors.length];
      colorIndex++;
    }

    // print('**********');
    // print(colorMap);
    for (PrescriptionModel p in prescriptionList) {
      _medicineDates.updateAll((key, value) =>
          value == p.prescriptionId! ? colorMap[p.prescriptionId!] : value);
    }
    //
    //prescriptionList.map((e) => FormatUtil.getDatesBetween(e.startedAt!, e.finishedAt!));
//_medicineDates.
    print('@@@@@@@@@');
    print(_medicineDates);

    // 모든 날짜를 동일한 시간으로 설정하여 비교
    String normalizedDate = DateFormat('yyyy-MM-dd').format(date);

    // _medicineDates 맵을 순회하면서 normalizedDate와 비교
    if (_medicineDates.containsKey(normalizedDate)) {
      print('%%%%%%%');
      print(colorMap.values.toList().indexOf(_medicineDates[normalizedDate]) +
          1.toDouble());
      return Positioned(
        right: 1,
        //top:5.0,
        //  right: colorMap.values.toList().indexOf(_medicineDates[normalizedDate])+1.toDouble(),
        top: 1,
        //  top: colorMap.values.toList().indexOf(_medicineDates[normalizedDate])+1.toDouble(),
        //  top: 6.0,
        child: _buildMedicineMarker(_medicineDates, normalizedDate),
      );
    }
    //마커 없는 곳 크기 0인 위젯 생성
    return SizedBox.shrink();
  }

  Widget _buildMedicineMarker(Map<String, dynamic> toMarkDates, String date) {
//print(toMarkDates[date]);
    return Container(
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: toMarkDates[date]),
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
