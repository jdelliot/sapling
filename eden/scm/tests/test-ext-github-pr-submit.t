#chg-compatible
#debugruntest-compatible
#inprocess-hg-incompatible

  $ enable github
  $ export SL_TEST_GH_URL=https://github.com/facebook/test_github_repo.git
  $ . $TESTDIR/git.sh

build up a github repo

  $ sl init --git repo1
  $ cd repo1
  $ echo a > a1
  $ sl ci -Am addfile
  adding a1

confirm it is a 'github_repo'
  $ sl log -r. -T '{github_repo}\n'
  True

test sending pr
  $ sl pr submit --config extensions.pr_submit=$TESTDIR/github/mock_create_one_pr.py
  pushing 1 to https://github.com/facebook/test_github_repo.git
  created new pull request: https://github.com/facebook/test_github_repo/pull/42
  updated body for https://github.com/facebook/test_github_repo/pull/42
