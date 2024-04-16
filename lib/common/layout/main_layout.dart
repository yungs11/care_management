import 'package:care_management/common/const/tabs.dart';
import 'package:care_management/screen/drawer/main_drawer.dart';
import 'package:care_management/screen/prescriptionHistory/prescription_history_screen.dart';
import 'package:care_management/screen/prescriptionRegistration/prescription_bag_input_screen.dart';
import 'package:care_management/screen/user_main_screen.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatefulWidget {
  final String appBartitle;
   Widget body;
   Widget? floatingActionButton;
  bool addPadding;
  MainLayout({
    super.key,
    required this.appBartitle,
    required this.body,
    this.floatingActionButton = null,
    this.addPadding = false,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  List<Widget>? _cachedScreens;

  List _pages = [];

  @override
  void initState() {
    super.initState();
    // 각 화면(위젯)의 인스턴스를 초기화하고 캐싱
    _cachedScreens = TABS.map((tab) => tab.screen).toList();
    _pages = [
      {'screen' : PrescriptionBagInputScreen(), 'addPadding': true},
      {'screen': UserMainScreen(), 'addPadding': false},
      {'screen': PrescriptionHistoryScreen(selectedDate: DateTime(2023, 12, 29)), 'addPadding': false,},
    ];
  }

  @override
  Widget build(BuildContext context) {
    print(widget.addPadding);

    return Scaffold(
        endDrawer: MainDrawer(),
        appBar: AppBar(
          title: Text(widget.appBartitle),
        ),
        floatingActionButton: widget.floatingActionButton,
        body: widget.addPadding ? addPadding32(widget.body) : widget.body,
        //body :  widget.addPadding
        //? addPadding32(widget.body) : widget.body,

        bottomNavigationBar: renderFooter() );
  }

  Widget addPadding32(body) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: body,
    ));
  }

  Widget renderFooter() {
    int _tabIndex = 0;

    return BottomNavigationBar(
      selectedItemColor: const Color(0xFF001A72),
      unselectedItemColor: const Color(0xFF001A72),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      currentIndex: _tabIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (value) {
        setState(() {
          _tabIndex = value;
          widget.body = _pages[_tabIndex]['screen'];
          widget.addPadding = _pages[_tabIndex]['addPadding'];
          widget.floatingActionButton = null;
        });
      },
      items: TABS
          .map((e) => BottomNavigationBarItem(
              icon: ImageIcon(AssetImage(e.iconImaPath)), label: e.label))
          .toList(),
    );
  }
}
