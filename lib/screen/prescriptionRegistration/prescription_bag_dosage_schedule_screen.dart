import 'package:care_management/common/component/custom_components.dart';
import 'package:care_management/common/component/dialog.dart';
import 'package:care_management/common/component/dosage_scedule_button.dart';
import 'package:care_management/common/const/data.dart';
import 'package:care_management/common/dio/dio.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/common/model/timezone_model.dart';
import 'package:care_management/screen/prescriptionRegistration/dosage_input_screen.dart';
import 'package:care_management/screen/search/medicine_search_dialog.dart';
import 'package:care_management/screen/prescriptionRegistration/medicine_search_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrescriptionBagDosageSceduleScreen extends ConsumerStatefulWidget {
  const PrescriptionBagDosageSceduleScreen({super.key});



  @override
  ConsumerState<PrescriptionBagDosageSceduleScreen> createState() =>
      _PrescriptionBagDosageSceduleScreenState();
}

class _PrescriptionBagDosageSceduleScreenState
    extends ConsumerState<PrescriptionBagDosageSceduleScreen> {
  List<TimezoneModel> timezoneModel = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.microtask(() =>
        getTimezonList()
    );
  }


  void getTimezonList() async {
    final dio = ref.watch(dioProvider);

    try {
      final resp = await dio.get('${apiIp}/timezone',
          options: Options(headers: {'accessToken': 'true'}));

      setState(() {
        timezoneModel = resp.data['data']
            .map<TimezoneModel>((e) => TimezoneModel(
            id: e['id'],
            name: e['name'],
            hour: e['hour'],
            midday: e['midday'],
            minute: e['minute'],
            controller: TextEditingController(),
            title: '${e['name']} (${e['hour']}:${e['minute']})'))
            .toList();

      });

    } on DioException catch (e) {
      CustomDialog.errorAlert(context, e);
    } catch (e) {
      print(e);
    }
    //medTImeList
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: MainLayout(
      appBartitle: '복약 계획',
      addPadding: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {},
                  child: Text(
                    '+ 복약 시간대 추가',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  )),
            ],
          ),
          ...timezoneModel.asMap().entries.map((timezone) => DosageScheduleButton(
            scheduleTitle: timezone.value.title,
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => MedicineSearchScreen(timezoneId: timezone.value.id,timezoneTitle: timezone.value.title,)));
            },
            isBoxSelected: timezone.key == 0 ? true : false,
          ),).toList(),
          SizedBox(
            height: 20.0,
          ),
         /* DoneButton(
              onButtonPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => DosageInputScreen(toAddigMedicine: null,)));
              },
              buttonText: '선택'),*/
        ],
      ),
    ));
  }

  void _showPopup(BuildContext context) async {
    print('1111');

    final result = await showDialog<Map>(
      context: context,
      builder: (BuildContext context) => MedicineSearchDialog(),
    );

    if (result != null) {
      print('부모 창으로 전달된 값: $result');
    }
  }
}
