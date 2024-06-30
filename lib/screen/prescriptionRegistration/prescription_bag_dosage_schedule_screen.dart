import 'package:care_management/common/component/dosage_scedule_button.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/common/model/timezone_box_model.dart';
import 'package:care_management/common/model/timezone_model.dart';
import 'package:care_management/screen/prescriptionRegistration/medicine_search_screen.dart';
import 'package:care_management/screen/prescriptionRegistration/service/prescription_service.dart';
import 'package:care_management/screen/search/medicine_search_dialog.dart';
import 'package:care_management/screen/timezone_manage/service/timezone_service.dart';
import 'package:care_management/screen/timezone_manage/timezone_manage_input_screen.dart';
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

    Future.microtask(() => getTimezonList());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print('----prescriptionbag dosage schedule -dispose------');

    super.dispose();
  }

  void getTimezonList() async {

    final timezoneService = ref.read(timezoneServiceProvider);

    final timezoneList = await timezoneService.getTimezone();
    setState(() {
      print('>>>>>>>>dosagescreen >>. $timezoneList');

      for (Map e in timezoneList) {
        timezoneModel.add(TimezoneModel(
            id: e['id'],
            name: e['name'],
            hour: e['hour'],
            midday: e['midday'],
            minute: e['minute'],
            controller: null,
            title: '${e['name']} (${e['hour']}:${e['minute']})'));

        ref.read(timezoneProvider.notifier).addTimezone(TimezoneBoxModel(
            timezoneId: e['id'],
            timezoneTitle: '${e['name']} (${e['hour']}:${e['minute']})'));
      }
    });

    //medTImeList
  }

  @override
  Widget build(BuildContext context) {
    print('----prescriptionbag dosage schedule -build------');

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
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) => TimezoneInputScreen()));
                  },
                  child: Text(
                    '+ 복약 시간대 추가',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  )),
            ],
          ),
          ...timezoneModel
              .asMap()
              .entries
              .map(
                (timezone) => DosageScheduleButton(
                  scheduleTitle: timezone.value.title,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => MedicineSearchScreen(
                              timezoneId: timezone.value.id,
                              timezoneTitle: timezone.value.title,
                            )));
                  },
                  isBoxSelected: timezone.key == 0 ? true : false,
                ),
              )
              .toList(),
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
