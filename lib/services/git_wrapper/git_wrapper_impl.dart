import 'dart:io';

import 'package:distributor_flutter_android/services/git_wrapper/git_wrapper.dart';
import 'package:distributor_flutter_android/services/parsers/stdout_parser/stdout_parser.dart';
import 'package:git/git.dart' as git_service;

class GitWrapperImpl implements GitWrapper {
  GitWrapperImpl({
    required final StdoutParser stdoutParser,
    this.logStdout = false,
  }) : _stdoutParser = stdoutParser;

  final StdoutParser _stdoutParser;
  final bool logStdout;

  void _printStdout(final dynamic stdout) {
    if (logStdout) {
      print(stdout.toString().trim());
    }
  }

  @override
  Future<bool> checkout(final String dirGit, final String branch) async {
    final result = await git_service.runGit(
      ['checkout', '-b', branch],
      processWorkingDir: dirGit,
    );
    _printStdout(result.stdout);
    return result.exitCode == 0;
  }

  @override
  Future<bool> clone(final String dirSaving, final String urlRepo) async {
    final dir = Directory(dirSaving);
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    final result = await git_service.runGit(
      ['clone', urlRepo],
      processWorkingDir: dirSaving,
    );
    _printStdout(result.stdout);
    return result.exitCode == 0;
  }

  @override
  Future<bool> fetch(final String dirRepo, final String urlRepo) async {
    final result = await git_service.runGit(
      ['fetch'],
      processWorkingDir: dirRepo,
    );
    _printStdout(result.stdout);
    return !(await _stdoutParser.emptyOutput(result.stdout.toString()));
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
  Future<bool> pull(final String dirRepo, final String urlRepo) async {
    final result = await git_service.runGit(
      ['pull'],
      processWorkingDir: dirRepo,
    );
    return result.exitCode == 0;
  }

  @override
  Future<List<String>> tags(final String dirRepo) {
    // TODO: implement tags
    throw UnimplementedError();
  }
}
