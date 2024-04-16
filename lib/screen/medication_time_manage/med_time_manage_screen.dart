import 'package:care_management/common/component/custom_components.dart';
import 'package:care_management/common/component/custom_text_field.dart';
import 'package:care_management/common/component/dialog.dart';
import 'package:care_management/common/const/colors.dart';
import 'package:care_management/common/const/data.dart';
import 'package:care_management/common/dio/dio.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/common/model/timezone_model.dart';
import 'package:care_management/screen/medication_time_manage/med_time_manage_input_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MedTimeManageScreen extends ConsumerStatefulWidget {
  MedTimeManageScreen({super.key});

  @override
  ConsumerState<MedTimeManageScreen> createState() =>
      _MedTimeManageScreenState();
}

class _MedTimeManageScreenState extends ConsumerState<MedTimeManageScreen> {
  List<TimezoneModel> timezoneModel = [];
  List<String> _timeList = [];

  @override
  void initState() {
    print("initState called");
    // TODO: implement initState
    for (int hour = 0; hour < 24; hour++) {
      for (int minute in [0, 30]) {
        _timeList.add(
            '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
      }
    }
    super.initState();

    Future.microtask(() => {
      print("Before getMedTimeList"),
      getMedTimeList(),
      print("After getMedTimeList")
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    for (TimezoneModel medtime in timezoneModel) {
      medtime.controller.dispose();
    }

    super.dispose();
  }

  void getMedTimeList() async {
    final dio = ref.watch(dioProvider);

    try {
      final resp = await dio.get('${apiIp}/timezone',
          options: Options(headers: {'accessToken': 'true'}));

      setState(() {
        timezoneModel = resp.data['data']
            .map<TimezoneModel>((e) => TimezoneModel(
                name: e['name'],
                hour: e['hour'],
                midday: e['midday'],
                minute: e['minute'],
                controller: TextEditingController(),
                title: '${e['hour']}:${e['minute']}'))
            .toList();

        for (TimezoneModel medtime in timezoneModel) {
          medtime.controller.text = '${medtime.title}';
        }
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
    if (timezoneModel.isEmpty) {
      // 로딩 인디케이터 표시
      return Center(child: CircularProgressIndicator());
    }

    return MainLayout(
        appBartitle: '복약 시간대 관리',
        addPadding: true,
        floatingActionButton: _renderFloatingActionButton(),
        body: Align(
          alignment: Alignment.center,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ...timezoneModel
                .map((medTime) => Column(
                      children: [
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 200.0,
                                child: GestureDetector(
                                  /* onTap: () => _showDropdownMenu(
                                      context, medTime['controller']),*/
                                  child: AbsorbPointer(
                                    child: TextField(
                                      controller: medTime.controller,
                                      readOnly: true,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        icon: Text(
                                          medTime.name,
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                        labelStyle: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0x33000000),
                                              width: 1.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => MedTimeManageInputScreen(
                                          editingMode: true,
                                          editingMedTimeData: medTime)));
                                },
                                icon: ImageIcon(
                                    AssetImage('asset/icon/pencil.png')),
                              )
                            ]),
                      ],
                    ))
                .toList(),
            /* SizedBox(
              height: 60.0,
            ),
            DoneButton(
              buttonText: '수정',
              onButtonPressed: () {
                //Navigator.of(context).push(MaterialPageRoute(
                //      builder: (_) => PrescriptionBagDetailScreen()));
              },
            )*/
          ]),
        ));
  }

  void _showDropdownMenu(BuildContext context, TextEditingController ctrl) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _timeList
                  .map((time) => ListTile(
                        title: Center(child: Text(time)),
                        onTap: () {
                          setState(() {
                            ctrl.text = time;
                            Navigator.pop(context);
                          });
                        },
                      ))
                  .toList()),
        );
      },
    );
  }

  Widget _renderFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const MedTimeManageInputScreen()));
      },
      backgroundColor: PRIMARY_COLOR,
      foregroundColor: Colors.white,
      shape: CircleBorder(),
      child: Icon(Icons.add),
    );
  }
}
