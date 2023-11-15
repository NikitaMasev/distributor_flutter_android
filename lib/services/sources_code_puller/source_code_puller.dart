import 'dart:io';

import 'package:distributor_flutter_android/internal/executable.dart';
import 'package:distributor_flutter_android/services/git_wrapper/git_wrapper.dart';

class SourceCodePuller implements Executable {
  SourceCodePuller({
    required final String localDirForSourceCode,
    required final String urlSourceCode,
    required final GitWrapper gitWrapper,
  })  : _gitWrapper = gitWrapper,
        _urlSourceCode = urlSourceCode,
        _localDirForSourceCode = localDirForSourceCode;

  final String _localDirForSourceCode;
  final String _urlSourceCode;
  final GitWrapper _gitWrapper;

  @override
  Future<bool> execute() async {
    var result = false;

    if (Directory(_localDirForSourceCode).existsSync()) {
      result = await _gitWrapper.fetch(
        _localDirForSourceCode,
        _urlSourceCode,
      );
      if (result) {
        result = await _gitWrapper.pull(_localDirForSourceCode, _urlSourceCode);
      }
    } else {
      result = await _gitWrapper.clone(_localDirForSourceCode, _urlSourceCode);
    }
    return result;
  }
}
