import 'package:care_management/common/component/custom_components.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/screen/prescriptionRegistration/prescription_bag_dosage_schedule_screen.dart';
import 'package:flutter/material.dart';

class PrescriptionBagDetailScreen extends StatefulWidget {
  const PrescriptionBagDetailScreen({super.key});

  @override
  State<PrescriptionBagDetailScreen> createState() =>
      _PrescriptionBagDetailScreenState();
}

class _PrescriptionBagDetailScreenState
    extends State<PrescriptionBagDetailScreen> {
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  TextEditingController _takeDaysController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _hospitalController.dispose();
    _startDateController.dispose();
    _takeDaysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            onButtonPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => PrescriptionBagDosageSceduleScreen()));
            },
          )
        ],
      ),
    );
  }
}
