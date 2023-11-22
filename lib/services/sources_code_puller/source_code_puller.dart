import 'dart:io';

import 'package:distributor_flutter_android/services/git_wrapper/git_wrapper.dart';
import 'package:distributor_flutter_android/services/sources_code_puller/pull_status.dart';
import 'package:launchable_interfaces/launchable_interfaces.dart';

class SourceCodePuller implements Executable<PullStatus> {
  SourceCodePuller({
    required final String localDirForSaving,
    required final String urlSourceCode,
    required final String localBranch,
    required final String remoteBranch,
    required final GitWrapper gitWrapper,
  })  : _gitWrapper = gitWrapper,
        _urlSourceCode = urlSourceCode,
        _localBranch = localBranch,
        _remoteBranch = remoteBranch,
        _localDirForSaving = localDirForSaving;

  final String _localDirForSaving;
  final String _urlSourceCode;
  final String _localBranch;
  final String _remoteBranch;
  final GitWrapper _gitWrapper;

  @override
  Future<PullStatus> execute() async {
    if (Directory(_localDirForSaving).existsSync()) {
      final gitProjectDir =
          '$_localDirForSaving/${_urlSourceCode.split('/').last}';

      final fetchSuccess = await _gitWrapper.fetch(
        gitProjectDir,
        _localBranch,
        _remoteBranch,
      );

      if (!fetchSuccess) {
        return PullStatus.error;
      }

      final changesExists = await _gitWrapper.pull(
        gitProjectDir,
        _localBranch,
        _remoteBranch,
      );
      return changesExists ? PullStatus.updated : PullStatus.noNeedUpdate;
    } else {
      final cloneSuccess = await _gitWrapper.clone(
        _localDirForSaving,
        _urlSourceCode,
      );
      return cloneSuccess ? PullStatus.downloaded : PullStatus.error;
    }
  }
}
