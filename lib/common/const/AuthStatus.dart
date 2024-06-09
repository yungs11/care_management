import 'package:care_management/common/component/dialog.dart';
import 'package:care_management/common/const/data.dart';
import 'package:care_management/common/dio/dio.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/common/router/navigator.dart';
import 'package:care_management/common/secure_storage/secure_storage.dart';
import 'package:care_management/screen/auth/id_input_screen.dart';
import 'package:care_management/screen/user_main_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus {
  authenticated,
  unauthenticated
}

final authStatusProvider = StateNotifierProvider<AuthStateNotifier, AuthStatus>((ref) {
  return AuthStateNotifier(ref);
});

class AuthStateNotifier extends StateNotifier<AuthStatus> {
  Ref ref;

  AuthStateNotifier(this.ref) : super(AuthStatus.unauthenticated);

  void expiredToken() {
    state = AuthStatus.unauthenticated;
    goLoginPage();
    print(state);
  }

  void logOut() async{

    state = AuthStatus.unauthenticated;
    final dio = ref.watch(dioProvider);
    final storage = ref.read(secureStorageProvider);

    try {
      final resp = await dio.post('${apiIp}/auth/signout',
          options: Options(
            headers: {'accessToken': 'true'},
          ));
      print(resp);

      await storage.deleteAll();

      goLoginPage();

    } on DioException catch (e) {
      ref.watch(dialogProvider.notifier).errorAlert(e);
    }



  }

  void logIn(Map body) async{
    final dio = ref.watch(dioProvider);

    try {
      final resp = await dio.post('${apiIp}/auth/signin',
          /*options: Options(headers: {
                        'authorization': 'Bearer $token',
                      }),*/
          data: body);

      print(resp);

      final responseData = resp.data['data']; // 최상위 'data' 필드에 접근
      final refreshToken = responseData[
      'refresh_token']; // 'data' 객체 내의 'refresh_token'
      final accessToken = responseData[
      'access_token']; // 'data' 객체 내의 'access_token'


      print('login >> $state');
      final storage = ref.read(secureStorageProvider);

      await storage.write(
          key: REFRESH_TOKEN_KEY, value: refreshToken);
      await storage.write(
          key: ACCESS_TOKEN_KEY, value: accessToken);

      state = AuthStatus.authenticated;
      goUserMainPage();

    } on DioException catch (e) {
      print(e.response);
      if (e.response!.data['errors'] != null) {

        return ref.watch(dialogProvider.notifier).showAlert(
            e.response!.data['errors'].values
                .toString()
                .replaceAll(RegExp(r'\(|\)'), ''));


      } else {
        return ref.watch(dialogProvider.notifier).showAlert(e.response!.data['message']);
      }
    } catch (e) {
      print(e);
    }
  }


  void goLoginPage() {

    // container를 사용하여 ref를 얻고 Provider 읽기
    final navigatorProvider = ref.watch(navigatorKeyProvider);

    print(navigatorProvider);

    navigatorProvider.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => IdInputScreen()), (route) => false);
  }
  void goUserMainPage() {

    // container를 사용하여 ref를 얻고 Provider 읽기
    final navigatorProvider = ref.watch(navigatorKeyProvider);

    navigatorProvider.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => MainLayout(
            appBartitle: '',
            body: UserMainScreen(),
            addPadding: false,
          ),
        ),
            (route) => false);
  }


}