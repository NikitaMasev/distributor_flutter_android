class BuildAbiApk {
  BuildAbiApk({
    required this.pathX86X64,
    required this.pathArm64V8a,
    required this.pathArmV7a,
  });

  final String pathX86X64;
  final String pathArm64V8a;
  final String pathArmV7a;

  @override
  String toString() {
    return 'BuildAbiApk{pathX86X64: $pathX86X64, pathArm64V8a: $pathArm64V8a, pathArmV7a: $pathArmV7a}';
  }
}
