import 'dart:io';

import 'package:distributor_flutter_android/services/parsers/parcelable_string.dart';
import 'package:distributor_flutter_android/services/parsers/stdout/models/build_abi_apk.dart';
import 'package:distributor_flutter_android/services/parsers/stdout/models/build_universal_apk.dart';
import 'package:distributor_flutter_android/services/sources_code_builder/flutter_android_builder.dart';
import 'package:distributor_flutter_android/services/sources_code_builder/sdk_info.dart';

class FlutterAndroidBuilderImpl implements FlutterAndroidBuilder {
  FlutterAndroidBuilderImpl({
    required final String workingDir,
    required final ParcelableString<SdkInfo> parserSdk,
    required final ParcelableString<BuildUniversalApk> parserBuildUniversal,
    required final ParcelableString<BuildAbiApk> parserBuildAbi,
  })  : _parserBuildAbi = parserBuildAbi,
        _parserBuildUniversal = parserBuildUniversal,
        _parserSdk = parserSdk,
        _workingDir = workingDir;

  final String _workingDir;
  final ParcelableString<SdkInfo> _parserSdk;
  final ParcelableString<BuildUniversalApk> _parserBuildUniversal;
  final ParcelableString<BuildAbiApk> _parserBuildAbi;

  @override
  Future<BuildAbiApk> buildReleaseAbiApk() async {
    final flutterBuildResult = await Process.run(
      'flutter',
      [
        'build',
        'apk',
        '--release',
        '--split-per-abi',
        '--dart-define-from-file=prod_keys.json',
      ],
      runInShell: true,
      workingDirectory: _workingDir,
    );

    _checkAndThrowException(flutterBuildResult);

    final buildAbiApkLocalPath = await _parserBuildAbi.parseString(
      flutterBuildResult.stdout.toString().trim(),
    );

    return BuildAbiApk(
      pathX86X64: '$_workingDir${buildAbiApkLocalPath.pathX86X64}',
      pathArm64V8a: '$_workingDir${buildAbiApkLocalPath.pathArm64V8a}',
      pathArmV7a: '$_workingDir${buildAbiApkLocalPath.pathArmV7a}',
    );
  }

  @override
  Future<BuildUniversalApk> buildReleaseApk() async {
    final flutterBuildResult = await Process.run(
      'flutter',
      ['build', 'apk', '--release'],
      runInShell: true,
      workingDirectory: _workingDir,
    );

    _checkAndThrowException(flutterBuildResult);

    final buildUniversalApkLocalPath = await _parserBuildUniversal.parseString(
      flutterBuildResult.stdout.toString().trim(),
    );

    return BuildUniversalApk(
      path: '$_workingDir${buildUniversalApkLocalPath.path}',
    );
  }

  @override
  Future<SdkInfo> getSdkInfo() async {
    final flutterVersionResult = await Process.run(
      'flutter',
      ['--version'],
      runInShell: true,
      workingDirectory: _workingDir,
    );

    _checkAndThrowException(flutterVersionResult);
    return _parserSdk
        .parseString(flutterVersionResult.stdout.toString().trim());
  }

  void _checkAndThrowException(final ProcessResult result) {
    if (result.exitCode != 0) {
      throw Exception('$runtimeType:${result.stdout}');
    }
  }
}
