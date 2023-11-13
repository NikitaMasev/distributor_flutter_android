abstract interface class GitWrapper {
  Future<bool> isGitRepo(final String dirCheck);

  Future<bool> clone(final String dirSaving, final String urlRepo);

  Future<bool> checkout(final String dirGit, final String branch);

  ///return true if need update repo
  Future<bool> fetch(final String dirRepo, final String urlRepo);

  Future<bool> pull(final String dirRepo, final String urlRepo);

  Future<List<String>> lastCommit();

  Future<bool> lastCommitContains(final String sign);

  Future<List<String>> tags(final String dirRepo);
}
