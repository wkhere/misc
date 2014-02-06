#!/usr/bin/env python
# (c) 2011 Wojciech Kaczmarek <wojtekk@kofeina.net>
#
# This is original example of how to follow file changes using BSD's kqueue.
# It was an erly inspiration for http://github.com/herenowcoder/forever .

import os, select
from sys import stdout

def read_(fd):
    return os.read(fd, 1000) # todo bigger buf or loop until '' is returned

name = 'foo'
kq = select.kqueue()
fd = os.open(name, os.O_RDONLY)
ev = select.kevent(fd,
#    filter=select.KQ_FILTER_VNODE,
#    flags=select.KQ_EV_ADD | select.KQ_EV_ENABLE,
#    fflags=select.KQ_NOTE_EXTEND)
    filter=select.KQ_FILTER_READ,
    flags=select.KQ_EV_ADD | select.KQ_EV_ENABLE)

kq.control([ev],0)
stdout.write(read_(fd))

while True:
    kq.control([],1)
    stdout.write(read_(fd))
