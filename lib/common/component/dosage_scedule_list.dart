import 'package:care_management/common/const/colors.dart';
import 'package:care_management/common/model/medicine_item_model.dart';
import 'package:care_management/screen/prescriptionRegistration/medicine_search_screen.dart';
import 'package:care_management/screen/prescriptionRegistration/prescription_bag_dosage_schedule_result_screen.dart';
import 'package:flutter/material.dart';

class DosageScheduleList extends StatefulWidget {
  final String timezoneTitle;
  final VoidCallback onPressed;
  final bool isBoxSelected;
  final bool isCopyMode;
  final String timezoneId;
  final List<MedicineItemModel> medicines;

  const DosageScheduleList({
    super.key,
    required this.timezoneTitle,
    required this.onPressed,
    required this.isBoxSelected,
    required this.isCopyMode,
    required this.medicines,
    required this.timezoneId,
  });

  @override
  State<DosageScheduleList> createState() => _DosageScheduleListState();
}

class _DosageScheduleListState extends State<DosageScheduleList> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Align(
        alignment: FractionalOffset.centerLeft, //좌측상단 기준 가운데 왼쪽 정렬
        child: Text(
          widget.timezoneTitle,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
          ),
        ),
      ),
      /* 전체선택 기능 제거
      widget.isCopyMode
          ? Align(
              alignment: FractionalOffset.centerLeft,
              child: TextButton(
                  onPressed: () {},
                  child: Text(
                    '전체선택',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  )),
            )
          : */
      SizedBox(
        height: 10.0,
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: widget.isBoxSelected ? PRIMARY_COLOR : NON_SELECTED_COLOR,
              width: 2.0),
        ),
        margin: EdgeInsets.only(bottom: 15.0),
        padding: EdgeInsets.symmetric(vertical: 10.0),
        width: double.infinity,
        height: widget.medicines.length == 0 ? 130.0 : null,
        child: widget.medicines.length > 0
            ? Scrollbar(
                child: Column(
                  children: [
                    SizedBox(
                      height: widget.medicines.length * 40.0,
                      child: ListView.builder(
                          itemCount: widget.medicines.length,
                          itemBuilder: (context, index) {
                            final item = widget.medicines[index];
                            return Dismissible(
                              key: Key(item.name!),
                              onDismissed: (direction) {
                                setState(() {
                                  widget.medicines.removeAt(index);
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('$item 제거됨')));
                              },
                              //   background: Container(color: Colors.red),
                              child: SizedBox(
                                height: 35.0,
                                child: ListTile(
                                  //contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                                  leading: IconButton(
                                    icon: Icon(
                                      Icons.circle_outlined,
                                      color: item.selected!
                                          ? PRIMARY_COLOR
                                          : Colors.grey,
                                      size: 10.0,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        item.selected = !item.selected!;
                                      });
                                    },
                                  ),

                                  title: Text(item.name!),
                                  trailing: IconButton(
                                    icon: Icon(Icons.close, size: 15.0),
                                    onPressed: () {
                                      setState(() {
                                        widget.medicines.removeAt(index);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    if (!widget.isCopyMode)
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              child: Text(
                                '+ 계속 추가',
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                /*  Navigator.of(context).popUntil(
                                  (route) =>
                                      route.settings.name ==
                                      'prescription-result', // 'prescription-result' 화면만 남기기
                                );
*/
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => MedicineSearchScreen(
                                            timezoneId: widget.timezoneId,
                                            timezoneTitle: widget.timezoneTitle,
                                          )),
                                );

                                /* Navigator.of(context).pushNamedAndRemoveUntil(
                                  'prescription-result',
                                      (Route<dynamic> route) => route.settings.name == 'prescription-result'
                                );

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => MedicineSearchScreen(
                                        timezoneId: widget.timezoneId,
                                        timezoneTitle: widget.timezoneTitle,
                                      )),
                                );*/
                              },
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              )
            : TextButton(
                style: TextButton.styleFrom(
                  //padding: EdgeInsets.symmetric(vertical: 20.0),,
                  //    backgroundColor: Colors.green,
                  foregroundColor:
                      widget.isBoxSelected ? PRIMARY_COLOR : NON_SELECTED_COLOR,
                ),
                child: Icon(Icons.add, size: 24),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => MedicineSearchScreen(
                            timezoneId: widget.timezoneId,
                            timezoneTitle: widget.timezoneTitle,
                          )));
                },
              ),
      ),
    ]);
  }
}
