
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
}
