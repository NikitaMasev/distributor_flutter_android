import 'dart:io';

import 'package:distributor_flutter_android/services/git_wrapper/git_wrapper.dart';
import 'package:distributor_flutter_android/services/parsers/stdout/impl/stop_phrases.dart';
import 'package:distributor_flutter_android/services/parsers/stdout_parser/stdout_parser.dart';

class GitWrapperImpl implements GitWrapper {
  GitWrapperImpl({
    required final StdoutParser stdoutParser,
    this.logStd = false,
  }) : _stdoutParser = stdoutParser;

  final StdoutParser _stdoutParser;
  final bool logStd;

  void _printStd(final ProcessResult result) {
    if (logStd) {
      print('stderr\n ${result.stderr}');
      print('stdout\n ${result.stdout}');
    }
  }

  @override
  Future<bool> checkout(final String dirGit, final String branch) async {
    final result = await Process.run(
      'git',
      ['checkout', '-b', branch],
      workingDirectory: dirGit,
    );
    _printStd(result);
    return result.exitCode == 0;
  }

  @override
  Future<bool> clone(final String dirSaving, final String urlRepo) async {
    final dir = Directory(dirSaving);
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    final result = await Process.run(
      'git',
      ['clone', urlRepo],
      workingDirectory: dirSaving,
      runInShell: true,
    );

    _printStd(result);
    return result.exitCode == 0;
  }

  @override
  Future<bool> fetch(
    final String dirRepo,
    final String localBranch,
    final String remoteBranch,
  ) async {
    final result = await Process.run(
      'git',
      ['fetch', localBranch, remoteBranch],
      workingDirectory: dirRepo,
      runInShell: true,
    );

    _printStd(result);
    return result.exitCode == 0;
  }

  @override
  Future<bool> isGitRepo(final String dirCheck) {
    // TODO: implement isGitRepo
    throw UnimplementedError();
  }

  @override
  Future<List<String>> lastCommit() {
    // TODO: implement lastCommit
    throw UnimplementedError();
  }

  @override
  Future<bool> lastCommitContains(final String sign) {
    // TODO: implement lastCommitContains
    throw UnimplementedError();
  }

  @override
  Future<bool> pull(
    final String dirRepo,
    final String localBranch,
    final String remoteBranch,
  ) async {
    final result = await Process.run(
      'git',
      ['pull', localBranch, remoteBranch],
      workingDirectory: dirRepo,
      runInShell: true,
    );
    _printStd(result);
    return !result.stdout.toString().contains(gitAlreadyUpdated);
  }

  @override
  Future<List<String>> tags(final String dirRepo) {
    // TODO: implement tags
    throw UnimplementedError();
  }
}
