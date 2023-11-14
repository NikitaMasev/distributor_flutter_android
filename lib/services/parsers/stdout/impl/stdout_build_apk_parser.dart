import 'package:distributor_flutter_android/services/parsers/parcelable_string.dart';
import 'package:distributor_flutter_android/services/parsers/stdout/impl/stdout_common_utils.dart';
import 'package:distributor_flutter_android/services/parsers/stdout/impl/stop_phrases.dart';
import 'package:distributor_flutter_android/services/parsers/stdout/models/build_universal_apk.dart';
import 'package:distributor_flutter_android/services/parsers/stdout_parser/stdout_parser.dart';

class StdoutBuildApkParser implements ParcelableString<BuildUniversalApk> {
  StdoutBuildApkParser({required final StdoutParser stdoutParser})
      : _stdoutParser = stdoutParser;

  final StdoutParser _stdoutParser;

  @override
  Future<BuildUniversalApk> parseString(final String data) async {
    if (await _stdoutParser.emptyOutput(data)) {
      throw Exception(
          '$runtimeType: Input string is empty when parsing BuildUniversalApk.');
    }
    final lines = await _stdoutParser.parseByLines(data);

    for (final line in lines) {
      if (line.contains(built)) {
        final pathApk = parseBuildPath(line);
        print('pathApk $pathApk');
        return BuildUniversalApk(path: pathApk);
      }
    }

    throw Exception('$runtimeType: Could not get path apk file.');
  }
}
