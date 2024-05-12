
import 'dart:ffi';

import 'package:intl/intl.dart';

class FormatUtil {
  static String doubleToString(double val) {
    if (val == val.toInt()) {
      // 소수점 이하 0
      return val.toInt().toString();
    } else {
      return val.toString();
    }
  }

  static String getTimeFromDateTime(DateTime dt) {
    print('##########${dt}');
    if(dt.isAtSameMomentAs(DateTime(0))) return '';

    return '${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  static String parseTimeToAMPM(DateTime dt) {
    if (dt == null) return '';
    if (dt.isAtSameMomentAs(DateTime(0))) return '';

    return dt.hour >= 12 ? "PM" : "AM";
  }


  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static String parseStringAMPM(String time) {
    if (time == null) return '';

    int hour = int.parse(time.replaceAll(':', ''));

    if (time.length >= 4) {
      hour = int.parse(time.substring(0, 2));
    }

    return hour >= 12 ? "PM" : "AM";
  }

  static String getWeekdayName(int weekdayNumber) {
    List<String> weekdays = [
      "월", "화", "수", "목", "금", "토", "일"
    ];

    return weekdays[weekdayNumber - 1];
  }

  static List<String> getDatesBetween(DateTime startAt_dt, DateTime finished_dt) {
    List<String> dateList = [];

    DateTime currentDate = startAt_dt;

    while (currentDate.isBefore(finished_dt) || currentDate.isAtSameMomentAs(finished_dt)) {
      dateList.add(DateFormat('yyyy-MM-dd').format(currentDate));
      currentDate = currentDate.add(Duration(days: 1));
    }

    return dateList;
  }
}