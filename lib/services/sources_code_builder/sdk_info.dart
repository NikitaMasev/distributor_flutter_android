class SdkInfo {
  SdkInfo({required this.flutterVersion, required this.dartVersion});

  final String flutterVersion;
  final String dartVersion;

  @override
  String toString() {
    return 'SdkInfo{flutterVersion: $flutterVersion, dartVersion: $dartVersion}';
  }
}
