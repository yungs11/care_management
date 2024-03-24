import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:riverpod_annotation/riverpod_annotation.dart';part 'code_generation_provider.g.dart';

@riverpod
String gState(GStateRef ref){
  return 'Hello';
}


@Riverpod(
  keepAlive: true,
)
Future<int> gStateFuture2(GStateFuture2Ref ref)async{
  await Future.delayed(Duration(seconds: 3));

  return 10;
}

@riverpod
class GStateNotifier extends _$GStateNotifier{

  @override
  int build(){
    return 0;
  }

  increament(){
    state ++;
  }

  decrement(){
    state --;
  }
}