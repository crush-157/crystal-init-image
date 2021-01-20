# crystal-init-image
An example using the `init-image` feature of [Oracle Functions](https://www.oracle.com/cloud-native/functions/ and [Fn Project](fnproject.io).

## init-image
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
  
