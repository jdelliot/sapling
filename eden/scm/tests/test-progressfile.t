#chg-compatible

  $ enable progress progressfile
  $ setconfig extensions.progresstest="$TESTDIR/progresstest.py"
  $ setconfig progress.delay=0 progress.changedelay=2 progress.refresh=1 progress.assume-tty=true
  $ setconfig progress.statefile="$TESTTMP/progressstate" progress.statefileappend=true
  $ setconfig progress.fakedpid=42 progress.lockstep=True progress.renderer=none

  $ withprogress() {
  >   "$@"
  >   cat $TESTTMP/progressstate
  >   rm -f $TESTTMP/progressstate
  > }

simple test
  $ withprogress hg progresstest 4 4
  {"state": {"progress test": {"active": false, "estimate_sec": null, "estimate_str": null, "item": "loop 0", "pid": 42, "pos": 0, "speed_str": null, "topic": "progress test", "total": 4, "unit": "cycles", "units_per_sec": null}}, "topics": ["progress test"]}
  {"state": {"progress test": {"active": true, "estimate_sec": 4, "estimate_str": "04s", "item": "loop 1", "pid": 42, "pos": 1, "speed_str": "1 cycles/sec", "topic": "progress test", "total": 4, "unit": "cycles", "units_per_sec": 1}}, "topics": ["progress test"]}
  {"state": {"progress test": {"active": true, "estimate_sec": 3, "estimate_str": "03s", "item": "loop 2", "pid": 42, "pos": 2, "speed_str": "1 cycles/sec", "topic": "progress test", "total": 4, "unit": "cycles", "units_per_sec": 1}}, "topics": ["progress test"]}
  {"state": {"progress test": {"active": true, "estimate_sec": 2, "estimate_str": "02s", "item": "loop 3", "pid": 42, "pos": 3, "speed_str": "1 cycles/sec", "topic": "progress test", "total": 4, "unit": "cycles", "units_per_sec": 1}}, "topics": ["progress test"]}
  {"state": {"progress test": {"active": true, "estimate_sec": 1, "estimate_str": "01s", "item": "loop 4", "pid": 42, "pos": 4, "speed_str": "1 cycles/sec", "topic": "progress test", "total": 4, "unit": "cycles", "units_per_sec": 1}}, "topics": ["progress test"]}
  {"state": {}, "topics": []}

