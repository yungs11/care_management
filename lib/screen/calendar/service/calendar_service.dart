import 'package:care_management/common/service/common_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final calendarServiceProvider = Provider<CalendarService>((ref) {
  return CalendarService(ref);
});

class CalendarService extends CommonService {
  CalendarService(super.ref);

  Future<List> fetchPrescriptionsPerMonth(int year, int month) async {
    final resp =
        await get('/plan/month', queryParam: {'year': year, 'month': month});
    return resp.data['data']['items'];
  }
}
