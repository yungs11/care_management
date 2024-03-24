//
// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// final dioProvider = Provider((ref) {
//   final dio= Dio();
//
//  final storage = ref.watch(provider);
//
// });
//
//
//
// class CustomInterceptor extends Interceptor{
//   final FlutterSecureStorage storage;
//
//   CustomInterceptor({
//     required this.storage,
// });
//   // 1) 요청을 보낼때
//   // 요청 보내질때마다 요청 header에 accessToken : true라는 값이 있으면
//   // 실제 토큰을 가져와서 authorization : bearer $token 을 헤더로 변경한다
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
//     print('REQUEST [${options.uri}');
//
//
//     if(options.headers['accessToken'] == 'true'){
//       //헤더 삭제
//       options.headers.remove('accessToken');
//
//   //    final token = await storage.read(key: ACCESS_TOKEN_KEY);
//
//       //실제 토큰으로 대체
//       options.headers.addAll({
//         'authorization': 'Bearer $token',
//       });
//     }
//
//     if(options.headers['refreshToken'] == 'true'){
//       //헤더 삭제
//       options.headers.remove('refreshToken');
//
//   //    final token = await storage.read(key: ACCESS_TOKEN_KEY);
//
//       //실제 토큰으로 대체
//       options.headers.addAll({
//         'authorization': 'Bearer $token',
//       });
//     }
//     // TODO: implement onRequest
//     return super.onRequest(options, handler); //요청 fire
//   }
//   // 2) 응답을 받을 때
// }