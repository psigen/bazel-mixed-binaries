# Mixed Python/Shell Bazel Example

### [(Answered on StackOverflow)](https://stackoverflow.com/q/53472993/2044807)

In this repo, we have a python binary target that counts the number of lines of a file that contain some specified string and returns this count via stdout. This is the `//pylib:counter` target.

Assume this is an upstream package that produces many binary tools for various purposes.

We have a second package `//shbin` that contains some data files that we would like to process. For convenience, we create a shell script that runs the python binary tool over several such data files with the correct arguments.

What is the right way to represent the dependencies between these targets and resolve the `//pybin:counter` target from the `//shbin:run` target such that Bazel will package them appropriately?

## Examples:

We can call `//pybin:counter` as expected using an included data file.
```bash
$ bazel run //pybin:counter "apple" pybin/data.txt
3
```

We cannot use `//pybin:counter` as a dependency in `//shbin:run` at all.
```bash
$ bazel run //shbin:run
ERROR: /Users/pkv/tmp/workspace/shbin/BUILD.bazel:5:12: in deps attribute of sh_binary rule //shbin:run: py_binary rule '//pybin:counter' is misplaced here (expected sh_library)
ERROR: Analysis of target '//shbin:run' failed; build aborted: Analysis of target '//shbin:run' failed; build aborted
INFO: Elapsed time: 0.512s
INFO: 0 processes.
FAILED: Build did NOT complete successfully (1 packages loaded)
FAILED: Build did NOT complete successfully (1 packages loaded)
```

We cannot use any of the `bazel info` commands from within `//shbin:run` to resolve the relative path to the binary.
```bash
zeta:workspace pkv$ bazel run //shbin:run -- A
INFO: Analysed target //shbin:run (1 packages loaded).
INFO: Found 1 target...
Target //shbin:run up-to-date:
  bazel-bin/shbin/run
INFO: Elapsed time: 0.213s, Critical Path: 0.01s
INFO: 0 processes.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
ERROR: bazel should not be called from a bazel output directory. The pertinent workspace directory is: '[/Users/[...]/tmp]/workspace'
/private/var/tmp/_bazel_[...]/4b0d40c8140c97c79f2c80916e2ee0ea/execroot/__main__/bazel-out/darwin-fastbuild/bin/shbin/run: line 2: /counter.py: No such file or directory
```

We _can_ hack the relative path to the built `//pybin:counter` binary within the same workspace output directory.  However, this is almost certainly breaking the "hermetic-ness" of the build.
```bash
zeta:workspace pkv$ bazel run //shbin:run -- B
INFO: Analysed target //shbin:run (0 packages loaded).
INFO: Found 1 target...
Target //shbin:run up-to-date:
  bazel-bin/shbin/run
INFO: Elapsed time: 0.199s, Critical Path: 0.01s
INFO: 0 processes.
INFO: Build completed successfully, 1 total action
INFO: Build completed successfully, 1 total action
1
```
