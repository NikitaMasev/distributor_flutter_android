import 'package:distributor_flutter_android/services/parsers/parcelable_string.dart';
import 'package:distributor_flutter_android/services/parsers/stdout/impl/stop_phrases.dart';
import 'package:distributor_flutter_android/services/parsers/stdout_parser/stdout_parser.dart';
import 'package:distributor_flutter_android/services/sources_code_builder/sdk_info.dart';

class StdoutSdkVersionParser implements ParcelableString<SdkInfo> {
  StdoutSdkVersionParser({required final StdoutParser stdoutParser})
      : _stdoutParser = stdoutParser;

  final StdoutParser _stdoutParser;

  @override
  Future<SdkInfo> parseString(final String data) async {
    if (await _stdoutParser.emptyOutput(data)) {
      throw Exception(
          '$runtimeType: Input string is empty when parsing SdkInfo.');
    }

    final lines = await _stdoutParser.parseByLines(data);
    var flutterVersion = '';
    var dartVersion = '';

    for (final line in lines) {
      if (line.contains(flutter)) {
        final deletedFirstPhrases = line.replaceFirst(flutter, '').trim();
        final indexEnd = deletedFirstPhrases.indexOf(' ');
        flutterVersion = deletedFirstPhrases.substring(0, indexEnd);
      } else if (line.contains(dart)) {
        final deletedFirstPhrases = line.split(dart).last.trim();
        final indexEnd = deletedFirstPhrases.indexOf(' ');
        dartVersion = deletedFirstPhrases.substring(0, indexEnd);
      }

      if (flutterVersion.isNotEmpty && dartVersion.isNotEmpty) {
        return SdkInfo(
          flutterVersion: flutterVersion,
          dartVersion: dartVersion,
        );
      }
    }

    throw Exception('$runtimeType: Could not get sdk info.');
  }
}
