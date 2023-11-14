abstract interface class StdoutParser {
  Future<bool> emptyOutput(final String stdout);

  Future<List<String>> parseByLines(final String stdout);
}
