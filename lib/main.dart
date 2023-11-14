import 'dart:io';

import 'package:distributor_flutter_android/di/static_dependencies.dart';
import 'package:distributor_flutter_android/services/git_wrapper/git_wrapper_impl.dart';
import 'package:distributor_flutter_android/services/parsers/stdout/impl/stdout_build_abi_apk_parser.dart';
import 'package:distributor_flutter_android/services/parsers/stdout/impl/stdout_build_apk_parser.dart';
import 'package:distributor_flutter_android/services/parsers/stdout/impl/stdout_sdk_version_parser.dart';
import 'package:distributor_flutter_android/services/parsers/stdout_parser/stdout_parser_impl.dart';
import 'package:distributor_flutter_android/services/sources_code_builder/flutter_android_builder_impl.dart';

Future<void> main() async {
  const stdoutParser = StdoutParserImpl();
  final gitWrapper = GitWrapperImpl(
    stdoutParser: stdoutParser,
  );

  if (Directory(localDirForSourceCode).existsSync()) {
    final needUpdate = await gitWrapper.fetch(
      localDirForSourceCode,
      urlSourceCode,
    );
    if (needUpdate) {
      await gitWrapper.pull(localDirForSourceCode, urlSourceCode);
    }
  } else {
    await gitWrapper.clone(localDirForSourceCode, urlSourceCode);
  }

  final parserSdk = StdoutSdkVersionParser(stdoutParser: stdoutParser);
  final parserBuildUniversal = StdoutBuildApkParser(stdoutParser: stdoutParser);
  final parserBuildAbi = StdoutBuildAbiApkParser(stdoutParser: stdoutParser);

  final flutterAndroidBuilder = FlutterAndroidBuilderImpl(
    workingDir: _getWorkingDir(localDirForSourceCode, urlSourceCode.split('/').last),
    parserSdk: parserSdk,
    parserBuildUniversal: parserBuildUniversal,
    parserBuildAbi: parserBuildAbi,
  );

  final sdkInfo = await flutterAndroidBuilder.getSdkInfo();
  print(sdkInfo);
  final buildAbiApk = await flutterAndroidBuilder.buildReleaseAbiApk();
  print(buildAbiApk);
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