test nested short-lived topics (which shouldn't display with changedelay)
  $ withprogress hg progresstest --nested 4 4
  {"state": {"progress test": {"active": false, "estimate_sec": null, "estimate_str": null, "item": "loop 0", "pid": 42, "pos": 0, "speed_str": null, "topic": "progress test", "total": 4, "unit": "cycles", "units_per_sec": null}}, "topics": ["progress test"]}
  {"state": {"nested progress": {"active": false, "estimate_sec": null, "estimate_str": null, "item": "nest 0", "pid": 42, "pos": 0, "speed_str": null, "topic": "nested progress", "total": 2, "unit": null, "units_per_sec": null}, "progress test": {"active": true, "estimate_sec": null, "estimate_str": null, "item": "loop 0", "pid": 42, "pos": 0, "speed_str": "0 cycles/sec", "topic": "progress test", "total": 4, "unit": "cycles", "units_per_sec": null}}, "topics": ["progress test", "nested progress"]}
  {"state": {"nested progress": {"active": false, "estimate_sec": null, "estimate_str": null, "item": "nest 1", "pid": 42, "pos": 1, "speed_str": null, "topic": "nested progress", "total": 2, "unit": null, "units_per_sec": null}, "progress test": {"active": true, "estimate_sec": null, "estimate_str": null, "item": "loop 0", "pid": 42, "pos": 0, "speed_str": "0 cycles/sec", "topic": "progress test", "total": 4, "unit": "cycles", "units_per_sec": null}}, "topics": ["progress test", "nested progress"]}
  {"state": {"nested progress": {"active": false, "estimate_sec": null, "estimate_str": null, "item": "nest 2", "pid": 42, "pos": 2, "speed_str": null, "topic": "nested progress", "total": 2, "unit": null, "units_per_sec": null}, "progress test": {"active": true, "estimate_sec": null, "estimate_str": null, "item": "loop 0", "pid": 42, "pos": 0, "speed_str": "0 cycles/sec", "topic": "progress test", "total": 4, "unit": "cycles", "units_per_sec": null}}, "topics": ["progress test", "nested progress"]}
  {"state": {"progress test": {"active": true, "estimate_sec": 13, "estimate_str": "13s", "item": "loop 1", "pid": 42, "pos": 1, "speed_str": "0 cycles/sec", "topic": "progress test", "total": 4, "unit": "cycles", "units_per_sec": null}}, "topics": ["progress test"]}
  {"state": {"nested progress": {"active": false, "estimate_sec": null, "estimate_str": null, "item": "nest 0", "pid": 42, "pos": 0, "speed_str": null, "topic": "nested progress", "total": 2, "unit": null, "units_per_sec": null}, "progress test": {"active": true, "estimate_sec": 16, "estimate_str": "16s", "item": "loop 1", "pid": 42, "pos": 1, "speed_str": "0 cycles/sec", "topic": "progress test", "total": 4, "unit": "cycles", "units_per_sec": null}}, "topics": ["progress test", "nested progress"]}
  {"state": {"nested progress": {"active": false, "estimate_sec": null, "estimate_str": null, "item": "nest 1", "pid": 42, "pos": 1, "speed_str": null, "topic": "nested progress", "total": 2, "unit": null, "units_per_sec": null}, "progress test": {"active": true, "estimate_sec": 19, "estimate_str": "19s", "item": "loop 1", "pid": 42, "pos": 1, "speed_str": "0 cycles/sec", "topic": "progress test", "total": 4, "unit": "cycles", "units_per_sec": null}}, "topics": ["progress test", "nested progress"]}
  {"state": {"nested progress": {"active": false, "estimate_sec": null, "estimate_str": null, "item": "nest 2", "pid": 42, "pos": 2, "speed_str": null, "topic": "nested progress", "total": 2, "unit": null, "units_per_sec": null}, "progress test": {"active": true, "estimate_sec": 22, "estimate_str": "22s", "item": "loop 1", "pid": 42, "pos": 1, "speed_str": "0 cycles/sec", "topic": "progress test", "total": 4, "unit": "cycles", "units_per_sec": null}}, "topics": ["progress test", "nested progress"]}
  {"state": {"progress test": {"active": true, "estimate_sec": 9, "estimate_str": "09s", "item": "loop 2", "pid": 42, "pos": 2, "speed_str": "0 cycles/sec", "topic": "progress test", "total": 4, "unit": "cycles", "units_per_sec": null}}, "topics": ["progress test"]}
  {"state": {"nested progress": {"active": false, "estimate_sec": null, "estimate_str": null, "item": "nest 0", "pid": 42, "pos": 0, "speed_str": null, "topic": "nested progress", "total": 2, "unit": null, "units_per_sec": null}, "progress test": {"active": true, "estimate_sec": 10, "estimate_str": "10s", "item": "loop 2", "pid": 42, "pos": 2, "speed_str": "0 cycles/sec", "topic": "progress test", "total": 4, "unit": "cycles", "units_per_sec": null}}, "topics": ["progress test", "nested progress"]}
  {"state": {"nested progress": {"active": false, "estimate_sec": null, "estimate_str": null, "item": "nest 1", "pid": 42, "pos": 1, "speed_str": null, "topic": "nested progress", "total": 2, "unit": null, "units_per_sec": null}, "progress test": {"active": true, "estimate_sec": 11, "estimate_str": "11s", "item": "loop 2", "pid": 42, "pos": 2, "speed_str": "0 cycles/sec", "topic": "progress test", "total": 4, "unit": "cycles", "units_per_sec": null}}, "topics": ["progress test", "nested progress"]}
  {"state": {"nested progress": {"active": false, "estimate_sec": null, "estimate_str": null, "item": "nest 2", "pid": 42, "pos": 2, "speed_str": null, "topic": "nested progress", "total": 2, "unit": null, "units_per_sec": null}, "progress test": {"active": true, "estimate_sec": 12, "estimate_str": "12s", "item": "loop 2", "pid": 42, "pos": 2, "speed_str": "0 cycles/sec", "topic": "progress test", "total": 4, "unit": "cycles", "units_per_sec": null}}, "topics": ["progress test", "nested progress"]}
  {"state": {"progress test": {"active": true, "estimate_sec": 5, "estimate_str": "05s", "item": "loop 3", "pid": 42, "pos": 3, "speed_str": "0 cycles/sec", "topic": "progress test", "total": 4, "unit": "cycles", "units_per_sec": null}}, "topics": ["progress test"]}
  {"state": {"nested progress": {"active": false, "estimate_sec": null, "estimate_str": null, "item": "nest 0", "pid": 42, "pos": 0, "speed_str": null, "topic": "nested progress", "total": 2, "unit": null, "units_per_sec": null}, "progress test": {"active": true, "estimate_sec": 5, "estimate_str": "05s", "item": "loop 3", "pid": 42, "pos": 3, "speed_str": "0 cycles/sec", "topic": "progress test", "total": 4, "unit": "cycles", "units_per_sec": null}}, "topics": ["progress test", "nested progress"]}
  {"state": {"nested progress": {"active": false, "estimate_sec": null, "estimate_str": null, "item": "nest 1", "pid": 42, "pos": 1, "speed_str": null, "topic": "nested progress", "total": 2, "unit": null, "units_per_sec": null}, "progress test": {"active": true, "estimate_sec": 5, "estimate_str": "05s", "item": "loop 3", "pid": 42, "pos": 3, "speed_str": "0 cycles/sec", "topic": "progress test", "total": 4, "unit": "cycles", "units_per_sec": null}}, "topics": ["progress test", "nested progress"]}
  {"state": {"nested progress": {"active": false, "estimate_sec": null, "estimate_str": null, "item": "nest 2", "pid": 42, "pos": 2, "speed_str": null, "topic": "nested progress", "total": 2, "unit": null, "units_per_sec": null}, "progress test": {"active": true, "estimate_sec": 6, "estimate_str": "06s", "item": "loop 3", "pid": 42, "pos": 3, "speed_str": "0 cycles/sec", "topic": "progress test", "total": 4, "unit": "cycles", "units_per_sec": null}}, "topics": ["progress test", "nested progress"]}
  {"state": {"progress test": {"active": true, "estimate_sec": 1, "estimate_str": "01s", "item": "loop 4", "pid": 42, "pos": 4, "speed_str": "0 cycles/sec", "topic": "progress test", "total": 4, "unit": "cycles", "units_per_sec": null}}, "topics": ["progress test"]}
  {"state": {"nested progress": {"active": false, "estimate_sec": null, "estimate_str": null, "item": "nest 0", "pid": 42, "pos": 0, "speed_str": null, "topic": "nested progress", "total": 2, "unit": null, "units_per_sec": null}, "progress test": {"active": true, "estimate_sec": 1, "estimate_str": "01s", "item": "loop 4", "pid": 42, "pos": 4, "speed_str": "0 cycles/sec", "topic": "progress test", "total": 4, "unit": "cycles", "units_per_sec": null}}, "topics": ["progress test", "nested progress"]}
  {"state": {"nested progress": {"active": false, "estimate_sec": null, "estimate_str": null, "item": "nest 1", "pid": 42, "pos": 1, "speed_str": null, "topic": "nested progress", "total": 2, "unit": null, "units_per_sec": null}, "progress test": {"active": true, "estimate_sec": 1, "estimate_str": "01s", "item": "loop 4", "pid": 42, "pos": 4, "speed_str": "0 cycles/sec", "topic": "progress test", "total": 4, "unit": "cycles", "units_per_sec": null}}, "topics": ["progress test", "nested progress"]}
  {"state": {"nested progress": {"active": false, "estimate_sec": null, "estimate_str": null, "item": "nest 2", "pid": 42, "pos": 2, "speed_str": null, "topic": "nested progress", "total": 2, "unit": null, "units_per_sec": null}, "progress test": {"active": true, "estimate_sec": 1, "estimate_str": "01s", "item": "loop 4", "pid": 42, "pos": 4, "speed_str": "0 cycles/sec", "topic": "progress test", "total": 4, "unit": "cycles", "units_per_sec": null}}, "topics": ["progress test", "nested progress"]}
  {"state": {}, "topics": []}

test rendering with bytes
  $ withprogress hg bytesprogresstest
  {"state": {"bytes progress test": {"active": false, "estimate_sec": null, "estimate_str": null, "item": "0 bytes", "pid": 42, "pos": 0, "speed_str": null, "topic": "bytes progress test", "total": 1111111111, "unit": "bytes", "units_per_sec": null}}, "topics": ["bytes progress test"]}
  {"state": {"bytes progress test": {"active": true, "estimate_sec": 111111111, "estimate_str": "3y28w", "item": "10 bytes", "pid": 42, "pos": 10, "speed_str": "10 bytes/sec", "topic": "bytes progress test", "total": 1111111111, "unit": "bytes", "units_per_sec": 10}}, "topics": ["bytes progress test"]}
  {"state": {"bytes progress test": {"active": true, "estimate_sec": 8888887, "estimate_str": "14w05d", "item": "250 bytes", "pid": 42, "pos": 250, "speed_str": "125 bytes/sec", "topic": "bytes progress test", "total": 1111111111, "unit": "bytes", "units_per_sec": 125}}, "topics": ["bytes progress test"]}
  {"state": {"bytes progress test": {"active": true, "estimate_sec": 3336668, "estimate_str": "5w04d", "item": "999 bytes", "pid": 42, "pos": 999, "speed_str": "333 bytes/sec", "topic": "bytes progress test", "total": 1111111111, "unit": "bytes", "units_per_sec": 333}}, "topics": ["bytes progress test"]}
  {"state": {"bytes progress test": {"active": true, "estimate_sec": 4444441, "estimate_str": "7w03d", "item": "1000 bytes", "pid": 42, "pos": 1000, "speed_str": "250 bytes/sec", "topic": "bytes progress test", "total": 1111111111, "unit": "bytes", "units_per_sec": 250}}, "topics": ["bytes progress test"]}
  {"state": {"bytes progress test": {"active": true, "estimate_sec": 5425343, "estimate_str": "9w00d", "item": "1024 bytes", "pid": 42, "pos": 1024, "speed_str": "204 bytes/sec", "topic": "bytes progress test", "total": 1111111111, "unit": "bytes", "units_per_sec": 204}}, "topics": ["bytes progress test"]}
  {"state": {"bytes progress test": {"active": true, "estimate_sec": 303025, "estimate_str": "3d13h", "item": "22000 bytes", "pid": 42, "pos": 22000, "speed_str": "3.58 KB/sec", "topic": "bytes progress test", "total": 1111111111, "unit": "bytes", "units_per_sec": 3666}}, "topics": ["bytes progress test"]}
  {"state": {"bytes progress test": {"active": true, "estimate_sec": 7411, "estimate_str": "2h04m", "item": "1048576 bytes", "pid": 42, "pos": 1048576, "speed_str": "146 KB/sec", "topic": "bytes progress test", "total": 1111111111, "unit": "bytes", "units_per_sec": 149796}}, "topics": ["bytes progress test"]}
  {"state": {"bytes progress test": {"active": true, "estimate_sec": 6021, "estimate_str": "1h41m", "item": "1474560 bytes", "pid": 42, "pos": 1474560, "speed_str": "180 KB/sec", "topic": "bytes progress test", "total": 1111111111, "unit": "bytes", "units_per_sec": 184320}}, "topics": ["bytes progress test"]}
  {"state": {"bytes progress test": {"active": true, "estimate_sec": 73, "estimate_str": "1m13s", "item": "123456789 bytes", "pid": 42, "pos": 123456789, "speed_str": "13.1 MB/sec", "topic": "bytes progress test", "total": 1111111111, "unit": "bytes", "units_per_sec": 13717421}}, "topics": ["bytes progress test"]}
  {"state": {"bytes progress test": {"active": true, "estimate_sec": 11, "estimate_str": "11s", "item": "555555555 bytes", "pid": 42, "pos": 555555555, "speed_str": "53.0 MB/sec", "topic": "bytes progress test", "total": 1111111111, "unit": "bytes", "units_per_sec": 55555555}}, "topics": ["bytes progress test"]}
  {"state": {"bytes progress test": {"active": true, "estimate_sec": 2, "estimate_str": "02s", "item": "1000000000 bytes", "pid": 42, "pos": 1000000000, "speed_str": "86.7 MB/sec", "topic": "bytes progress test", "total": 1111111111, "unit": "bytes", "units_per_sec": 90909090}}, "topics": ["bytes progress test"]}
  {"state": {"bytes progress test": {"active": true, "estimate_sec": 1, "estimate_str": "01s", "item": "1111111111 bytes", "pid": 42, "pos": 1111111111, "speed_str": "88.3 MB/sec", "topic": "bytes progress test", "total": 1111111111, "unit": "bytes", "units_per_sec": 92592592}}, "topics": ["bytes progress test"]}
  {"state": {}, "topics": []}
test immediate completion
  $ withprogress hg progresstest 0 0
  {"state": {"progress test": {"active": false, "estimate_sec": null, "estimate_str": null, "item": "loop 0", "pid": 42, "pos": 0, "speed_str": null, "topic": "progress test", "total": 0, "unit": "cycles", "units_per_sec": null}}, "topics": ["progress test"]}

test unicode topic
  $ withprogress hg --encoding utf-8 progresstest 4 4 --unicode --config progress.format='topic number'
  {"state": {"\u3042\u3044\u3046\u3048": {"active": false, "estimate_sec": null, "estimate_str": null, "item": "\u3042\u3044", "pid": 42, "pos": 0, "speed_str": null, "topic": "\u3042\u3044\u3046\u3048", "total": 4, "unit": "cycles", "units_per_sec": null}}, "topics": ["\u3042\u3044\u3046\u3048"]}
  {"state": {"\u3042\u3044\u3046\u3048": {"active": true, "estimate_sec": 4, "estimate_str": "04s", "item": "\u3042\u3044\u3046", "pid": 42, "pos": 1, "speed_str": "1 cycles/sec", "topic": "\u3042\u3044\u3046\u3048", "total": 4, "unit": "cycles", "units_per_sec": 1}}, "topics": ["\u3042\u3044\u3046\u3048"]}
  {"state": {"\u3042\u3044\u3046\u3048": {"active": true, "estimate_sec": 3, "estimate_str": "03s", "item": "\u3042\u3044\u3046\u3048", "pid": 42, "pos": 2, "speed_str": "1 cycles/sec", "topic": "\u3042\u3044\u3046\u3048", "total": 4, "unit": "cycles", "units_per_sec": 1}}, "topics": ["\u3042\u3044\u3046\u3048"]}
  {"state": {"\u3042\u3044\u3046\u3048": {"active": true, "estimate_sec": 2, "estimate_str": "02s", "item": "\u3042\u3044", "pid": 42, "pos": 3, "speed_str": "1 cycles/sec", "topic": "\u3042\u3044\u3046\u3048", "total": 4, "unit": "cycles", "units_per_sec": 1}}, "topics": ["\u3042\u3044\u3046\u3048"]}
  {"state": {"\u3042\u3044\u3046\u3048": {"active": true, "estimate_sec": 1, "estimate_str": "01s", "item": "\u3042\u3044\u3046", "pid": 42, "pos": 4, "speed_str": "1 cycles/sec", "topic": "\u3042\u3044\u3046\u3048", "total": 4, "unit": "cycles", "units_per_sec": 1}}, "topics": ["\u3042\u3044\u3046\u3048"]}
  {"state": {}, "topics": []}
