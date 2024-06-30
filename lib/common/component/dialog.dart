import 'package:care_management/common/const/colors.dart';
import 'package:care_management/common/router/navigator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*ref 사용해야하므로 consumer~ widget인 경우만 사용 가능*/
// StateNotifierProvider 정의
final dialogProvider = StateNotifierProvider<DialogStateNotifier, bool>((ref) {
  return DialogStateNotifier(ref);
});

// Dialog 상태를 관리할 StateNotifier
class DialogStateNotifier extends StateNotifier<bool> {
  Ref ref;
  DialogStateNotifier(this.ref) : super(false);

  //void showDialog() => state = true;
  //void hideDialog() => state = false;

  Future<void> showAlert(String content) async {
    final navigatorKey = ref.watch(navigatorKeyProvider);

    return showDialog<void>(
      context: navigatorKey.currentState!.context,
      //barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text("확인이 필요합니다"),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text(
                '확인',
                style: TextStyle(color: PRIMARY_COLOR),
              ),
              onPressed: () {
                Navigator.of(navigatorKey.currentState!.context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  errorAlert(dynamic e) {
    print(e);
    print(e.runtimeType);

    if (e.runtimeType == DioException) {
      e = e.response;
      print('여기탔어?>>>> $e');
    }

    print(e.data['errors']);

    if (e.data['errors'] != null) {
      if (e.data['errors'].isNotEmpty) // {}이 아닌지 확인
        return showAlert(e.data['errors'].toString());
    }

    if (e.data['message'] != null) {
      if (e.data['message'].isNotEmpty)
        return showAlert(e.data['message'].replaceAll(RegExp(r'\(|\)'), ''));
    }
  }

  errorExceptionAlert(Object e) {
    print('####');
    print(e);
    //print(e.response);
    //print(e.response!.data['errors']);
    /* if (e.data['errors'].isNotEmpty) {
      return CustomDialog.showAlert(
          context,
          e.response!.data['errors'].values
              .toString()
              .replaceAll(RegExp(r'\(|\)'), ''));
    } else {
      return CustomDialog.showAlert(
          context, e.response!.data['message']);
    }*/
  }
}
