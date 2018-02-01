Setup

  $ cat >> $HGRCPATH << EOF
  > [extensions]
  > arcconfig=$TESTDIR/../hgext/extlib/phabricator/arcconfig.py
  > phabstatus=
  > smartlog=
  > EOF
  $ hg init repo
  $ cd repo
  $ touch foo
  $ hg ci -qAm 'Differential Revision: https://phabricator.fb.com/D1'

With an invalid arc configuration

  $ hg log -T '{syncstatus}\n' -r .
  arcconfig configuration problem. No diff information can be provided.
  Error info: no .arcconfig found
  Error

Configure arc...

  $ echo '{}' > .arcrc
  $ echo '{"config" : {"default" : "https://a.com/api"}, "hosts" : {"https://a.com/api/" : { "user" : "testuser", "cert" : "garbage_cert"}}}' > .arcconfig

And now with bad responses:

  $ cat > $TESTTMP/mockduit << EOF
  > [{"cmd": ["differential.querydiffhashes", {"revisionIDs": ["1"]}], "result": {}}]
  > EOF
  $ OVERRIDE_GRAPHQL_URI=https://a.com HG_ARC_CONDUIT_MOCK=$TESTTMP/mockduit hg log -T '{syncstatus}\n' -r .
  Error

  $ cat > $TESTTMP/mockduit << EOF
  > [{"cmd": ["differential.querydiffhashes", {"revisionIDs": ["1"]}], "error_info": "failed, yo"}]
  > EOF
  $ HG_ARC_CONDUIT_MOCK=$TESTTMP/mockduit hg log -T '{syncstatus}\n' -r .
  Error talking to phabricator. No diff information can be provided.
  Error info: failed, yo
  Error

Missing status field is treated as an error

  $ cat > $TESTTMP/mockduit << EOF
  > [{"cmd": ["differential.querydiffhashes", {"revisionIDs": ["1"]}],
  >   "result": {"1" : {"hash": "this is the best hash ewa", "count" : "3"}}}]
  > EOF
  $ HG_ARC_CONDUIT_MOCK=$TESTTMP/mockduit hg log -T '{syncstatus}\n' -r .
  Error

Missing count field is treated as an error

  $ cat > $TESTTMP/mockduit << EOF
  > [{"cmd": ["differential.querydiffhashes", {"revisionIDs": ["1"]}],
  >   "result": {"1" : {"hash": "this is the best hash ewa", "status" : "Committed"}}}]
  > EOF
  $ HG_ARC_CONDUIT_MOCK=$TESTTMP/mockduit hg log -T '{syncstatus}\n' -r .
  Error

Missing hash field is treated as an error

  $ cat > $TESTTMP/mockduit << EOF
  > [{"cmd": ["differential.querydiffhashes", {"revisionIDs": ["1"]}],
  >   "result": {"1" : {"status": "Needs Review", "count" : "3"}}}]
  > EOF
  $ HG_ARC_CONDUIT_MOCK=$TESTTMP/mockduit hg log -T '{syncstatus}\n' -r .
  Error

And finally, the success case

  $ cat > $TESTTMP/mockduit << EOF
  > [{"cmd": ["differential.querydiffhashes", {"revisionIDs": ["1"]}],
  >   "result": {"1" : {"count": 3, "status": "Committed", "hash": "lolwut"}}}]
  > EOF
  $ HG_ARC_CONDUIT_MOCK=$TESTTMP/mockduit hg log -T '{syncstatus}\n' -r .
  committed
