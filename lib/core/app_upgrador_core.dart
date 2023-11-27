import 'dart:async';
import 'dart:io';

import 'package:crypto_wrapper/crypto_wrapper.dart';
import 'package:dfa_common/dfa_common.dart';
import 'package:distributor_flutter_android/services/parsers/parcelable.dart';
import 'package:distributor_flutter_android/services/parsers/pubspec/pubspec_data.dart';
import 'package:distributor_flutter_android/services/parsers/stdout/impl/stop_phrases.dart';
import 'package:distributor_flutter_android/services/parsers/stdout/models/build_abi_apk.dart';
import 'package:distributor_flutter_android/services/sources_code_builder/flutter_android_builder.dart';
import 'package:distributor_flutter_android/services/sources_code_puller/pull_status.dart';
import 'package:launchable_interfaces/launchable_interfaces.dart';

class AppUpgradorCore implements Executable<void> {
  AppUpgradorCore({
    required final HttpServer server,
    required final Executable<PullStatus> codePuller,
    required final FlutterAndroidBuilder flutterAndroidBuilder,
    required final Parcelable<PubSpecData> pubSpecParser,
    required final Crypto crypto,
    required final Duration periodCodePulling,
    required final Duration awaitingBeforeFirstBuild,
  })  : _periodCodePulling = periodCodePulling,
        _awaitingBeforeFirstBuild = awaitingBeforeFirstBuild,
        _flutterAndroidBuilder = flutterAndroidBuilder,
        _pubSpecParser = pubSpecParser,
        _codePuller = codePuller,
        _crypto = crypto,
        _server = server;

  final HttpServer _server;
  final Executable<PullStatus> _codePuller;
  final Parcelable<PubSpecData> _pubSpecParser;
  final FlutterAndroidBuilder _flutterAndroidBuilder;
  final Crypto _crypto;
  final Duration _periodCodePulling;
  final Duration _awaitingBeforeFirstBuild;

  late BuildAbiApk _buildAbiApk;
  Timer? _timerPullingCode;

  @override
  Future<void> execute() async {
    final pullStatus = await _codePuller.execute();
    print('$runtimeType: Code puller $pullStatus');
    if (pullStatus == PullStatus.error) {
      return;
    }

    print('$runtimeType: Awaiting build');
    await Future.delayed(_awaitingBeforeFirstBuild);
    print('$runtimeType: Start build');

    _buildAbiApk = await _flutterAndroidBuilder.buildReleaseAbiApk();
    print('$runtimeType: Builded $_buildAbiApk');
    _runTimerPullingCode();

    _server.listen((final request) {
      print(request.headers);

      switch (request.method) {
        case 'GET':
          final paths = request.requestedUri.pathSegments;
          switch (paths.first) {
            case RequestUpgradePaths.checkUpgrade:
              _needUpgrade(request);
              break;
            case RequestUpgradePaths.upgrade:
              _upgrade(request);
              break;
            default:
              _responseMethodNotAllowed(request);
          }
          break;
        default:
          _responseMethodNotAllowed(request);
      }
    });
  }

  void _runTimerPullingCode() {
    _timerPullingCode?.cancel();
    _timerPullingCode = Timer.periodic(_periodCodePulling, (final _) async {
      final pullStatus = await _codePuller.execute();

      print('$runtimeType: Timer $pullStatus');

      if (pullStatus == PullStatus.updated) {
        _buildAbiApk = await _flutterAndroidBuilder.buildReleaseAbiApk();
        print('$runtimeType: Builded $_buildAbiApk');
      }
    });
  }

  Future<void> _upgrade(final HttpRequest request) async {
    final abiClient = request.headers.value(RequestUpgradeHeaders.abi);

    if (abiClient == null) {
      await _responseNoHeader(request);
      return;
    }

    var decryptedAbi = '';

    try {
      decryptedAbi = _crypto.decrypt(abiClient);
    } on Exception {
      await _invalidDecrypting(request);
      rethrow;
    }
    print('decryptedAbi $decryptedAbi');
    late final String pathApkFile;

    switch (decryptedAbi) {
      case arm64V8a:
        pathApkFile = _buildAbiApk.pathArm64V8a;
      case armV7a:
        pathApkFile = _buildAbiApk.pathArmV7a;
        break;
      case x86X64:
        pathApkFile = _buildAbiApk.pathX86X64;
        break;
      default:
        request.response
          ..statusCode = HttpStatus.badRequest
          ..write('Your abi does not supported.');
        await request.response.close();
        return;
    }

    final fileApk = File(pathApkFile);

    if (!fileApk.existsSync()) {
      request.response
        ..statusCode = HttpStatus.badRequest
        ..write('Apk file does not exist.');
      await request.response.close();
      return;
    }

    await fileApk
        .openRead()
        .pipe(request.response..contentLength = fileApk.lengthSync());
  }

  Future<void> _needUpgrade(final HttpRequest request) async {
    final buildVersionClient = request.headers.value(
      RequestUpgradeHeaders.buildVersion,
    );

    if (buildVersionClient == null) {
      await _responseNoHeader(request);
      return;
    }

    var decryptedBuildVersion = '';

    try {
      decryptedBuildVersion = _crypto.decrypt(buildVersionClient);
    } on Exception {
      await _invalidDecrypting(request);
      rethrow;
    }
    print('decryptedBuildVersion $decryptedBuildVersion');
    final buildIntClient = int.tryParse(decryptedBuildVersion);

    if (buildIntClient == null) {
      await _responseNoHeader(request);
      return;
    }

    final pubSpecData = await _pubSpecParser.parse();

    request.response
      ..statusCode = HttpStatus.ok
      ..write(pubSpecData.build > buildIntClient);
    await request.response.close();
  }

  Future<void> _responseNoHeader(final HttpRequest request) async {
    request.response
      ..statusCode = HttpStatus.badRequest
      ..write('Not founded header.');
    await request.response.close();
  }

  Future<void> _responseMethodNotAllowed(final HttpRequest request) async {
    request.response.statusCode = HttpStatus.methodNotAllowed;
    await request.response.close();
  }

  Future<void> _invalidDecrypting(final HttpRequest request) async {
    request.response
      ..statusCode = HttpStatus.badRequest
      ..write('Invalid decrypting headers.');
    await request.response.close();
  }
}
