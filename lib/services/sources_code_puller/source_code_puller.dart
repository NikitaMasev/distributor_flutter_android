import 'dart:io';

import 'package:distributor_flutter_android/internal/executable.dart';
import 'package:distributor_flutter_android/services/git_wrapper/git_wrapper.dart';
import 'package:distributor_flutter_android/services/sources_code_puller/pull_status.dart';

class SourceCodePuller implements Executable<PullStatus> {
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
  Future<PullStatus> execute() async {
    if (Directory(_localDirForSourceCode).existsSync()) {
      final needUpdate = await _gitWrapper.fetch(
        _localDirForSourceCode,
        _urlSourceCode,
      );
      if (needUpdate) {
        final pullSuccess = await _gitWrapper.pull(
          _localDirForSourceCode,
          _urlSourceCode,
        );
        return pullSuccess ? PullStatus.updated : PullStatus.error;
      }
    } else {
      final cloneSuccess = await _gitWrapper.clone(
        _localDirForSourceCode,
        _urlSourceCode,
      );
      return cloneSuccess ? PullStatus.downloaded : PullStatus.error;
    }
    return PullStatus.noNeedUpdate;
  }
}
