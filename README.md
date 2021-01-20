# crystal-init-image
An example using the `init-image` feature of [Oracle Functions](https://www.oracle.com/cloud-native/functions/) and [Fn Project](fnproject.io).

## `init-image` Description
`init-image` is a way of creating new functions, based on a template, rather than using an FDK.

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
`init-image` may be used to create functions with consistent, pre - defined:
- dependencies
- scaffold code
- Dockerfile

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

You should have created a Functions or Fn application.

### Base Image
The [crystal-base](./crystal-base) folder contains
- the `FnHelper` module in the file [helper.cr](./crystal-base/helper.cr).
- a Dockerfile to to build an image containing the helper.

To build this run:
```
docker build -t <your-docker-id>/crystal-base .
docker push <your-docker-id>/crystal-base
```

Now you could just base your functions off this base image.
But you would need to write a new `Dockerfile` each time and your code from scratch.
Using an `init-image` you will have a standard starting point for each function.

### Init Image
The boilerplate function is created by the `init-image`.

The [crystal-init](./crystal-init) folder contains:
- [`Dockerfile`](./crystal-init/Dockerfile) to build the function.
- [`func.cr`](./crystal-init/func.cr) the sample function.
- [`func.init.yaml`](./crystal-init/func.init.yaml) used by the Fn CLI to create the `func.yaml` file in the function directory.
- [`init.tar`](./crystal-init/init.tar) contains all of the above files.
- [`Dockerfile-init`](./crystal-init/Dockerfile-init) to build the `init-image`

Before you build the `init-image`, you need to:
1. Edit the `Dockerfile` so that it starts with `FROM <your-docker-id>/crystal-base`.
2. Recreate the `init.tar` to include the change: `tar -cf init.tar Dockerfile func.init.yaml func.cr`

If there are additional files you want to include in your functions they should also be wrapped into the `init.tar`.

Then you can build the `init-image`:

```
docker build -f Dockerfile-init -t <your-docker-id>/crystal-init .
docker push <your-docker-id>/crystal-init
```

### Create a function
To create a function using the `init-image`, run:

`fn init --init-image <your-docker-id>/crystal-init <your-new-function-name>`

This should create a new function:

```
$ fn init --init-image crush157/crystal-init cii-test
Creating function at: ./cii-test
Running init-image: crush157/crystal-init
Executing docker command: run --rm -e FN_FUNCTION_NAME=cii-test crush157/crystal-init
func.yaml created.
```
Check that the files have been created:

```
$ ls cii-test
Dockerfile func.cr    func.yaml
```

Then deploy to your application:

```
$ fn deploy --app crystal cii-test                  [21:49:02]
Deploying function at: ./cii-test
Deploying cii-test to app: crystal
Bumped to version 0.0.2
Building image crush157/cii-test:0.0.2 
Parts:  [crush157 cii-test:0.0.2]
Pushing crush157/cii-test:0.0.2 to docker registry...The push refers to repository [docker.io/crush157/cii-test]
d16bd484677b: Layer already exists 
436dae087262: Layer already exists 
b68529f7ae55: Layer already exists 
fd9304a56d64: Layer already exists 
e0947d35a4c9: Layer already exists 
e1dfb1d4adcd: Layer already exists 
22de226a7b03: Layer already exists 
ddc500d84994: Layer already exists 
c64c52ea2c16: Layer already exists 
5930c9e5703f: Layer already exists 
b187ff70b2e4: Layer already exists 
0.0.2: digest: sha256:c7f3c0489571004a7719c5c0c1b0103a62426778333b3e0c85de2f51ed51e82c size: 2611
Updating function cii-test using image crush157/cii-test:0.0.2...
Successfully created function: cii-test with crush157/cii-test:0.0.2
```

Then test the function:

```
$ fn invoke crystal cii-test
{"message": "Hello world"}
$ echo '{"name":"latte"}' | fn invoke crystal cii-test
{"message": "Hello latte"}
```

Enjoy!
