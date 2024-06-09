import 'package:care_management/common/component/custom_components.dart';
import 'package:care_management/common/component/dialog.dart';
import 'package:care_management/common/dio/dio.dart';
import 'package:care_management/common/layout/join_layout.dart';
import 'package:care_management/screen/auth/id_input_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/const/data.dart';

class RenewPasswordScreen extends ConsumerWidget {
  final userId;
  const RenewPasswordScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return JoinLayout(
      appBartitle: '',
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CustomTitle(titleText: '새로운 비밀번호를 입력해주세요 :)'),
            const SizedBox(
              height: 5.0,
            ),
            const SubTitle(
              subTitleText: '',
            ),
            const SizedBox(
              height: 53.0,
            ),
            const Column(
              children: [
                CustomTextField(
                  labelText: '',
                ),
                SizedBox(
                  height: 30.0,
                ),
                CustomTextField(
                  labelText: '',
                ),
              ],
            ),
            const SizedBox(
              height: 60.0,
            ),
            DoneButton(
              onButtonPressed: () async {
                final dio = ref.watch(dioProvider);

                try {
                  final resp = await dio.post('${apiIp}/auth/signin',
                      /*options: Options(headers: {
                        'authorization': 'Bearer $token',
                      }),*/
                      data: '');

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => IdInputScreen()),
                      (route) => false);
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
              },
              buttonText: '변경하기',
            ),
          ],
        ),
      )),
    );
  }
}
