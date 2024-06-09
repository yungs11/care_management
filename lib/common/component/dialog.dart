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
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('확인',style: TextStyle(color: PRIMARY_COLOR),),
              onPressed: () {
                Navigator.of(navigatorKey.currentState!.context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  errorAlert(DioException e){
    print(e);
    print(e.response);
    print(e.response!.data['errors']);
    if (e.response!.data['errors'].isNotEmpty) {
      return showAlert(
          e.response!.data['errors'].values
              .toString()
              .replaceAll(RegExp(r'\(|\)'), ''));
    } else {
      return showAlert(
          e.response!.data['message']);
    }
  }

  errorExceptionAlert(Object e){
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


