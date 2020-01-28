#!/usr/bin/env python
#
# simple script to be used in hooks
#
# put something like this in the repo .hg/hgrc:
#
#     [hooks]
#     changegroup = python "$TESTDIR/printenv.py" <hookname> [exit] [output]
#
#   - <hookname> is a mandatory argument (e.g. "changegroup")
#   - [exit] is the exit code of the hook (default: 0)
#   - [output] is the name of the output file (default: use sys.stdout)
#              the file will be opened in append mode.
#
from __future__ import absolute_import

import os
import sys


try:
    import msvcrt

    msvcrt.setmode(sys.stdin.fileno(), os.O_BINARY)
    msvcrt.setmode(sys.stdout.fileno(), os.O_BINARY)
    msvcrt.setmode(sys.stderr.fileno(), os.O_BINARY)
except ImportError:
    pass

exitcode = 0

if sys.version_info[0] >= 3:
    out = sys.stdout.buffer
else:
    out = sys.stdout

name = sys.argv[1]
if len(sys.argv) > 2:
    exitcode = int(sys.argv[2])
    if len(sys.argv) > 3:
        out = open(sys.argv[3], "ab")

# variables with empty values may not exist on all platforms, filter
# them now for portability sake.
env = [(k, v) for k, v in os.environ.items() if k.startswith("HG_") and v]
env.sort()

out.write(b"%s hook: " % name.encode("utf8"))
if os.name == "nt":
    filter = lambda x: x.replace("\\", "/")
else:
    filter = lambda x: x
vars = ["%s=%s" % (k, filter(v)) for k, v in env]
out.write(" ".join(vars).encode("utf8"))
out.write(b"\n")
out.close()

sys.exit(exitcode)
