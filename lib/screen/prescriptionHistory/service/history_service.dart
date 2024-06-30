import 'package:care_management/common/service/common_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final prescrptionHistoryServiceProvider = Provider<PrescriptionHistoryService>((ref){
  return PrescriptionHistoryService(ref);
});


class PrescriptionHistoryService extends CommonService{
  PrescriptionHistoryService(super.ref);

  Future<bool> deletePrescription(String prescriptionId) async{
   final resp = await delete(
      '/prescription/$prescriptionId',

    );
   return resp.data['code'] == 200;
  }
}