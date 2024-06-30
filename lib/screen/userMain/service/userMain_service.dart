import 'package:care_management/common/service/common_service.dart';
import 'package:care_management/screen/userMain/user_main_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userMainServiceProvider = Provider<UserMainService>((ref){
  return UserMainService(ref);
});

class UserMainService extends CommonService{
  UserMainService(super.ref);

  Future<List> fetchCardList(String date) async{
    final resp = await get('/plan',
        queryParam: {
          'date': date
        });

    return resp.data['data']['plans'];
  }

  Future<bool> changeTimezoneTakeStatus({required Map<String, dynamic> data}) async{
    final resp = await post('/plan/take',
        data: data);

    return resp.data['code'] == 200;

  }

  Future<bool> changePillTakeStatus({required Map<String, dynamic> data}) async{
    final resp = await post('/plan/take/pill',
        data: data);

    return resp.data['code'] == 200;

  }

  Future<bool> upsertMemo({required Map<String, dynamic> data}) async{
    final resp = await post('/plan/memo',
        data: data);

    return resp.data['code'] == 200;

  }


  Future<bool> updateTakeAmount({required Map<String, dynamic> data}) async{
    final resp = await patch('/plan/item/takeamount',
        data: data);

    return resp.data['code'] == 200;

  }


}