import 'package:care_management/common/component/custom_components.dart';
import 'package:care_management/common/component/dialog.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/common/model/prescription_model.dart';
import 'package:care_management/screen/prescriptionRegistration/prescription_bag_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrescriptionBagInputScreen extends ConsumerStatefulWidget {
  const PrescriptionBagInputScreen({super.key});

  @override
  ConsumerState<PrescriptionBagInputScreen> createState() =>
      _PrescriptionBagInputScreenState();
}

class _PrescriptionBagInputScreenState
    extends ConsumerState<PrescriptionBagInputScreen> {


  final TextEditingController _prescriptionTitleController =
      TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _prescriptionTitleController.dispose();
    print('----prescriptionbag input -dispose------');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('----prescriptionbag input -build------');


    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(
            labelText: '이름',
            controller: _prescriptionTitleController,
          ),
          SizedBox(
            height: 60.0,
          ),
          DoneButton(
            buttonText: '등록 시작',
            onButtonPressed: () async{
              if(_prescriptionTitleController.text.isEmpty) {
                return ref.watch(dialogProvider.notifier).showAlert( '처방전 이름을 등록해주세요!');
              }

              try{
                ref.read(prescriptionProvider.notifier).initPrescription();
                ref.read(prescriptionProvider.notifier).updatePrescriptionName(_prescriptionTitleController.text);

                print('------------');
                print(ref.read(prescriptionProvider).prescriptionName);

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => PrescriptionBagDetailScreen()));
              }catch(e){
                  return ref.watch(dialogProvider.notifier).showAlert('오류가 발생했습니다');
              }

            },
          )
        ],
    );
  }
}
