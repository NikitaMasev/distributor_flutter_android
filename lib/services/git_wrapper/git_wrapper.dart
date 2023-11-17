abstract interface class GitWrapper {
  Future<bool> isGitRepo(final String dirCheck);

  Future<bool> clone(final String dirSaving, final String urlRepo);

  Future<bool> checkout(final String dirGit, final String branch);

  Future<bool> fetch(
    final String dirRepo,
    final String localBranch,
    final String remoteBranch,
  );

  ///return true if changes exists
  Future<bool> pull(
    final String dirRepo,
    final String localBranch,
    final String remoteBranch,
  );

  Future<List<String>> lastCommit();

  Future<bool> lastCommitContains(final String sign);

  Future<List<String>> tags(final String dirRepo);
}
