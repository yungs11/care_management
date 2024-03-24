import 'package:care_management/common/const/colors.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/common/util/formatUtil.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime? selectedDay;
  DateTime focusedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

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
      color: Color(0xFFC8C8C8),
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
        floatingActionButton: _renderFloatingActionButton(),
        body: Column(
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

                    setState(() {
                      this.selectedDay = selectedDay;
                      this.focusedDay = focusedDay;
                    });
                  },
                  // 선택된 날짜를 표시하기 위한 조건
                  selectedDayPredicate: (day) {
                    return isSameDay(selectedDay, day);
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
                   return _renderMarkerBuilder(date);
                  }),
                ),
              ),
            ),
          ],
        ));
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

  Widget _renderMarkerBuilder(DateTime date) {
    Map<DateTime, List> _medicineDates = {
      DateTime(2024, 2, 5): ['Medicine 1'],
      DateTime(2024, 2, 6): ['Medicine 2'],
      DateTime(2024, 2, 7): ['Medicine 2'],
      DateTime(2024, 2, 8): ['Medicine 2'],
      DateTime(2024, 3, 8): ['Medicine 2'],
    };


    // 모든 날짜를 동일한 시간으로 설정하여 비교
    DateTime normalizedDate =
    DateTime(date.year, date.month, date.day);

    // _medicineDates 맵을 순회하면서 normalizedDate와 비교
    if (_medicineDates.containsKey(normalizedDate)) {
      return Positioned(
        right: 1,
        top: 1,
        child: _buildMedicineMarker(date),
      );
    }
    //마커 없는 곳 크기 0인 위젯 생성
    return SizedBox.shrink();
  
  }

  Widget _buildMedicineMarker(DateTime date) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: PRIMARY_COLOR),
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
