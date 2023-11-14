import 'dart:io';

import 'package:distributor_flutter_android/services/parsers/parcelable_string.dart';
import 'package:distributor_flutter_android/services/parsers/stdout/models/build_abi_apk.dart';
import 'package:distributor_flutter_android/services/parsers/stdout/models/build_universal_apk.dart';
import 'package:distributor_flutter_android/services/sources_code_builder/flutter_android_builder.dart';
import 'package:distributor_flutter_android/services/sources_code_builder/sdk_info.dart';

class FlutterAndroidBuilderImpl implements FlutterAndroidBuilder {
  FlutterAndroidBuilderImpl({
    required this.workingDir,
    required this.parserSdk,
    required this.parserBuildUniversal,
    required this.parserBuildAbi,
  });

  final String workingDir;
  final ParcelableString<SdkInfo> parserSdk;
  final ParcelableString<BuildUniversalApk> parserBuildUniversal;
  final ParcelableString<BuildAbiApk> parserBuildAbi;

  @override
  Future<BuildAbiApk> buildReleaseAbiApk() async {
    final flutterBuildResult = await Process.run(
      'flutter',
      ['build', 'apk', '--release', '--split-per-abi'],
      runInShell: true,
      workingDirectory: workingDir,
    );

    _checkAndThrowException(flutterBuildResult);

    return parserBuildAbi.parseString(
      flutterBuildResult.stdout.toString().trim(),
    );
  }

  @override
  Future<BuildUniversalApk> buildReleaseApk() async {
    final flutterBuildResult = await Process.run(
      'flutter',
      ['build', 'apk', '--release'],
      runInShell: true,
      workingDirectory: workingDir,
    );

    _checkAndThrowException(flutterBuildResult);

    return parserBuildUniversal.parseString(
      flutterBuildResult.stdout.toString().trim(),
    );
  }

  @override
  Future<SdkInfo> getSdkInfo() async {
    final flutterVersionResult = await Process.run(
      'flutter',
      ['--version'],
      runInShell: true,
      workingDirectory: workingDir,
    );

    _checkAndThrowException(flutterVersionResult);
    return parserSdk.parseString(flutterVersionResult.stdout.toString().trim());
  }

  void _checkAndThrowException(final ProcessResult result) {
    if (result.exitCode != 0) {
      throw Exception('$runtimeType:${result.stdout}');
    }
  }
}
