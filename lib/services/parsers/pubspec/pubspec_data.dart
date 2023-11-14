class PubSpecData {
  PubSpecData({
    required this.version,
    required this.build,
  });

  final String version;
  final int build;

  factory PubSpecData.empty() => PubSpecData(version: '0', build: 0);

  bool get isValid => version != '0' && build != 0;
}
