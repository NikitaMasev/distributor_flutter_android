import 'package:distributor_flutter_android/services/parsers/git_info/git_info_parser.dart';

class GitInfoParserImpl implements GitInfoParser {
  const GitInfoParserImpl();

  @override
  Future<bool> emptyOutput(final String stdout) async => stdout.trim().isEmpty;

  @override
  Future<List<String>> parseByLines(final String stdout) async {
    final lines = stdout.trim().split('\n');
    return lines;
  }
}
