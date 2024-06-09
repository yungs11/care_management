import 'package:care_management/common/component/dialog.dart';
import 'package:care_management/common/const/colors.dart';
import 'package:care_management/common/const/data.dart';
import 'package:care_management/common/dio/dio.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/common/model/medication_schedule_box_model.dart';
import 'package:care_management/common/model/medicine_item_model.dart';
import 'package:care_management/common/model/prescription_model.dart';
import 'package:care_management/common/model/taking_medicine_item_model.dart';
import 'package:care_management/common/model/timezone_box_model.dart';
import 'package:care_management/common/util/formatUtil.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrescriptionHistoryScreen extends ConsumerStatefulWidget {

  final String selectedDate;

  const PrescriptionHistoryScreen({super.key, required this.selectedDate});

  @override
  ConsumerState<PrescriptionHistoryScreen> createState() => _PrescriptionHistoryScreenState();
}

class _PrescriptionHistoryScreenState extends ConsumerState<PrescriptionHistoryScreen> {
  late Future<List<TimezoneBoxModel>> _future;

  @override
  void didChangeDependencies() {
    // TODO: implement initState
    super.didChangeDependencies();

    _future =fetchPrescriptionData();
  }
  Future<List<TimezoneBoxModel>> fetchPrescriptionData() async {
    print('-------fetchPrescriptionData------- ${widget.selectedDate}');

    final dio = ref.watch(dioProvider);
    List<TimezoneBoxModel> timezoneList = [];
   /* PrescriptionModel prescription = PrescriptionModel(
      prescriptionName: '',
      hospitalName: '',
      startedAt: DateTime(0),
      takeDays: 0,
      items: [],
    );
    ;
*/


    try {
      /*final resp = await dio.get('${apiIp}/prescription',
          options: Options(headers: {'accessToken': 'true'}),
          queryParameters: {
            'date': widget.selectedDate,
          });

      var prescriptions = resp.data['data']
          .map<PrescriptionModel>((e) => PrescriptionModel(
        prescriptionName: e['name'],
        hospitalName: e['hospital'],
        startedAt: DateTime.parse(e['started_at']),

        takeDays: e['take_days'],

        //items: e['prescription_items'],
      ))
          .toList();

      if (prescriptions.isNotEmpty) {
        prescription = prescriptions.first;
      }

      print('#####1# ${prescription}');
*/
      final plan_resp = await dio.get('${apiIp}/plan',
          options: Options(headers: {'accessToken': 'true'}),
          queryParameters: {
            'date': widget.selectedDate,
          });

      print('######2 ${plan_resp}');

     timezoneList = plan_resp.data['data']['plans']
          .map<TimezoneBoxModel>((e) => TimezoneBoxModel(
          timezoneId: e['timezone_id'],
          timezoneTitle: '${e['plan_name']}',
          medicines: e['pills']
              .map<MedicineItemModel>(
                (item) => MedicineItemModel.fromJson(json: item),
          )
              .toList()))
          .toList();

      print('#####1# ${timezoneList}');


      //prescription = prescription.copyWith(items: timezoneList);
    } on DioException catch (e) {
      print(e);
      ref.watch(dialogProvider.notifier).errorAlert(e);
    } catch (e) {
      print(e);
    }

    return timezoneList;
    //medTImeList
  }
  @override
  Widget build(BuildContext context) {
    print('-------PrescriptionHistoryScreen-------');


    return FutureBuilder<List<TimezoneBoxModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // 로딩 인디케이터 표시
          } else if (snapshot.hasError) {
            return Center(
                child: Text('오류가 발생하였습니다: ${snapshot.error}')); // 오류 메시지 표시
          } else {
            return SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                            width: 140.0,
                            child: renderSelectedDate(widget.selectedDate))),
                    ...snapshot.data!
                        .map((timezoneItem) => Column(
                              children: [
                                SizedBox(
                                  height: 20.0,
                                ),
                                renderMedicinePerTImeBox(timezoneItem),
                              ],
                            ))
                        .toList(),
                  ]),
            )); // 데이터 표시
          }
        });
  }
}

Widget renderSelectedDate(String selectedDate) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: PRIMARY_COLOR, width: 3.0),
      borderRadius: BorderRadius.circular(15.0),
    ),
    //padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
    height: 45.0,
    child: Center(
      child: Text(
        '${selectedDate.substring(0,4)} / ${selectedDate.substring(5,7)} / ${selectedDate.substring(8,10)}',
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    ),
  );
  ;
}

Widget renderMedicinePerTImeBox(TimezoneBoxModel timezoneItem) {
  TextStyle headerFontstyle = const TextStyle(
      color: PRIMARY_COLOR, fontWeight: FontWeight.w500, fontSize: 12.0);

  print(timezoneItem);

  return DataTable(
    columnSpacing: 10.0,
    headingRowHeight: 30.0,
    horizontalMargin: 0,
    columns: <DataColumn>[
      DataColumn(
          label: Text(timezoneItem.timezoneTitle!,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600))),
      //DataColumn(label: Text('')),
      DataColumn(label: Text('1회분량', style: headerFontstyle)),
      DataColumn(label: Text('남은양', style: headerFontstyle)),
      DataColumn(label: Text('처방량', style: headerFontstyle)),
    ],
    rows: timezoneItem.medicines!.map((e) => renderPillItem(e)).toList(),
  );
}

DataRow renderPillItem(MedicineItemModel pill) {
  //_textController.text= pill['takingCount'].toString() ?? '';

  return DataRow(
    cells: <DataCell>[
      //  DataCell(Container(width: 50.0, child: renderPillTakingYNIcon(pill))),
      DataCell(Container(width: 200.0, child: renderPillName(pill))),
      DataCell(Container(width: 40.0, child: Text('${pill.takeAmount.toString()}개'))),
      DataCell(Container(width: 40.0, child: Text('${pill.remainAmount.toString()}일분'))),
      DataCell(Container(width: 40.0, child: Text('${pill.totalAmount.toString()}일분'))),
    ],
  );
}

Widget renderPillTakingYNIcon(pill) {
  return pill.takingYN
      ? Icon(
          Icons.circle_outlined,
          color: PRIMARY_COLOR,
          size: 10.0,
        )
      : Icon(
          Icons.close,
          color: Colors.indigo,
          size: 10.0,
        );
}

Widget renderPillName(pill) {
  return Text(pill.name,
      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0));
}
