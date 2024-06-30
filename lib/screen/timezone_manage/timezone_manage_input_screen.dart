import 'package:care_management/common/component/custom_components.dart';
import 'package:care_management/common/component/dialog.dart';
import 'package:care_management/common/const/data.dart';
import 'package:care_management/common/dio/dio.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/common/model/timezone_model.dart';
import 'package:care_management/common/util/formatUtil.dart';
import 'package:care_management/screen/timezone_manage/service/timezone_service.dart';
import 'package:care_management/screen/timezone_manage/timezone_manage_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimezoneInputScreen extends ConsumerStatefulWidget {
  final bool editingMode;
  final TimezoneModel? editingMedTimeData;
  const TimezoneInputScreen(
      {super.key, this.editingMode = false, this.editingMedTimeData});

  @override
  ConsumerState<TimezoneInputScreen> createState() =>
      _MedTimeManageInputScreenState();
}

class _MedTimeManageInputScreenState
    extends ConsumerState<TimezoneInputScreen> {
  final TextEditingController _textController = TextEditingController();
  String _selectedTime = ''; // 초기 시간
  List<String> _timeList = [];

  @override
  void initState() {
    // TODO: implement initState

    for (int hour = 0; hour < 24; hour++) {
      for (int minute in [0, 30]) {
        _timeList.add(
            '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
      }
    }

    _selectedTime = '08:00';

    if (widget.editingMode) {
      _selectedTime = widget.editingMedTimeData!.title;
      _textController.text = widget.editingMedTimeData!.name;
    }

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appBartitle: '복약 시간대 관리',
      addPadding: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(
            labelText: '명칭',
            controller: _textController,
          ),
          SizedBox(
            height: 20.0,
          ),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: '시간',
            ),
            value: _selectedTime,
            onChanged: (String? newValue) {
              setState(() {
                _selectedTime = newValue!;
              });
            },
            items: _timeList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Center(child: Text(value)),
              );
            }).toList(),
          ),
          SizedBox(
            height: 60.0,
          ),
          !widget.editingMode
              ? DoneButton(
                  buttonText: '등록',
                  onButtonPressed: () async {
                    final timezoneService = ref.watch(timezoneServiceProvider);

                    Map<String, dynamic> timezoneData = {
                      'name': _textController.text,
                      'midday': FormatUtil.parseStringAMPM(_selectedTime),
                      'hour': _selectedTime.substring(0, 2),
                      'minute': _selectedTime.substring(3, 5),
                      'use_alert': false,
                    };

                    await timezoneService.insertTimezone(timezoneData);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => TimezoneScreen()),
                        (route) => false);

                    //medTImeList
                  },
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        child: Text(
                          '삭제',
                        ),
                        onPressed: () async {
                          final timezoneService =
                          ref.watch(timezoneServiceProvider);

                          String deleteId = widget.editingMedTimeData!.id;

                          await timezoneService.deleteTimezone(deleteId);

                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (_) => TimezoneScreen()),
                                (route) => false);
                          //medTImeList
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // 테마에 맞는 버튼 색상
                          foregroundColor: Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Color(0x66000000)),
                              borderRadius: BorderRadius.circular(5.0)),
                          padding: const EdgeInsets.all(32.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      flex: 1,
                      child: DoneButton(
                        buttonText: '수정',
                        onButtonPressed: () async {
                          final timezoneService =
                              ref.watch(timezoneServiceProvider);

                          Map<String, dynamic> timezoneData = {
                            'id': widget.editingMedTimeData!.id,
                            'name': _textController.text,
                            'midday': FormatUtil.parseStringAMPM(_selectedTime),
                            'hour': _selectedTime.substring(0, 2),
                            'minute': _selectedTime.substring(3, 5),
                            'use_alert': false,
                          };

                          await timezoneService.updateTimezone(timezoneData);

                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (_) => TimezoneScreen()),
                              (route) => false);

                          //medTImeList
                        },
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
