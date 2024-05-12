import 'package:care_management/common/component/custom_components.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/common/model/medicine_item_model.dart';
import 'package:care_management/screen/prescriptionRegistration/medication_note_screen.dart';
import 'package:flutter/material.dart';

class DosageInputScreen extends StatefulWidget {
  final String timezoneId;
  final MedicineItemModel medicineItem;

  const DosageInputScreen(
      {super.key, required this.medicineItem, required this.timezoneId});

  @override
  State<DosageInputScreen> createState() => _DosageInputScreenState();
}

class _DosageInputScreenState extends State<DosageInputScreen> {
  double _selectedDose = 1.0; // 초기 복용량 값

  @override
  void dispose() {
    // TODO: implement dispose
    print('----dosage input screen dispose------');

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('----DosageInputScreen -build------');

    return MainLayout(
      appBartitle: '약봉투 등록',
      addPadding: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: Text(
              '1회 복용량은 얼마인가요?',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 70.0,
                height: 60.0,
                child: DropdownButton<double>(
                  isExpanded: true,
                  icon: Image(
                    image: AssetImage("asset/icon/bottom_arrow.png"),
                  ),
                  value: _selectedDose,
                  underline: Container(
                    height: 1,
                    color: Color(0x67000000),
                  ),
                  onChanged: (double? newValue) {
                    setState(() {
                      _selectedDose = newValue!;
                    });
                  },
                  items: <double>[1, 2, 3, 4, 5]
                      .map<DropdownMenuItem<double>>((double value) {
                    return DropdownMenuItem<double>(
                      value: value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            value.toString(),
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(
                              width:
                                  8), // For spacing between the text and the icon
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                '정',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 120.0,
          ),
          DoneButton(
              onButtonPressed: () {
                widget.medicineItem.takeAmount = _selectedDose;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => MedicationNoteScreen(
                          medicineItem: widget.medicineItem,
                          timezoneId: widget.timezoneId,
                        )));
              },
              buttonText: '다음')
        ],
      ),
    );
  }
}
