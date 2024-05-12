import 'package:care_management/common/component/custom_components.dart';
import 'package:care_management/common/component/dialog.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/common/model/prescription_model.dart';
import 'package:care_management/screen/prescriptionRegistration/prescription_bag_dosage_schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class PrescriptionBagDetailScreen extends ConsumerStatefulWidget {
  const PrescriptionBagDetailScreen({super.key});

  @override
  ConsumerState<PrescriptionBagDetailScreen> createState() =>
      _PrescriptionBagDetailScreenState();
}

class _PrescriptionBagDetailScreenState
    extends ConsumerState<PrescriptionBagDetailScreen> {
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  TextEditingController _takeDaysController = TextEditingController();

  @override
  void dispose() {
    print('----Prescrition detail dispose------');

    // TODO: implement dispose
    _hospitalController.dispose();
    _startDateController.dispose();
    _takeDaysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('----Prescrition detail -build------');

    return MainLayout(
      appBartitle: '약봉투 등록',
      addPadding: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(
            labelText: '병원',
            controller: _hospitalController,
          ),
          SizedBox(
            height: 30.0,
          ),
          CustomDatePicker(
            labelText: '시작일자',
            dateController: _startDateController,
          ),
          SizedBox(
            height: 30.0,
          ),
          CustomTextField(
            labelText: '복용일수',
            controller: _takeDaysController,
            isNumber: true,
            suffixText: '일 분',
          ),
          SizedBox(
            height: 60.0,
          ),
          DoneButton(
            buttonText: '다음',
            onButtonPressed: () async{
              //*****************
              //form validation으로 구현해도 좋을거같다
              //*****************
              if(_hospitalController.text.isEmpty) {
                return CustomDialog.showAlert(context, '처방받은 병원 이름을 등록해주세요!');
              }

              if(_startDateController.text.isEmpty) {
                return CustomDialog.showAlert(context, '시작일자를 등록해주세요!');
              }

              if(_takeDaysController.text.isEmpty) {
                return CustomDialog.showAlert(context, '처방일 수를 등록해주세요!');
              }

              try{
                ref.read(prescriptionProvider.notifier).updateHospitalName(_hospitalController.text);
                ref.read(prescriptionProvider.notifier).updateStartedAt(_startDateController.text);
                ref.read(prescriptionProvider.notifier).updateTakDays(int.parse(_takeDaysController.text));

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => PrescriptionBagDosageSceduleScreen()));
              }catch(e){
                print(e);

                return CustomDialog.showAlert(context, '오류가 발생했습니다');
              }


            },
          )
        ],
      ),
    );
  }
}
