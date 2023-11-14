import 'package:distributor_flutter_android/services/parsers/stdout/models/build_abi_apk.dart';
import 'package:distributor_flutter_android/services/parsers/stdout/models/build_universal_apk.dart';
import 'package:distributor_flutter_android/services/sources_code_builder/sdk_info.dart';

abstract interface class FlutterAndroidBuilder {
  Future<SdkInfo> getSdkInfo();

  Future<BuildUniversalApk> buildReleaseApk();

  Future<BuildAbiApk> buildReleaseAbiApk();
}
