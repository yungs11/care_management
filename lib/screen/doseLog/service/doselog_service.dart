import 'package:care_management/common/service/common_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final doselogServiceProvider = Provider<DoselogService>((ref) {
  return DoselogService(ref);
});


class DoselogService extends CommonService {
  DoselogService(super.ref);

  Future<List> fetchIntakeHistory(String date) async{
    final resp = await get('/plan',
        queryParam: {
          'date': date
        });
    print(resp);
    return resp.data['data']['plans'];
  }


}