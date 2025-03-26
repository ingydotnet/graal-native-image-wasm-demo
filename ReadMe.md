graal-native-image-wasm-demo
============================

Complete Automation of [This GraalVM native-image Wasm Demo](
https://github.com/graalvm/graalvm-demos/tree/fniephaus/wasm-demo/native-image/wasm-helloworld)

See also: https://stackoverflow.com/questions/67977966/compile-java-to-webassembly/79542976#79542976


## Synopsis

```
$ make run
... lots of output on first run ...
node hellowasm.js
Hello from WebAssembly generated with GraalVM!
$
$ make run
node hellowasm.js
Hello from WebAssembly generated with GraalVM!
```


## Description

The Makefile will "install" the correct versions of GraalVM native-image
(including all Java needed), Binaryen, and NodeJS v22.0.0 (needed); all inside
the repo directory.
