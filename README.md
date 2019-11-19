# Basalt

Basalt is a collection of formally verified building blocks written in SPARK.
It is standalone and requires only few runtime features (Interfaces, Secondary Stack).
All components are proven to be absent of runtime errors.
Furthermore some useful functional properties are formally verified.

## Blocks

- [Basalt.Queue](src/basalt-queue.ads) - A FIFO queue implementation.
  The formal properties include the number of available elements allowing
  to access multiple elements in a loop without checking each time.
- [Basalt.Slicer](src/basalt-slicer.ads) - A slicer that splits ranges into
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

The [componolit-runtime](https://github.com/Componolit/ada-runtime) is sufficient to run it.

The recommended compiler is the [GNAT Community 2019](https://www.adacore.com/download/) Ada compiler
that also comes with Aunit and SPARK 2014 to run the tests and proofs.

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

To run the proofs run
```
$ gnatprove -P test/proof/proof.gpr --level=2
```
