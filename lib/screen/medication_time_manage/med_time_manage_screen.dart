import 'package:care_management/common/component/custom_components.dart';
import 'package:care_management/common/component/custom_text_field.dart';
import 'package:care_management/common/const/colors.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/screen/medication_time_manage/med_time_manage_input_screen.dart';
import 'package:flutter/material.dart';

class MedTimeManageScreen extends StatefulWidget {
  MedTimeManageScreen({super.key});

  @override
  State<MedTimeManageScreen> createState() => _MedTimeManageScreenState();
}

class _MedTimeManageScreenState extends State<MedTimeManageScreen> {
  List<Map<String, dynamic>> medTImeList = [
    {'title': '아침', 'time': '08:00', 'controller': TextEditingController()},
    {'title': '점심', 'time': '12:00', 'controller': TextEditingController()},
  ];
  List<String> _timeList = [];

  @override
  void initState() {
    // TODO: implement initState
    for (Map medtime in medTImeList) {
      medtime['controller'].text = medtime['time'];
    }

    for (int hour = 0; hour < 24; hour++) {
      for (int minute in [0, 30]) {
        _timeList.add(
            '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    for (Map medtime in medTImeList) {
      medtime['controller'].dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        appBartitle: '복약 시간대 관리',
        addPadding: true,
        floatingActionButton: _renderFloatingActionButton(),
        body: Align(
          alignment: Alignment.center,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ...medTImeList
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
                                      controller: medTime['controller'],
                                      readOnly: true,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        icon: Text(
                                          medTime['title'],
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
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => MedTimeManageInputScreen(editingMode : true, editingMedTimeData : medTime))
                                  );
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
            MaterialPageRoute(builder: (_) => const MedTimeManageInputScreen())
        );
      },
      backgroundColor: PRIMARY_COLOR,
      foregroundColor: Colors.white,
      shape: CircleBorder(),
      child: Icon(Icons.add),
    );
  }
}
