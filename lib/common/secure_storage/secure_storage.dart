import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) => FlutterSecureStorage()); //하나의 반환된 값을 이 프로젝트에서 계속 사용 가능.