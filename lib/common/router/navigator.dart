import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//GlobalKey를 통해 Navigator에 접근
final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return GlobalKey<NavigatorState>();
});