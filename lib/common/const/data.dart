import 'dart:io';

const ACCESS_TOKEN_KEY= 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY='REFRESH_TOKEN';

//여기로 보내야 127.0.0.1로 감; 포트는 다르게.
final emulatorIp = '10.0.2.2:3000';
final simulatorIP = '127.0.0.1:3000';
//final ip = Platform.isIOS ? simulatorIP : emulatorIp;

const apiIp = 'http://192.168.217.128:8080/api/v1';