import 'dart:io';

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
  final workingDirSourceCode = _getWorkingDir(
    localDirForSourceCode,
    urlSourceCode.split('/').last,
  );

  const stdoutParser = StdoutParserImpl();
  final gitWrapper = GitWrapperImpl(
    stdoutParser: stdoutParser,
  );

  final sourceCodePuller = SourceCodePuller(
    localDirForSourceCode: localDirForSourceCode,
    urlSourceCode: urlSourceCode,
    gitWrapper: gitWrapper,
  );

  final parserSdk = StdoutSdkVersionParser(stdoutParser: stdoutParser);
  final parserBuildUniversal = StdoutBuildApkParser(stdoutParser: stdoutParser);
  final parserBuildAbi = StdoutBuildAbiApkParser(stdoutParser: stdoutParser);
  final pubSpecParser = PubSpecParser(
    pathFile: '${workingDirSourceCode}pubspec.yaml',
  );

  final flutterAndroidBuilder = FlutterAndroidBuilderImpl(
    workingDir: workingDirSourceCode,
    parserSdk: parserSdk,
    parserBuildUniversal: parserBuildUniversal,
    parserBuildAbi: parserBuildAbi,
  );

  final server = await HttpServer.bind('192.168.50.143', port);

  final appUpgradorCore = AppUpgradorCore(
    server: server,
    codePuller: sourceCodePuller,
    flutterAndroidBuilder: flutterAndroidBuilder,
    pubSpecParser: pubSpecParser,
    periodCodePulling: Duration(minutes: periodUpdateSourceCodeInMinutes),
  );
  await appUpgradorCore.execute();
}

String _getWorkingDir(
  final String localGitDirName,
  final String projectDirName,
) {
  final workingDir =
      '${Directory.current.path}/$localGitDirName/$projectDirName/';
  print(workingDir);
  return workingDir;
}
