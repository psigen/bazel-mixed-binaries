#!/usr/bin/env python
"""
Load the file specified in the arguments and print each line.
"""
from __future__ import print_function
import sys
import os


def count():
    """ Count the number of instances of some string. """
    match = sys.argv[1]
    path = sys.argv[2]
    cnt = 0

    with open(path, 'r') as f:
        for line in f.readlines():
            if match in line:
                cnt = cnt + 1

    print(cnt)

if __name__ == '__main__':
    count()
