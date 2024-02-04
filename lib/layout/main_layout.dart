import 'package:care_management/const/tabs.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatelessWidget {
  final String appBartitle;
  final Widget body;
  MainLayout({super.key, required this.appBartitle, required this.body}  );

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(appBartitle),
      ),
      body: body,
      bottomNavigationBar:
        BottomNavigationBar(
          selectedItemColor: Color(0xFF001A72),
          unselectedItemColor: Color(0xFF001A72),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          //currentIndex: controller.index,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            //   controller.animateTo(index);
          },
          items: TABS.map((e) => BottomNavigationBarItem(
              icon: ImageIcon(AssetImage(e.iconImaPath)), label: e.label))
              .toList(),
        )

    );
  }
}
