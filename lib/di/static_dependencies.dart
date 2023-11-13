import 'dart:io';

final _keyIot = Platform.environment['KEY_IOT'] ?? '0123456789561011';
final _ivIot = Platform.environment['IV_IOT'] ?? '0000000000000000';
final _keyClients = Platform.environment['KEY_CLIENTS'] ?? '0123456789561011';
final _ivClients = Platform.environment['IV_CLIENTS'] ?? '0123456789561011';
final port = int.parse(Platform.environment['PORT'] ?? '4500');
final urlSourceCode = Platform.environment['URL_SRC_CODE'] ??
    'https://github.com/NikitaMasev/home_monitor_app';
final branchRemoteSrcCode = Platform.environment['BRANCH_REM_SRC_CODE'] ??
    'main';
final branchLocalSrcCode = Platform.environment['BRANCH_LOC_SRC_CODE'] ??
    'origin';
final localDirForSourceCode =
    Platform.environment['LOC_DIR_SRC_CODE'] ?? 'home_monitor';
