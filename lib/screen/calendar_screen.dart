import 'package:care_management/const/colors.dart';
import 'package:care_management/layout/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final focusedDay = DateTime(now.year, now.month, now.day);
    final defaultBoxDeco = BoxDecoration(
        color: Colors.grey[200], borderRadius: BorderRadius.circular(6.0));
    final defaultTextStyle = TextStyle(
      color: Color(0xFFC8C8C8),
      fontWeight: FontWeight.w500,
    );

    Map<DateTime, List> _medicineDates = {
      DateTime(2024, 2, 5): ['Medicine 1'],
      DateTime(2024, 2, 6): ['Medicine 2'],
      DateTime(2024, 2, 7): ['Medicine 2'],
      DateTime(2024, 2, 8): ['Medicine 2'],
    };

    // 전체 화면 높이
    double screenHeight = MediaQuery.of(context).size.height;

    // AppBar와 Footer의 높이를 추정하거나 미리 알고 있는 경우
    double appBarHeight = AppBar().preferredSize.height;
    double footerHeight = 50.0; // Footer 높이를 50으로 가정

    // 사용 가능한 높이
    double availableHeight = screenHeight - appBarHeight - footerHeight;

    return MainLayout(
        appBartitle: '날짜선택',
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: appBarHeight * 2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                color: BACKGROUND_COLOR,
                child: TableCalendar(
                  locale: 'ko_KR',
                  focusedDay: focusedDay,
                  firstDay: DateTime(1800),
                  lastDay: DateTime(3000),
                  headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0,
                      )),
                  calendarStyle: CalendarStyle(
                      isTodayHighlighted: false, //오늘날짜 highlight 표시 끔
                      //날짜들이  container안에 들어가있고, 그 container의 deco를 지정 ( focusedDay의 평일들만 지정 가능)
                      //      defaultDecoration: defaultBoxDeco,
                      //     weekendDecoration: defaultBoxDeco,
                      selectedDecoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(
                          color: PRIMARY_COLOR,
                          width: 1.0, //px
                        ),
                      ),
                      defaultTextStyle: defaultTextStyle,
                      weekendTextStyle: defaultTextStyle,
                      selectedTextStyle: defaultTextStyle.copyWith(
                        color: PRIMARY_COLOR,
                      ),
                      //focused된 달력의 외부날짜(1월 ex.2,12월)
                      outsideDecoration: BoxDecoration(
                        shape: BoxShape
                            .rectangle, //에러 나는 이유가 기본값이 circle이었기 때문에 circle에 셀렉티드효과(radius)주려했기 때문에.
                      )),
                  calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, foucusedDay) {
                    String dayFormatted = day.day.toString().padLeft(2, '0');
                    return Center(
                      child: Text(
                        dayFormatted,
                        style: defaultTextStyle,
                      ),
                    );
                  }, markerBuilder: (context, date, events) {
                    // 모든 날짜를 동일한 시간으로 설정하여 비교
                    DateTime normalizedDate =
                        DateTime(date.year, date.month, date.day);

                    // _medicineDates 맵을 순회하면서 normalizedDate와 비교
                    for (var medicineDate in _medicineDates.keys) {
                      if (isSameDay(medicineDate, normalizedDate)) {
                        return Positioned(
                          right: 1,
                          top: 1,
                          child: _buildMedicineMarker(date),
                        );
                      }
                    }
                  }),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildMedicineMarker(DateTime date) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: PRIMARY_COLOR),
      width: 8.0,
      height: 8.0,
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
