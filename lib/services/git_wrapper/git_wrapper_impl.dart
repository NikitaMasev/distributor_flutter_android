import 'dart:io';

import 'package:distributor_flutter_android/services/git_wrapper/git_wrapper.dart';
import 'package:distributor_flutter_android/services/parsers/git_info/git_info_parser.dart';
import 'package:git/git.dart' as git_service;

class GitWrapperImpl implements GitWrapper {
  GitWrapperImpl({
    required final GitInfoParser gitInfoParser,
  }) : _gitInfoParser = gitInfoParser;

  final GitInfoParser _gitInfoParser;

  @override
  Future<bool> checkout(final String dirGit, final String branch) async {
    final result = await git_service.runGit(
      ['checkout', '-b', branch],
      processWorkingDir: dirGit,
    );
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
    return result.exitCode == 0;
  }

  @override
  Future<bool> fetch(final String dirRepo, final String urlRepo) async {
    final result = await git_service.runGit(
      ['fetch'],
      processWorkingDir: dirRepo,
    );
    return !(await _gitInfoParser.emptyOutput(result.stdout.toString()));
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
