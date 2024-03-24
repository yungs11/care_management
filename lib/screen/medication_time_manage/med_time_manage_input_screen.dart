import 'package:care_management/common/component/custom_components.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/screen/medication_time_manage/med_time_manage_screen.dart';
import 'package:flutter/material.dart';

class MedTimeManageInputScreen extends StatefulWidget {
  final bool? editingMode;
  final Map<String, dynamic>? editingMedTimeData;
  const MedTimeManageInputScreen({super.key, this.editingMode, this.editingMedTimeData});

  @override
  State<MedTimeManageInputScreen> createState() =>
      _MedTimeManageInputScreenState();
}

class _MedTimeManageInputScreenState extends State<MedTimeManageInputScreen> {
  final TextEditingController _textController = TextEditingController();
  String _selectedTime = ''; // 초기 시간
  List<String> _timeList = [];

  @override
  void initState() {
    // TODO: implement initState

    for(int hour = 0; hour< 24; hour++){
      for(int minute in [0,30]){
        _timeList.add('${hour.toString().padLeft(2,'0')}:${minute.toString().padLeft(2,'0')}');
      }
    }

    _selectedTime = '08:00';

    if(widget.editingMode != null){
      _selectedTime = widget.editingMedTimeData!['time'];
      _textController.text = widget.editingMedTimeData!['title'];
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
            items: _timeList
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Center(child: Text(value)),
              );
            }).toList(),
          ),
          SizedBox(
            height: 60.0,
          ),
          DoneButton(
            buttonText: '등록',
            onButtonPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => MedTimeManageScreen()));
            },
          )
        ],
      ),
    );
  }
}
