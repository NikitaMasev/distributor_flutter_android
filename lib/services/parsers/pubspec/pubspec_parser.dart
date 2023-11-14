import 'dart:io';

import 'package:distributor_flutter_android/services/parsers/parcelable.dart';
import 'package:distributor_flutter_android/services/parsers/pubspec/pubspec_data.dart';

const _version = 'version';

class PubSpecParser implements Parcelable<PubSpecData> {
  PubSpecParser({required final String pathFile}) : _pathFile = pathFile;

  final String _pathFile;

  @override
  Future<PubSpecData> parse() async {
    final filePubSpec = File(_pathFile);

    if (!filePubSpec.existsSync()) {
      throw Exception('Pubspec file not found.');
    }

    final lines = await filePubSpec.readAsLines();

    if (lines.isEmpty) {
      throw Exception('Pubspec file is empty.');
    }

    for (final line in lines) {
      if (line.contains(_version)) {
        final versionPub = line.split(':').last.trim();
        final versionBuildApp = versionPub.split('+');
        final versionApp = versionBuildApp.first;
        final buildApp = versionBuildApp.last;
        final buildAppInt = int.tryParse(buildApp);

        if (buildAppInt == null) {
          throw Exception('Could not parse build version');
        }

        return PubSpecData(version: versionApp, build: buildAppInt);
      }
    }
    return PubSpecData.empty();
  }
}
