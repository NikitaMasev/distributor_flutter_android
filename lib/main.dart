import 'dart:developer';
import 'dart:io';

import 'package:rw_git/rw_git.dart';

final gitRepoApp = 'https://github.com/NikitaMasev/home_monitor_app';
final localGitDirName = 'home_monitor';
const pubTagVersion = 'version';

Future<void> main() async {
  //final localPathGitApp = _createCheckoutDirectory(localGitDirName);

  final rwGit = RwGit();
  //await rwGit.clone(localPathGitApp, gitRepoApp);

  final filePubSpec =
  _getFilePubSpec(localGitDirName, gitRepoApp.split('/').last);
  print(filePubSpec.existsSync());

  final lines = await filePubSpec.readAsLines();

  for (final line in lines) {
    print(line);
    if (line.contains('version')) {
      final versionPub = line.split(':').last.trim();
      print(versionPub);
      final versionBuildApp = versionPub.split('+');
      final versionApp = versionBuildApp.first;
      final buildApp = versionBuildApp.last;
      final buildAppInt = int.tryParse(buildApp);
      print(versionApp);
      print(buildApp);
      print(buildAppInt);
      break;
    }
  }

  var flutterVersionResult = await Process.run(
    'flutter',
    ["--version"],
    runInShell: true,
    workingDirectory:
    _getWorkingDir(localGitDirName, gitRepoApp.split('/').last),
  );

  stdout.write(flutterVersionResult.stdout);

  var flutterBuildResult = await Process.run(
    'flutter',
    ['build', 'apk', '--release'],
    runInShell: true,
    workingDirectory:
    _getWorkingDir(localGitDirName, gitRepoApp.split('/').last),
  );
  stdout.write(flutterBuildResult.stdout);
  ///TODO CHECK build split abi

/*  filePubSpec.openRead().listen((event) {
    print(event.toString());
    print('HUI');
  });*/
  //final fileShare = File('httpUpdateNew.bin');
/*  final fileShare = File('app-arm64-v8a-release.apk');

  print(fileShare.existsSync());
  HttpServer.bind('192.168.50.143', 80).then((HttpServer server) {
    print('LISTENING ON ${server.address.host}');
    server.listen((request) {
      print(request.method);
      print(request.headers.toString());
      switch (request.method) {
        case 'GET':
          final currentBuildVersion = request.headers.value('buildversion');

          if (currentBuildVersion != null) {
            final buildInt = int.tryParse(currentBuildVersion);

            if (buildInt != null && buildInt > 3) {
              fileShare
                  .openRead()
                  .pipe(
                      request.response..contentLength = fileShare.lengthSync())
                  .catchError((e) {
                print(e.toString());
              });
            }
          }
          //_handleGet(request);
          break;

        case 'POST':
          //_handlePost(request);
          break;

        default:
          request.response.statusCode = HttpStatus.methodNotAllowed;
          request.response.close();
      }
    });
  });*/
}

String _getWorkingDir(
    final String localGitDirName,
    final String projectDirName,
    ) {
  final pathPubSpecFile =
      '${Directory.current.path}/$localGitDirName/$projectDirName/';
  print(pathPubSpecFile);
  return pathPubSpecFile;
}

File _getFilePubSpec(
    final String localGitDirName,
    final String projectDirName,
    ) {
  final pathPubSpecFile =
      '${Directory.current.path}/$localGitDirName/$projectDirName/pubspec.yaml';
  print(pathPubSpecFile);
  return File(pathPubSpecFile);
}

/// Creates the directory where the repository will be checked out,
/// If the directory already exists, it will delete it along with any content inside
/// and a new one will be created.
String _createCheckoutDirectory(String directoryName) {
  Directory checkoutDirectory = Directory(directoryName);
  if (checkoutDirectory.existsSync()) {
    try {
      checkoutDirectory.deleteSync(recursive: true);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
  checkoutDirectory.createSync();

  return "${Directory.current.path}\\$directoryName";
}
