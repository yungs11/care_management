import 'package:care_management/common/component/custom_components.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/common/model/prescription_model.dart';
import 'package:care_management/screen/prescriptionHistory/prescription_his_detail_screen.dart';
import 'package:care_management/screen/prescriptionHistory/service/history_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class PrescriptionHistoryScreen extends ConsumerStatefulWidget {
  final PrescriptionModel prescription;
  final String selectedDate;
  const PrescriptionHistoryScreen(
      {super.key, required this.prescription, required this.selectedDate});

  @override
  ConsumerState<PrescriptionHistoryScreen> createState() =>
      _PrescriptionHistoryScreenState();
}

class _PrescriptionHistoryScreenState
    extends ConsumerState<PrescriptionHistoryScreen> {
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _finishDateController = TextEditingController();
  TextEditingController _takeDaysController = TextEditingController();
  late Future<List<PrescriptionModel>> _future;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _hospitalController.text = widget.prescription.prescriptionName!;
    _startDateController.text =
        DateFormat('yyyy-MM-dd').format(widget.prescription.startedAt!);
    _finishDateController.text =
        DateFormat('yyyy-MM-dd').format(widget.prescription.finishedAt!);
    _takeDaysController.text = widget.prescription.takeDays!.toString();
  }

  @override
  void dispose() {
    print('----Prescrition detail dispose------');

    // TODO: implement dispose
    _hospitalController.dispose();
    _startDateController.dispose();
    _finishDateController.dispose();
    _takeDaysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('----Prescrition detail -build------');

    return MainLayout(
      appBartitle: '약봉투',
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
          CustomTextField(
            labelText: '시작일자',
            controller: _startDateController,
          ),
          SizedBox(
            height: 30.0,
          ),
          CustomTextField(
            labelText: '종료일자',
            controller: _finishDateController,
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
          Row(children: [
            ElevatedButton(
                onPressed: () async {
                  final phService = ref.read(prescrptionHistoryServiceProvider);
                  final resp = await phService.deletePrescription(
                    '${widget.prescription.prescriptionId}',
                  );

                  print(resp);
                  /*
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => CalendarScreen(
                          searchDay: DateTime.parse(widget.selectedDate),
                        )));*/
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // 테마에 맞는 버튼 색상
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color(0x66000000)),
                      borderRadius: BorderRadius.circular(5.0)),
                  padding: const EdgeInsets.all(25.0),
                ),
                child: Text(
                  '약봉투 삭제',
                )),
            SizedBox(
              width: 15,
            ),
            Expanded(
                flex: 1,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => MainLayout(
                          appBartitle: '처방 내역',
                          body: PrescriptionHistoryDetailScreen(
                              selectedDate: widget.selectedDate),
                          addPadding: false,
                        ),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // 테마에 맞는 버튼 색상
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Color(0x66000000)),
                          borderRadius: BorderRadius.circular(5.0)),
                      padding: const EdgeInsets.all(25.0),
                    ),
                    child: Text(
                      '처방약 보기',
                    ))),
          ]),
        ],
      ),
    );
  }
}
