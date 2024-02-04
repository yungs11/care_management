import 'package:care_management/const/tabs.dart';
import 'package:flutter/material.dart';

class JoinLayout extends StatelessWidget {
  final String appBartitle;
  final Widget body;
  JoinLayout({super.key, required this.appBartitle, required this.body}  );

  @override
  Widget build(BuildContext context) {

    return Scaffold(
    appBar: AppBar(
    title: Text(appBartitle),
    ),
    body: body,
    );
  }
}
