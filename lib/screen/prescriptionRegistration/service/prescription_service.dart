import 'package:care_management/common/service/common_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final PrescriptionServiceProvider = Provider<PrescriptionService>((ref) {
  return PrescriptionService(ref);
});

class PrescriptionService extends CommonService {
  PrescriptionService(super.ref);

  Future<bool> insertPrescription(Map<String, dynamic> prescriptionData) async {
    final resp = await post('/plan', data: prescriptionData);

    return resp.data['code'] == 200;
  }

  Future<List> fetchMedicine(String name) async {
    final resp = await get('/medicine/search/$name', queryParam: null);

    return resp.data['data'];
  }
}
