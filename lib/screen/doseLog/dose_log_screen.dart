import 'package:care_management/common/component/card_title.dart';
import 'package:care_management/common/component/log_card_list.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/common/model/medication_schedule_box_model.dart';
import 'package:care_management/screen/doseLog/service/doselog_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DoseLogScreen extends ConsumerStatefulWidget {
  DateTime selectedDay;

  DoseLogScreen({super.key, required this.selectedDay});

  @override
  ConsumerState<DoseLogScreen> createState() => _DoseLogScreenState();
}

class _DoseLogScreenState extends ConsumerState<DoseLogScreen> {
  List<MedicationScheduleBoxModel> scheduleBoxModel = [];
  Future<List<MedicationScheduleBoxModel>>? dataFuture;
  //TextEditingController dateController=TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dataFuture = getTakingList();
  }

  Future<List<MedicationScheduleBoxModel>> getTakingList() async {
    final dService = ref.read(doselogServiceProvider);

    final historyList = await dService.fetchIntakeHistory(DateFormat('yyyy-MM-dd').format(widget.selectedDay));

      scheduleBoxModel = historyList
          .map<MedicationScheduleBoxModel>(
              (e) => MedicationScheduleBoxModel.fromJson(json: e))
          .toList();

      print(
          '>>>>>>>>>>> ${scheduleBoxModel.map((e) => e.pills!.map((ek) => print(ek.pillName)))}');


    return scheduleBoxModel;
    //medTImeList
  }

  void reloadData() {
    setState(() {
      dataFuture = getTakingList(); // 데이터 재요청
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MedicationScheduleBoxModel>>(
        future: dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MainLayout(
                appBartitle: '',
                body:
                    Center(child: CircularProgressIndicator())); // 로딩 인디케이터 표시
          } else if (snapshot.hasError) {
            return MainLayout(
                appBartitle: '',
                body: Center(
                    child:
                        Text('오류가 발생하였습니다: ${snapshot.error}'))); // 오류 메시지 표시
          } else {
            return MainLayout(
              appBartitle: '',
              body: SafeArea(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    renderDateHeader(),
                    const SizedBox(
                      height: 50.0,
                    ),
                    Expanded(child: renderPillCard(scheduleBoxModel)),
                  ],
                ),
              )),
            );
          }
        });
  }

  Widget renderDateHeader() {
    return InkWell(
        onTap: () => _selectDate(context),
        child: Text(
          DateFormat('yyyy-MM-dd').format(widget.selectedDay),
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
          ),
        ));
  }

  Widget renderPillCard(List<MedicationScheduleBoxModel> scheduleBoxModel) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CardTitle(
            title: DateFormat('yyyy-MM-dd').format(widget.selectedDay),
            isToday: DateFormat('yyyy-MM-dd').format(widget.selectedDay) ==
                DateFormat('yyyy-MM-dd').format(DateTime.now().toUtc())),
        Expanded(
          child: SingleChildScrollView(
            child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 1.0),
                //border radius 주기위해!
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(4.0),
                        bottomRight: Radius.circular(4.0))),
                //color: lightColor,
                child: Column(
                    children: scheduleBoxModel
                        .map((pillListPerTimeBox) =>
                            LogCardList(timezoneList: pillListPerTimeBox))
                        .toList())),
          ),
        )
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor:
                Theme.of(context).primaryColor.withAlpha(128), // 헤더 배경 색상
            //accentColor: Colors.blue, // 선택된 날짜 및 현재 날짜 색상
            colorScheme: ColorScheme.light(
                primary: Theme.of(context).primaryColor.withOpacity(0.5)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != DateTime.now()) {
      widget.selectedDay = picked.toUtc(); //"${picked.toUtc()}".split(' ')[0];
      reloadData();
    }
  }
}
