
import 'package:care_management/common/const/data.dart';
import 'package:care_management/common/router/navigator.dart';
import 'package:care_management/common/secure_storage/secure_storage.dart';
import 'package:care_management/screen/auth/id_input_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider((ref) {
  final dio= Dio();

  final storage = ref.watch(secureStorageProvider); //ref를 사용해서 또다른 provider 가져오기

  dio.interceptors.add(
    CustomInterceptor(
      storage: storage,
    )
  );
  return dio;

});
//
//
//
class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
  });

  // 1) 요청을 보낼때
  // 요청 보내질때마다 요청 header에 accessToken : true라는 값이 있으면
  // 실제 토큰을 가져와서 authorization : bearer $token 을 헤더로 변경한다
  @override
  void onRequest(RequestOptions options,
      RequestInterceptorHandler handler) async {
    print('REQUEST [${options.uri}');
    print(['${options.headers}', options.headers['accessToken'] == 'true']);
    print(['${options.headers}', options.headers['refreshToken'] == 'true']);

    if (options.headers['accessToken'] == 'true') {

      //헤더 삭제
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      //실제 토큰으로 대체
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    if (options.headers['refreshToken'] == 'true') {
      //헤더 삭제
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      //실제 토큰으로 대체
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    print(['${options.headers}']);

    // TODO: implement onRequest
    return super.onRequest(options, handler); //요청 fire
  }

  // 2) 응답을 받을 때
  // 3) 에러가 났을 때
  @override
  Future<void> onError(DioException err,
      ErrorInterceptorHandler handler) async {
    // 401 에러가 났을 때 (토큰 에러 )
    // 토큰을 재발급 받는 시도를 하고 토큰이 재발급되면
    // 다시 새로운 토큰으로 요청한다
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');
    print('${err.requestOptions.headers}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    if (refreshToken == null) {
      return handler.reject(err); //에러 발생
    }

    final isStatus401 = err.response?.statusCode == 401 ;
    final isPathRefresh = err.requestOptions.path ==
        '/auth/token'; // 토큰 새로 발급받는 api

    if (isStatus401 && !isPathRefresh) { //토큰 만료이나, 새로 토큰 발급 받는 url이 아니라면
      print('리프레시 토큰으로 억세스 토큰 재발급 로직 시작');
      
      final dio = Dio();

      try {
        final resp = await dio.post(
          '${apiIp}/auth/token',
          options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          ),
        );

        final accessToken = resp.data['accessToken'];

        final options = err.requestOptions;

        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        //토큰만료로  에러 발생시킨 요청해서 토큰만 바꿔서 다시 모두 재전송
        final response = await dio.fetch(options);

        //새로 받은 요청은 성공으로 요청함.
        //handler.resolve => 성공으로 리턴
        return handler.resolve(response);
      } on DioException catch (e) {
        print('-----refresh 실패-----');
        print(e.response);

        //
        Provider((ref) {
          ref
              .watch(navigatorKeyProvider)
              .currentState
              ?.pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => IdInputScreen()),
                  (route) => false);


        });

        return handler.reject(err); //에러 발생
      }


      // TODO: implement onError

    }
    if(err.response?.statusCode == 404 || err.response?.statusCode == 500){
      print(err.response!.data['message']);
      if(err.response!.data['message'].isNotEmpty){
        print(err.response!.data['message'].indexOf('토큰'));
        if(err.response!.data['message'].indexOf('토큰') != -1){
          print('화면이동..!' );
          print(navigatorKeyProvider);

          try{
            print('왜 안갈까?');
            Provider((ref) {
              print(ref
                  .watch(navigatorKeyProvider)
                  .currentState);

              ref
                  .watch(navigatorKeyProvider)
                  .currentState
                  ?.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => IdInputScreen()),
                      (route) => false);

            });
            //return handler.reject(err); //
          }catch(e){
            Provider((ref) {
              print('왜 안갈까?');
              print(ref);

              ref
                  .watch(navigatorKeyProvider)
                  .currentState
                  ?.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => IdInputScreen()),
                      (route) => false);

            });

            return handler.reject(err); //
          }

        }
      }else{
        //return handler.reject(err); //에러 발생
       // return super.onError(err, handler);
      }


    }




  }
}