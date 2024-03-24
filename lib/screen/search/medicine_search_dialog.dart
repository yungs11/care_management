import 'package:care_management/common/const/colors.dart';
import 'package:flutter/material.dart';

class MedicineSearchDialog extends StatefulWidget {
  const MedicineSearchDialog({super.key});

  @override
  State<MedicineSearchDialog> createState() => _MedicineSearchDialogState();
}

class _MedicineSearchDialogState extends State<MedicineSearchDialog> {
  int? _selectedRadioValue;

  @override
  Widget build(BuildContext context) {
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


    print('2222');
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('약 검색'),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: SingleChildScrollView(
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
            ...searchResult.map((medicineInfo) => renderRadioListTitle(medicineInfo)).toList()

          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text('선택',style: TextStyle(
            color: PRIMARY_COLOR
          ),),
          onPressed: () {
            final selectedResult = searchResult.firstWhere(
                  (element) => element['radioValue'] == _selectedRadioValue,
              //orElse: () => null,
            );
            print('selc >> $selectedResult');

            if (selectedResult != null) {
              Navigator.pop(context, selectedResult);
            }
          },
        ),
      ],
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
