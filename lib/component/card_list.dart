import 'package:care_management/const/colors.dart';
import 'package:care_management/model/medicine_model.dart';
import 'package:care_management/util/formatUtil.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardList extends StatefulWidget {
  final String title;
  String takingTime;
  bool takeYN = false;
  List<Medicine> pillList = [
    Medicine(
      name: '코푸시럽',
      takingTime: '09:05',
      takingCount: 1,
      takingYN: false,
      controller: TextEditingController(text: 1.toString()),
    ),
    Medicine(
      name: '모비드캡슐',
      takingTime: '09:05',
      takingCount: 1,
      takingYN: false,
      controller: TextEditingController(text: 1.toString()),
    ),
    Medicine(
      name: '무코레바정',
      takingTime: '09:05',
      takingCount: 1,
      takingYN: false,
      controller: TextEditingController(text: 1.toString()),
    ),
    Medicine(
      name: '트라몰서방정',
      takingTime: '09:05',
      takingCount: 0.5,
      takingYN: false,
      controller: TextEditingController(text: 0.5.toString()),
    ),
  ];

  CardList({super.key, required this.title, required this.takingTime});

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  String? dayOrNight;

  @override
  void dispose() {
    // TODO: implement dispose
    for (Medicine pill in widget.pillList) {
      pill.controller.dispose();
    }
    super.dispose();
  }

  void _updateTakingCount(Medicine pill, double value) {
    setState(() {
      pill.controller.text = FormatUtil.doubleToString(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        child: renderExpansionCard(widget.pillList),
      ),
    );
  }

  Widget renderExpansionCard(List<Medicine> pillList) {
    return ExpansionTile(
      title: renderTakingTiming(widget.title, widget.takingTime),
      initiallyExpanded: false,
      children: <Widget>[
        const Divider(
          height: 3,
          color: Color(0xffddddddd),
        ),
        ...pillList.map((pill) => renderPill(pill))
      ],
    );
  }

  Widget renderTakingTiming(String timingTitle, String timingTime) {
    return SizedBox(
      height: 70.0,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
            flex: 1,
            child: IconButton(
                onPressed: () {
                  setState(() {
                    final now = DateTime.now().toLocal();
                    widget.takeYN = !widget.takeYN;
                    for (Medicine pill in widget.pillList) {
                      pill.takingYN = widget.takeYN;
                    }
                    if (widget.takeYN) {
                      widget.takingTime =
                          DateFormat('HH:mm').format(now).toString();
                    } else {
                      widget.takingTime = '';
                    }

                    for (Medicine pill in widget.pillList) {
                      pill.takingTime = widget.takingTime;
                    }
                  });
                },
                icon: Icon(
                  Icons.circle_outlined,
                  color: widget.takeYN ? PRIMARY_COLOR : Colors.grey,
                ))),
        Expanded(
          flex: 2,
          child: Text(widget.title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0)),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Text(widget.takingTime,
                  style:
                      const TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0)),
              const SizedBox(
                width: 20.0,
              ),
              Text(
                FormatUtil.parseTimeToAMPM(widget.takingTime),
                style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.0),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget renderPill(Medicine pill) {
    //_textController.text= pill['takingCount'].toString() ?? '';

    return SizedBox(
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Expanded(
          flex: 1,
          child: IconButton(
              onPressed: () {
                setState(() {
                  final now = DateTime.now().toLocal();
                  pill.takingYN = !pill.takingYN;
                  if (pill.takingYN) {
                    pill.takingTime =
                        DateFormat('HH:mm').format(now).toString();
                  } else {
                    pill.takingTime = '';
                  }
                });
              },
              icon: Icon(
                Icons.circle_outlined,
                color: pill.takingYN ? PRIMARY_COLOR : Colors.grey,
                size: 10.0,
              )),
        ),
        Expanded(
          flex: 2,
          child: Text(pill.name,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0)),
        ),
        Expanded(
          child: Row(
            children: [
              Text(pill.takingTime.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0,
                    color: Colors.grey,
                  )),
              const SizedBox(
                width: 10.0,
              ),
              Text(
                  FormatUtil.parseTimeToAMPM(pill.takingTime.toString()),
                style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.0),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.grey[300]!)),
                child: IconButton(
                  onPressed: () {
                    if (pill.takingCount - 1 < 0) {
                      pill.takingCount = 0;
                    } else {
                      pill.takingCount -= 1;
                    }
                    _updateTakingCount(pill, pill.takingCount);
                  },
                  padding: const EdgeInsets.only(bottom: 5.0), // 패딩 제거
                  icon: const Icon(
                    Icons.minimize_outlined,
                    size: 10.0,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
                height: 20,
                child: TextFormField(
                  controller: pill.controller,
                  style: const TextStyle(fontSize: 12.0, color: Colors.black),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.zero),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.zero),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    hintText: 'Enter a number',
                  ),
                ),
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.grey[300]!)),
                child: IconButton(
                  onPressed: () {
                    pill.takingCount += 1;

                    _updateTakingCount(pill, pill.takingCount);
                  },
                  padding: EdgeInsets.zero, // 패딩 제거
                  icon: const Icon(
                    Icons.add,
                    size: 10.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
