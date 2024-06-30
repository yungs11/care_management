import 'package:care_management/common/const/colors.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/common/model/timezone_model.dart';
import 'package:care_management/screen/timezone_manage/service/timezone_service.dart';
import 'package:care_management/screen/timezone_manage/timezone_manage_input_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimezoneScreen extends ConsumerStatefulWidget {
  TimezoneScreen({super.key});

  @override
  ConsumerState<TimezoneScreen> createState() => _MedTimeManageScreenState();
}

class _MedTimeManageScreenState extends ConsumerState<TimezoneScreen> {
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
          getMedTimeList(),
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    for (TimezoneModel medtime in timezoneModel) {
      medtime.controller!.dispose();
    }

    super.dispose();
  }

  void getMedTimeList() async {
    final timezoneService = ref.read(timezoneServiceProvider);

    final timezoneList = await timezoneService.getTimezone();

    setState(() {
      timezoneModel = timezoneList
          .map<TimezoneModel>((e) => TimezoneModel(
              id: e['id'],
              name: e['name'],
              hour: e['hour'],
              midday: e['midday'],
              minute: e['minute'],
              controller: TextEditingController(),
              title: '${e['hour']}:${e['minute']}'))
          .toList();

      for (TimezoneModel medtime in timezoneModel) {
        medtime.controller!.text = '${medtime.title}';
      }
    });

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
                                      builder: (_) => TimezoneInputScreen(
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
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const TimezoneInputScreen()));
      },
      backgroundColor: PRIMARY_COLOR,
      foregroundColor: Colors.white,
      shape: CircleBorder(),
      child: Icon(Icons.add),
    );
  }
}
