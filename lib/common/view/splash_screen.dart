import 'package:care_management/common/const/data.dart';
import 'package:care_management/common/dio/dio.dart';
import 'package:care_management/common/layout/main_layout.dart';
import 'package:care_management/common/secure_storage/secure_storage.dart';
import 'package:care_management/screen/auth/id_input_screen.dart';
import 'package:care_management/screen/user_main_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final storageProvier = ref.read(secureStorageProvider);
    final dio = ref.read(dioProvider);

    void checkToken() async {
      final refreshToken = await storageProvier.read(key: REFRESH_TOKEN_KEY);
      final accessToken = await storageProvier.read(key: ACCESS_TOKEN_KEY);

      try {
        final resp = await dio.get('${apiIp}/user/me',
            options: Options(headers: {
              'authorization': 'Bearer $refreshToken',
            }));

        print(resp);



        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => MainLayout(
                appBartitle: '',
                body: UserMainScreen(),
                addPadding: false,
              ),
            ),
                (route) => false);
      } catch (e) {
        print(e);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => IdInputScreen()),
            (route) => false);
      }
    }

    void deleteToken() async {
      await storageProvier.deleteAll();
    }

    checkToken();

    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width, //width가 최대사이즈여야 가운데정렬이됨.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('환영합니다'),
            CircularProgressIndicator(
                //color: ,
                )
          ],
        ),
      ),
    );
  }
}
