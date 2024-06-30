import 'package:care_management/common/service/common_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final timezoneServiceProvider = Provider<TimezoneService>((ref) {
  return TimezoneService(ref);
});

class TimezoneService extends CommonService {
  TimezoneService(super.ref);

  Future<List> getTimezone() async {
    final resp = await get('/timezone', queryParam: null);
    print(resp);

    return resp.data['data'];
  }

  Future<Response> insertTimezone(Map<String, dynamic> data) async {
    var resp = post('/timezone',
        data: data /*,
        headers: {'accessToken': 'true'}*/
        );
    print(resp);

    return resp;
  }

  Future<Response> updateTimezone(Map<String, dynamic> data) async {
    var resp = patch('/timezone',
        data: data /*,
        headers: {'accessToken': 'true'}*/
        );
    print(resp);

    return resp;
  }

  Future<Response> deleteTimezone(String deleteData) async {
    var resp = delete(
      '/timezone/${deleteData}',
    );
    print(resp);

    return resp;
  }
}
