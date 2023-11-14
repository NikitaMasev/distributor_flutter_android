import 'package:distributor_flutter_android/services/parsers/stdout_parser/stdout_parser.dart';

class StdoutParserImpl implements StdoutParser {
  const StdoutParserImpl();

  @override
  Future<bool> emptyOutput(final String stdout) async => stdout.trim().isEmpty;

  @override
  Future<List<String>> parseByLines(final String stdout) async {
    final lines = stdout.trim().split('\n');
    return lines;
  }
}
