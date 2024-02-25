import 'package:care_management/component/custom_components.dart';
import 'package:care_management/layout/main_layout.dart';
import 'package:care_management/screen/prescription_bag_detail_screen.dart';
import 'package:flutter/material.dart';

class PrescriptionBagInputScreen extends StatefulWidget {
  const PrescriptionBagInputScreen({super.key});

  @override
  State<PrescriptionBagInputScreen> createState() =>
      _PrescriptionBagInputScreenState();
}

class _PrescriptionBagInputScreenState
    extends State<PrescriptionBagInputScreen> {
  final TextEditingController _prescriptionTitleController =
      TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _prescriptionTitleController.dispose();
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
            labelText: '이름',
            controller: _prescriptionTitleController,
          ),
          SizedBox(
            height: 60.0,
          ),
          DoneButton(
            buttonText: '등록 시작',
            onButtonPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => PrescriptionBagDetailScreen()));
            },
          )
        ],
      ),
    );
  }
}
