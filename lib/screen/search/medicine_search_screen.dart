import 'package:care_management/common/component/custom_components.dart';
import 'package:care_management/common/const/colors.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/screen/prescriptionRegistration/dosage_input_screen.dart';
import 'package:flutter/material.dart';

class MedicineSearchScreen extends StatefulWidget {
  const MedicineSearchScreen({super.key});

  @override
  State<MedicineSearchScreen> createState() => _MedicineSearchScreenState();
}

class _MedicineSearchScreenState extends State<MedicineSearchScreen> {
  int? _selectedRadioValue;
  List<Map> searchResult = [
    {
      'radioValue' : 0,
      'name' : '잘티진정(알러지질환약, 한미약품, 흰색정제)'
    },
    {
      'radioValue' : 1,
      'name' : '잘티콜록정 (감기약,한미약품,분홍색정제)'
    },
    {
      'radioValue' : 2,
      'name' : '잘티힘빠져정 (근육이완제,한미약품,흰색정제)'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       // title: Text('1회 복용량은 몇알인가요?'),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      hintText: '약 이름',
                      prefixIcon: Icon(Icons.search),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      // 포커스 되었을 때의 테두리 색상
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: PRIMARY_COLOR),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0,),
                  ...searchResult.map((medicineInfo) => renderRadioListTitle(medicineInfo)).toList()

                ],
              ),
            ),
            SizedBox(height: 50.0,),
            DoneButton(onButtonPressed: (){
              final selectedResult = searchResult.firstWhere(
                    (element) => element['radioValue'] == _selectedRadioValue,
                //orElse: () => null,
              );
              print('selc >> $selectedResult');

              if (selectedResult != null) {
                Navigator.of(context).push(MaterialPageRoute(builder: (_)=> DosageInputScreen()));
                //Navigator.pop(context, selectedResult);
              }
            }, buttonText:
            '선택')

          ],
        ),
      ),

      );
  }


  Widget renderRadioListTitle(Map medicineInfo){
    return RadioListTile<int>(
      title: Text(medicineInfo['name'],style: TextStyle(

      ),),
      value: medicineInfo['radioValue'],
      groupValue: _selectedRadioValue,
      activeColor: PRIMARY_COLOR,
      onChanged: (int? value) {
        setState(() {
          _selectedRadioValue = value;
        });
      },
    );
  }
}
