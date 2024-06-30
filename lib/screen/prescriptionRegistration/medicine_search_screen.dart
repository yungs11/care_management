import 'package:care_management/common/component/custom_components.dart';
import 'package:care_management/common/component/dialog.dart';
import 'package:care_management/common/const/colors.dart';
import 'package:care_management/common/model/medicine_item_model.dart';
import 'package:care_management/screen/prescriptionRegistration/dosage_input_screen.dart';
import 'package:care_management/screen/prescriptionRegistration/service/prescription_service.dart';
import 'package:care_management/screen/search/model/medicine_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MedicineSearchScreen extends ConsumerStatefulWidget {
  final String timezoneId;
  final String timezoneTitle;

  const MedicineSearchScreen( {required this.timezoneId, required this.timezoneTitle, super.key});

  @override
  ConsumerState<MedicineSearchScreen> createState() =>
      _MedicineSearchScreenState();


}

class _MedicineSearchScreenState extends ConsumerState<MedicineSearchScreen> {
  int? _selectedRadioValue;
  List<Map> searchResult = [
    /* {'radioValue': 0, 'name': '잘티진정(알러지질환약, 한미약품, 흰색정제)'},
    {'radioValue': 1, 'name': '잘티콜록정 (감기약,한미약품,분홍색정제)'},
    {'radioValue': 2, 'name': '잘티힘빠져정 (근육이완제,한미약품,흰색정제)'},*/
  ];
  final TextEditingController _controller = TextEditingController();


  @override
  void dispose() {
    print('--medicinesearch dispose-----');
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('--medicinesearch build-----');

    return Scaffold(
      appBar: AppBar(
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
            renderSearchArea(),
            renderSearchList(),
            SizedBox(
              height: 50.0,
            ),
            renderDoneBtn(),
          ],
        ),
      ),
    );
  }

  Widget renderRadioListTitle(Map medicineInfo) {
    print('----------render----------');
    print(medicineInfo);

    return RadioListTile<int>(
      title: Text(
        medicineInfo['name'],
        style: TextStyle(),
      ),
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

  Widget renderSearchArea() {
    final pservice = ref.read(PrescriptionServiceProvider);

    return Row(
      children: [
        Flexible(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: '약 이름을 검색하세요.',
              prefix: SizedBox(width: 15),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              // 포커스 되었을 때의 테두리 색상
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: PRIMARY_COLOR),
              ),
            ),
          ),
        ),
        IconButton(
            onPressed: () async {
              try{
                final medicineList =
                    await pservice.fetchMedicine('${_controller.text}');

                setState(() {
                  final List<MedicineInfoModel> medicines = medicineList
                      .map<MedicineInfoModel>(
                        (item) => MedicineInfoModel.fromJson(json: item),
                  )
                      .toList();
                  //잘티진정(알러지질환약, 한미약품, 흰색정제)
                  searchResult = List.generate(
                      medicines.length,
                          (index) => {
                        'radioValue': index,
                       'medicineId' : '${medicines[index].id}',
                        'name': '${medicines[index].name}'
                      });
                });
              }catch(e){
                setState(() {
                  searchResult.clear();
                });
              }

            },
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color(0x66000000)),
                  borderRadius: BorderRadius.circular(5.0)),
            ),
            icon: Icon(Icons.search)),
      ],
    );
  }

  Widget renderSearchList(){
    final bottomInset = MediaQuery.of(context)
        .viewInsets
        .bottom; //시스템적 UI 때문에 가려진 UI 사이즈(키보드가 차지하는 부분)

    return Container(
      height: MediaQuery.of(context).size.height / 2 - bottomInset,
      child: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            if (searchResult.length > 0)
              ...searchResult
                  .map((medicineInfo) =>
                  renderRadioListTitle(medicineInfo))
                  .toList()
            else
              Center(child: Text('약 정보가 없습니다')),
          ],
        ),
      ),
    );
  }

  Widget renderDoneBtn(){
    return DoneButton(
        onButtonPressed: () async {
          try{
            final selectedResult = searchResult.firstWhere(
                  (element) => element['radioValue'] == _selectedRadioValue,
              //orElse: () => null,
            );
            print('##########');
            print(selectedResult);
           final medicineItem = MedicineItemModel(medicineId: selectedResult['medicineId'], name: selectedResult['name'], selected: true);


         //  ref.read(timezoneProvider.notifier).addTimezone(TimezonBoxModel(timezoneId: widget.timezoneId, timezoneTitle: widget.timezoneTitle));

            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => DosageInputScreen(medicineItem: medicineItem, timezoneId: widget.timezoneId,)));

          }catch(e){
            return await ref.watch(dialogProvider.notifier).showAlert('등록할 약을 선택해주세요.');
          }
        },
        buttonText: '선택');
  }
}
