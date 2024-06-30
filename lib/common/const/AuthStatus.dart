import 'package:care_management/common/component/dialog.dart';
import 'package:care_management/common/const/data.dart';
import 'package:care_management/common/dio/dio.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/common/router/navigator.dart';
import 'package:care_management/common/secure_storage/secure_storage.dart';
import 'package:care_management/screen/auth/id_input_screen.dart';
import 'package:care_management/screen/auth/service/auth_service.dart';
import 'package:care_management/screen/userMain/user_main_screen.dart';
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

  void logIn(Map<String, dynamic> body) async{
    final authService = ref.watch(authServiceProvider);

    final resp= await authService.login(body);

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
  }
  void logOut() async{
    state = AuthStatus.unauthenticated;
    final authService = ref.watch(authServiceProvider);
    try {
      final resp = await authService.logout();
      print(resp);
      if(resp){
        final storage = ref.read(secureStorageProvider);
        await storage.deleteAll();
        goLoginPage();
      }
    }catch(e){
      print(e);
    }
  }

    void expiredToken() {
    state = AuthStatus.unauthenticated;
    goLoginPage();
    print(state);
  }





  void goLoginPage() {

    final navigatorProvider = ref.watch(navigatorKeyProvider);

    print(navigatorProvider);

    navigatorProvider.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => IdInputScreen()), (route) => false);
  }
  void goUserMainPage() {

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