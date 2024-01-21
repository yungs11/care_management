import 'package:flutter/material.dart';

class MainLayout extends StatelessWidget {
  final String appBartitle;
  final Widget body;
  const MainLayout({super.key, required this.appBartitle, required this.body});

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
