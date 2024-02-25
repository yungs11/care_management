import 'package:care_management/const/tabs.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatelessWidget {
  final String appBartitle;
  final Widget body;
  final Widget? floatingActionButton;
  final bool addPadding;
  const MainLayout({super.key, required this.appBartitle, required this.body, this.floatingActionButton, this.addPadding = false}  );

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(appBartitle),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: (){},
          )
        ],
      ),
      floatingActionButton: floatingActionButton,
      body: addPadding ? addPadding32(body) : body,
      bottomNavigationBar:
        BottomNavigationBar(
          selectedItemColor: const Color(0xFF001A72),
          unselectedItemColor: const Color(0xFF001A72),
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

  Widget addPadding32(body){
    return SafeArea(
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: body,
    ));
  }
}
