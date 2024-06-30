import 'package:care_management/common/component/dialog.dart';
import 'package:care_management/common/const/data.dart';
import 'package:care_management/common/secure_storage/secure_storage.dart';
import 'package:care_management/common/service/common_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref);
});

class AuthService {
  final Ref ref;
  late final Dio dio;

  AuthService(this.ref) {
    dio = Dio();
    dio.options.baseUrl = '${apiIp}';
  }

  Future<int> checkUser(String email) async {
    //interceptor 가지 않기 위해 이렇게 처리
    Response? resp = null;
    try {
      resp = await dio.post(
        '/user/check-email',
        data: {'email': email},
      );
      if (resp!.data['code'] == 1100 ||
          resp.data['code'] == 1120 ||
          resp.data['code'] == 1110)
        return resp.data['code']; // 단순히 응답 코드를 반환
      else
        ref.watch(dialogProvider.notifier).errorAlert(resp);
      return -1;
    } on DioException catch (e) {
      ref.watch(dialogProvider.notifier).errorAlert(e);
      return -1;
    } catch (e) {
      print(e);
      return -1;
    }
  }

  Future<Response> login(Map data) async {
    try {
      final resp = await dio.post('/auth/signin', data: data);

      if (resp.data['code'] != 200) {
        return ref.watch(dialogProvider.notifier).errorAlert(resp);
      }

      return resp;
    } on DioException catch (e) {
      print(e.response);
      return ref.watch(dialogProvider.notifier).errorAlert(e);
    } catch (e) {
      print(e);
      return ref.watch(dialogProvider.notifier).errorAlert(e);
    }
  }


  Future<bool> logout() async {
    try {
      final resp = await dio.post('/auth/signout',
          options: Options(
            headers: {'accessToken': 'true'},
          ));

      if (resp.data['code'] != 200) {
        ref.watch(dialogProvider.notifier).errorAlert(resp);
        return false;
      }

      return true;
    } on DioException catch (e) {
      print(e.response);
      ref.watch(dialogProvider.notifier).errorAlert(e);
      return false;
    } catch (e) {
      print(e);
      ref.watch(dialogProvider.notifier).errorAlert(e);
      return false;
    }
  }

  Future<bool> join(Map data) async {
    //interceptor 가지 않기 위해 이렇게 처리
    Response? resp = null;
    try {
      final resp = await dio.post('/auth/signup', data: {
        'name': data['name'],
        'email': data['email'],
        'password': data['password']
      });

      if (resp.data['code'] != 200) {
        ref.watch(dialogProvider.notifier).errorAlert(resp);
        return false;
      }
    } on DioException catch (e) {
      if (e.response!.data['errors'] != null) {
        ref.watch(dialogProvider.notifier).errorAlert(resp);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  //api 나와야함! => 아직 미개발
  Future<bool> renewPasswd(Map data) async {
    //interceptor 가지 않기 위해 이렇게 처리
    Response? resp = null;
    try {
      final resp = await dio.post('/auth/signup', data: {
        'name': data['name'],
        'email': data['email'],
        'password': data['password']
      });

      if (resp.data['code'] != 200) {
        ref.watch(dialogProvider.notifier).errorAlert(resp);
        return false;
      }
    } on DioException catch (e) {
      if (e.response!.data['errors'] != null) {
        ref.watch(dialogProvider.notifier).errorAlert(resp);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }
}
