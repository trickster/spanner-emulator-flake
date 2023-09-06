# A flake for spanner emulator

- [Spanner emulator](https://github.com/GoogleCloudPlatform/cloud-spanner-emulator) is a emulator for Google Cloud Spanner
- Originally meant to be used with [devbox](https://github.com/jetpack-io/devbox)

## Usage

```bash
devbox shell
```

If you just want the flake, go to [emulator](./emulator), and use `nix develop`` to enter a shell with the emulator installed.

The binary is already in the path, so you can just run `emulator_main` to start the emulator.
