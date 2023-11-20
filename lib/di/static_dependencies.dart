import 'dart:io';

final key = Platform.environment['KEY'] ?? '0';
final iv = Platform.environment['IV'] ?? '0';
final port = int.parse(Platform.environment['PORT'] ?? '4500');
final urlSourceCode = Platform.environment['URL_SRC_CODE'] ??
    'https://github.com/NikitaMasev/home_monitor_app';
final branchRemoteSrcCode =
    Platform.environment['BRANCH_REM_SRC_CODE'] ?? 'main';
final branchLocalSrcCode =
    Platform.environment['BRANCH_LOC_SRC_CODE'] ?? 'origin';
final localDirForSourceCode =
    Platform.environment['LOC_DIR_SRC_CODE'] ?? 'home_monitor';
final periodCheckRepoSrcCode = int.parse(
  Platform.environment['PERIOD_CHECK_REPO'] ?? '5',
);
final awaitingBeforeBuildSrcCode =
    int.parse(Platform.environment['AWAITING_BEFORE_BUILD_MINUTE'] ?? '10');
