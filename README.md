# crystal-init-image
An example using the `init-image` feature of [Oracle Functions](https://www.oracle.com/cloud-native/functions/ and [Fn Project](fnproject.io).

## `init-image` Description
`init-image` is a way of creating a new function based upon a Docker template rather than using an FDK.

The `fn init` command is used with the flag `--init-image <template-image>` specified, rather than the flag `--runtime <runtime>`.

For example:
```
$ fn init --init-image crush157/crystal-init hello-crystal
Creating function at: ./hello-crystal
Running init-image: crush157/crystal-init
Executing docker command: run --rm -e FN_FUNCTION_NAME=hello-crystal crush157/crystal-init
func.yaml created.
```

The function directory will now contain the following files (at a minimum):
```
func.yaml
Dockerfile`
func.<your-language-extension>
```

`func.<your-language-extension>` should contain the code for a simple example function (Traditionally "hello, <name>|World!").
  
## Uses
`init-image` may be used to share common base of code and/or dependencies across a set of functions.

## Example
This example shows how to use `init-image` to make it easier to create functions written in [Crystal](http://crystal-lang.org).

It will allow us, in effect, to create a "poor man's FDK".

As Crstal doesn't have an FDK, we need to provide a "helper" to act as an interface between the Functions service and the function code.

In the [crystal-fn](https://github.com/crush-157/crystal-fn) repository, there is an example of a function with such a helper.

This is fine for a single function, but obviously copying this module into every function would be cumbersome and create a maintenance nightmare.

One option to share the code is to use an `init-image`.

### Prerequisites
To follow the example, clone this repository to your environment.
You should have the following installed:
- Docker
- Fn CLI

You should have a Docker ID, and be able to push to Docker hub.

### Base Image
The [crystal-base](./crystal-base) folder contains
- the `FnHelper` module in the file [helper.cr](./crystal-base/helper.cr).
- a Dockerfile to to build an image containing the helper.

To build this run:
```
docker build -t <your-docker-id>/crystal-base .
docker push <your-docker-id>/crystl-base
```
