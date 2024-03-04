import 'package:care_management/const/colors.dart';
import 'package:flutter/material.dart';

class DosageScheduleList extends StatefulWidget {
  final String scheduleTitle;
  final VoidCallback onPressed;
  final bool isSelected;

  const DosageScheduleList(
      {super.key,
      required this.scheduleTitle,
      required this.onPressed,
      required this.isSelected});

  @override
  State<DosageScheduleList> createState() => _DosageScheduleListState();
}

class _DosageScheduleListState extends State<DosageScheduleList> {
  List<String> medicines = ['코프시럽', '잘티진정', '잘티플루정'];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Align(
        alignment: FractionalOffset.centerLeft,
        child: Text(
          widget.scheduleTitle,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
          ),
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: widget.isSelected ? PRIMARY_COLOR : NON_SELECTED_COLOR,
              width: 2.0),
        ),
        margin: EdgeInsets.only(bottom: 15.0),
        width: double.infinity,
        height: 130,
        child: Scrollbar(
          child: ListView.builder(
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                final item = medicines[index];
                return Dismissible(
                  key: Key(item),
                  onDismissed: (direction) {
                    setState(() {
                      medicines.removeAt(index);
                    });

                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('$item 제거됨')));
                  },
                  background: Container(color: Colors.red),
                  child: SizedBox(
                    height: 35.0,
                    child: ListTile(
                      //contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                      leading:  Icon(
                      Icons.circle_outlined,
                      color: widget.isSelected ? PRIMARY_COLOR : Colors.grey,
                      size: 10.0,
                    ),

                      title: Text(item),
                      trailing: IconButton(
                        icon: Icon(Icons.close , size: 15.0),
                        onPressed: () {
                          setState(() {
                            medicines.removeAt(index);
                          });
                        },
                      ),
                    ),
                  ),
                );

              }),
        ),
      ),
    ]);
  }
}
