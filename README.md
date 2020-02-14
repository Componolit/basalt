# Basalt

Basalt is a collection of formally verified building blocks written in SPARK.
It is standalone and requires only few runtime features (Interfaces, Secondary Stack).
All modules are proven to contain no runtime errors.
Furthermore some useful functional properties have been formally verified.

## Blocks

- [Basalt.Queue](src/basalt-queue.ads) - A FIFO queue implementation.
  The interface is designed in a way that allows to prove properties about the
  quantity of elements in the queue.
- [Basalt.Stack](src/basalt-stack.ads) - A stack implementation.
  The interface is designed in a way that allows to prove properties about the
  quantity of elements on the stack.
- [Basalt.Slicer](src/basalt-slicer.ads) - A tool that splits ranges into
  maximum sized slices. Each slice proves to be in the initially given range
  and to be at maximum of the given size.
- [Basalt.Strings](src/basalt-strings.ads) - A collection of String operations.
  Currently these are formally proven `Image` functions, similar to `'Image`. The
  difference is that these image function provide maximum lengths of their output
  as proof properties.
- [Basalt.Strings_Generic](src/basalt-strings_generic.ads) - The generic variant
  of `Strings` for modular and ranged types.

## Requirements

Basalt itself does not have any further requirements than an Ada runtime with

 - Interfaces
 - Secondary stack

The [componolit-runtime](https://github.com/Componolit/ada-runtime) is sufficient to use it.

The recommended compiler is the [GNAT Community 2019](https://www.adacore.com/download/) Ada compiler
that also comes with Aunit and SPARK 2014 to run the tests and and perform the proofs.

## Build

Build with
```
$ gprbuild -P basalt.gpr
```

## Test and proof

To run the Aunit tests run
```
$ gprbuild -P test/aunit/test.gpr
$ ./test/aunit/obj/test
```

To perform the proofs run
```
$ gnatprove -P test/proof/proof.gpr --level=2
```
