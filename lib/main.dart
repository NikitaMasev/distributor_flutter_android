import 'dart:async';
import 'dart:io';

import 'package:crypto_wrapper/crypto_wrapper.dart';
import 'package:distributor_flutter_android/core/app_upgrador_core.dart';
import 'package:distributor_flutter_android/di/static_dependencies.dart';
import 'package:distributor_flutter_android/services/git_wrapper/git_wrapper_impl.dart';
import 'package:distributor_flutter_android/services/parsers/pubspec/pubspec_parser.dart';
import 'package:distributor_flutter_android/services/parsers/stdout/impl/stdout_build_abi_apk_parser.dart';
import 'package:distributor_flutter_android/services/parsers/stdout/impl/stdout_build_apk_parser.dart';
import 'package:distributor_flutter_android/services/parsers/stdout/impl/stdout_sdk_version_parser.dart';
import 'package:distributor_flutter_android/services/parsers/stdout_parser/stdout_parser_impl.dart';
import 'package:distributor_flutter_android/services/sources_code_builder/flutter_android_builder_impl.dart';
import 'package:distributor_flutter_android/services/sources_code_puller/source_code_puller.dart';

Future<void> main() async {
  final fullPathToSrcCode = _getWorkingDir(
    localDirForSrcCode,
    urlSourceCode.split('/').last,
  );

  const stdoutParser = StdoutParserImpl();
  final gitWrapper = GitWrapperImpl(
    stdoutParser: stdoutParser,
    logStd: true,
  );

  final sourceCodePuller = SourceCodePuller(
    localDirForSaving: localDirForSrcCode,
    urlSourceCode: urlSourceCode,
    gitWrapper: gitWrapper,
    localBranch: branchLocalSrcCode,
    remoteBranch: branchRemoteSrcCode,
  );

  final parserSdk = StdoutSdkVersionParser(stdoutParser: stdoutParser);
  final parserBuildUniversal = StdoutBuildApkParser(stdoutParser: stdoutParser);
  final parserBuildAbi = StdoutBuildAbiApkParser(stdoutParser: stdoutParser);
  final pubSpecParser = PubSpecParser(
    pathFile: '${fullPathToSrcCode}pubspec.yaml',
  );

  final flutterAndroidBuilder = FlutterAndroidBuilderImpl(
    workingDir: fullPathToSrcCode,
    parserSdk: parserSdk,
    parserBuildUniversal: parserBuildUniversal,
    parserBuildAbi: parserBuildAbi,
  );

  final server = await HttpServer.bind(InternetAddress.anyIPv4.address, port);
  final crypto = CryptoImpl(key: key, iv: iv);

  final appUpgradorCore = AppUpgradorCore(
    server: server,
    codePuller: sourceCodePuller,
    flutterAndroidBuilder: flutterAndroidBuilder,
    pubSpecParser: pubSpecParser,
    periodCodePulling: Duration(minutes: periodCheckRepoSrcCode),
    awaitingBeforeFirstBuild: Duration(minutes: awaitingBeforeBuildSrcCode),
    crypto: crypto,
  );

  await runZonedGuarded(
    () async => appUpgradorCore.execute(),
    (final error, final stack) => print('$error\n$stack'),
  );
}

String _getWorkingDir(
  final String localGitDirName,
  final String projectDirName,
) =>
    '${Directory.current.path}/$localGitDirName/$projectDirName/';
