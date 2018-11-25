#!/bin/bash

# Select from one of the following script tests.
case "$1" in
    A)
        # Try to resolve the path to this binary using `bazel info`.
        $(bazel info bazel-genfiles)/counter.py "apple" ./data.txt
        ;;

    B)
        # Cheat by finding a relative path to the build output.
        ../../../pybin/counter "apple" shbin/data.txt
        ;;
    *)
        echo $"Usage: $0 {A|B}"
        exit 1
esac
