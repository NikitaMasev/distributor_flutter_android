import 'package:distributor_flutter_android/services/parsers/stdout/impl/stop_phrases.dart';

String parseBuildPath(final String line) {
  final deletedFirstPhrases = line.split(built).last.trim();
  final indexEnd = deletedFirstPhrases.indexOf(bracket) - 1;
  final path = deletedFirstPhrases.substring(0, indexEnd).trim();
  return path;
}
