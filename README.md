# Compiler Coursework Environment

For the coursework, a pre-built Docker image has been made which contains all of the tools you need to get started.

It is recommended that you use VS Code as this has good support for working inside Docker containers. However, instructions have been provided if you wish to use another editor.

## VS Code + Docker (recommended)

1) Install [Docker Desktop](https://www.docker.com/products/docker-desktop/). If you are on Apple M1/M2, make sure to choose the Apple Silicon download.
2) Open VS Code and install the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension
3) Open the folder containing this README.md file, in VS Code
4) Open the Command Palette in VS Code. You can do this by the shortcut `Ctrl + Shift + P` on Windows or `Cmd + Shift + P` on Mac. Alternatively, you can access this from `View -> Command Palette`.
5) Enter `>Dev Containers: Reopen in Container` into the Command Palette
6) After a delay -- depending on how fast your Internet connection can download ~1GB -- you will now be in the container environment. For those interested, VS Code reads the container configuration from the [.devcontainer/devcontainer.json](.devcontainer/devcontainer.json) file.
7) Test that your tools are correctly setup by running ./test.sh in the VS Code terminal, accessible via `Terminal -> New Terminal`. Your output should look as follows:
    ```bash
    root@e3221f21a2a1:/workspaces/langproc-env# ./test.sh
    bbl loader
    Hello from RISC-V
    Test function produced value: 8.700000
    Example function returned: 123
    Exited with code 5
    ```

## Another Editor + Docker

> Warning for Windows users: if you are running Windows and use this method, you may experience errors related to the line endings of your files. Windows uses the special characters CRLF to represent the end of a line, whereas Linux uses just LF. As such, if you edit these files on Windows they are most likely to be saved using CRLF. See if you can change your editor to use LF file endings or, even better, see if your editor supports [EditorConfig](https://editorconfig.org/), which standardises formatting across all files based on the [.editorconfig](.editorconfig) file in the same folder as this README.md file.

1) Install [Docker](https://www.docker.com/products/docker-desktop/). If you are on Apple M1/M2, make sure to choose the Apple Silicon download.
2) Open a terminal to the folder containing this README.md file
3) Inside that terminal, run `docker run --rm -it -v "${PWD}:/code" -w "/code" --name "compilers_env" ghcr.io/jpnock/langproc-env/langproc-env:latest`
4) You should now be inside the LangProc tools container, where you can run `./test.sh` inside the `/code` folder to check that your tools are working correctly. Note that the folder containing this README.md, as well as any subdirectories, are mounted inside this container under the path `/code`. The output of running the command should look as follows:
    ```bash
    root@ad12f00322f6:/code# ./test.sh
    bbl loader
    Hello from RISC-V
    Test function produced value: 8.700000
    Example function returned: 123
    Exited with code 5
    ```
