
class FormatUtil {
  static String doubleToString(double val) {
    if (val == val.toInt()) {
      // 소수점 이하 0
      return val.toInt().toString();
    } else {
      return val.toString();
    }
  }

  static String parseTimeToAMPM(String time){
    if(time == '') return '';
    return int.parse(time.substring(0,2)) >= 12 ? "PM" : "AM";
  }


  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
