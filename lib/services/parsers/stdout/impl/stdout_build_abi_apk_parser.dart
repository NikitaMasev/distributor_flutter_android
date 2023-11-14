import 'package:distributor_flutter_android/services/parsers/parcelable_string.dart';
import 'package:distributor_flutter_android/services/parsers/stdout/impl/stdout_common_utils.dart';
import 'package:distributor_flutter_android/services/parsers/stdout/impl/stop_phrases.dart';
import 'package:distributor_flutter_android/services/parsers/stdout/models/build_abi_apk.dart';
import 'package:distributor_flutter_android/services/parsers/stdout_parser/stdout_parser.dart';

class StdoutBuildAbiApkParser implements ParcelableString<BuildAbiApk> {
  StdoutBuildAbiApkParser({required final StdoutParser stdoutParser})
      : _stdoutParser = stdoutParser;

  final StdoutParser _stdoutParser;

  @override
  Future<BuildAbiApk> parseString(final String data) async {
    if (await _stdoutParser.emptyOutput(data)) {
      throw Exception(
          '$runtimeType: Input string is empty when parsing BuildAbiApk.');
    }
    final lines = await _stdoutParser.parseByLines(data);
    var pathV7a = '';
    var pathV8a = '';
    var pathX86X64 = '';

    for (final line in lines) {
      if (line.contains(built)) {
        if (line.contains(armV7a)) {
          pathV7a = parseBuildPath(line);
        } else if (line.contains(arm64V8a)) {
          pathV8a = parseBuildPath(line);
        } else if (line.contains(x86X64)) {
          pathX86X64 = parseBuildPath(line);
        }

        if (pathV7a.isNotEmpty && pathV8a.isNotEmpty && pathX86X64.isNotEmpty) {
          return BuildAbiApk(
            pathX86X64: pathX86X64,
            pathArm64V8a: pathV8a,
            pathArmV7a: pathV7a,
          );
        }
      }
    }

    throw Exception('$runtimeType: Could not get all path apk files.');
  }
}
