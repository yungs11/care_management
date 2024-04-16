import 'package:care_management/common/const/colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CustomDialog {
  static Future<void> showAlert(BuildContext context, String content) async {
    return showDialog<void>(
      context: context,
      //barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //title: const Text('AlertDialog Title'),
        /*  content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),*/
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('확인',style: TextStyle(color: PRIMARY_COLOR),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static errorAlert(BuildContext context,DioException e){
    print(e);
    print(e.response);
    print(e.response!.data['errors']);
    if (e.response!.data['errors'].isNotEmpty) {
      return CustomDialog.showAlert(
          context,
          e.response!.data['errors'].values
              .toString()
              .replaceAll(RegExp(r'\(|\)'), ''));
    } else {
      return CustomDialog.showAlert(
          context, e.response!.data['message']);
    }
  }
}
