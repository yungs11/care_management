import 'package:care_management/common/component/dialog.dart';
import 'package:care_management/common/const/data.dart';
import 'package:care_management/common/dio/custom_interceptor.dart';
import 'package:care_management/common/secure_storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commonServiceProvider = Provider<CommonService>((ref) {
  return CommonService(ref);
});

class CommonService {
  final Ref ref;
  late Dio dio;

  CommonService(this.ref) {
    dio = Dio();
    dio.options.baseUrl = '${apiIp}';
    dio.options.headers={'accessToken': 'true'};
    //dio.options.headers = {'Content-Type': 'application/json'};

    final storage =
    ref.watch(secureStorageProvider); //ref를 사용해서 또다른 provider 가져오기

    dio.interceptors.add(CustomInterceptor(
        storage: storage, ref: ref));
  }


  Future<Response> get(String path, {Map<String,dynamic>? queryParam}) async {
    //required Map<String, dynamic> header
    try {
        return await dio.get(path, queryParameters: queryParam); //headers: header
    //headers: header
    } on DioException catch (e) {
      ref.watch(dialogProvider.notifier).errorAlert(e);
      rethrow;
    }
  }


  Future<Response> post(String path, {required Map<String, dynamic> data}) async {
    //required Map<String, dynamic> header
    try {
      return await dio.post(path, data: data); //headers: header
    } on DioException catch (e) {
      ref.watch(dialogProvider.notifier).errorAlert(e);
      rethrow;
    }
  }

  Future<Response> patch(String path, {required Map<String, dynamic> data}) async {
    //required Map<String, dynamic> header
    try {
      return await dio.patch(path, data: data); //headers: header
    } on DioException catch (e) {
      ref.watch(dialogProvider.notifier).errorAlert(e);
      rethrow;
    }
  }

  Future<Response> delete(String pathData) async {
    //required Map<String, dynamic> header
    try {
      return await dio.delete(pathData); //headers: header
    } on DioException catch (e) {
      ref.watch(dialogProvider.notifier).errorAlert(e);
      rethrow;
    }
  }
}
