import 'package:care_management/layout/main_layout.dart';
import 'package:flutter/material.dart';

class DosageInputScreen extends StatefulWidget {
  const DosageInputScreen({super.key});

  @override
  State<DosageInputScreen> createState() => _DosageInputScreenState();
}

class _DosageInputScreenState extends State<DosageInputScreen> {
  int _selectedDose = 1; // 초기 복용량 값


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('1회 복용량은 몇알인가요?'),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: DropdownButton<int>(
              value: _selectedDose,
              isExpanded: true,
              items: List<DropdownMenuItem<int>>.generate(
                10, // 예를 들어 최대 복용량을 10알로 설정
                    (int index) => DropdownMenuItem(
                  value: index + 1,
                  child: Text('${index + 1} 정'),
                ),
              ),
              onChanged: (int? newValue) {
                setState(() {
                  _selectedDose = newValue ?? 1;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: IconButton(
              icon: Icon(Icons.warning, color: Colors.yellow),
              onPressed: () {
                // 경고 아이콘 클릭 시 수행할 작업
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: ElevatedButton(
              child: Text('다음'),
              onPressed: () {
                // 다음 버튼 클릭 시 수행할 작업
              },
            ),
          ),
        ],
      ),
    );
  }
}
