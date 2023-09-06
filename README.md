Testing nix

# manual 

```
LD_LIBRARY_PATH=/nix/store/7ls5xhx6kqpjgpg67kdd4pmbkhna4b6c-gcc-12.2.0-lib/lib/:$LD_LIBRARY_PATH /nix/store/x33pcmpsiimxhip52mwxbb5y77dhmb21-glibc-2.37-8/lib/ld-linux-x86-64.so.2 /nix/store/k9ywsqknwpyn88idr92ppjfw1n0dkayp-spanner-emulator/bin/emulator_main --host_port localhost:1234


LD_LIBRARY_PATH=/nix/store/7ls5xhx6kqpjgpg67kdd4pmbkhna4b6c-gcc-12.2.0-lib/lib/:$LD_LIBRARY_PATH /nix/store/x33pcmpsiimxhip52mwxbb5y77dhmb21-glibc-2.37-8/lib/ld-linux-x86-64.so.2 /nix/store/k9ywsqknwpyn88idr92ppjfw1n0dkayp-spanner-emulator/bin/gateway_main --hostname localhost --grpc_port 1234 --http_port 1235
```

# Branch notes

- this branch correctly links when `cd emulator; nix develop` is run
- but it gives runtime errors like

```
emulator_main: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.33' not found (required by /nix/store/7ls5xhx6kqpjgpg67kdd4pmbkhna4b6c-gcc-12.2.0-lib/lib/libstdc++.so.6)
emulator_main: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.32' not found (required by /nix/store/7ls5xhx6kqpjgpg67kdd4pmbkhna4b6c-gcc-12.2.0-lib/lib/libstdc++.so.6)
emulator_main: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.36' not found (required by /nix/store/7ls5xhx6kqpjgpg67kdd4pmbkhna4b6c-gcc-12.2.0-lib/lib/libstdc++.so.6)
emulator_main: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.34' not found (required by /nix/store/7ls5xhx6kqpjgpg67kdd4pmbkhna4b6c-gcc-12.2.0-lib/lib/libstdc++.so.6)
emulator_main: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.35' not found (required by /nix/store/7ls5xhx6kqpjgpg67kdd4pmbkhna4b6c-gcc-12.2.0-lib/lib/libgcc_s.so.1)
emulator_main: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.34' not found (required by /nix/store/7ls5xhx6kqpjgpg67kdd4pmbkhna4b6c-gcc-12.2.0-lib/lib/libgcc_s.so.1)
```

```
find /nix/store/*emulator*/ -name 'emulator_main'
```

```
ldd /nix/store/pz5gz7b6hnrkyilakr4sbzclmhrlv1cf-spanner-emulator/bin/emulator_main
        linux-vdso.so.1 (0x00007ffcd0797000)
        libpthread.so.0 => /nix/store/yzjgl0h6a3qh1mby405428f16xww37h0-glibc-2.35-224/lib/libpthread.so.0 (0x00007f146b31b000)
        libm.so.6 => /nix/store/yzjgl0h6a3qh1mby405428f16xww37h0-glibc-2.35-224/lib/libm.so.6 (0x00007f146b23b000)
        libstdc++.so.6 => not found
        libgcc_s.so.1 => /nix/store/yzjgl0h6a3qh1mby405428f16xww37h0-glibc-2.35-224/lib/libgcc_s.so.1 (0x00007f146b221000)
        libc.so.6 => /nix/store/yzjgl0h6a3qh1mby405428f16xww37h0-glibc-2.35-224/lib/libc.so.6 (0x00007f146b018000)
        /lib64/ld-linux-x86-64.so.2 => /nix/store/yzjgl0h6a3qh1mby405428f16xww37h0-glibc-2.35-224/lib64/ld-linux-x86-64.so.2 (0x00007f146e5ae000)
```

```
nix --extra-experimental-features nix-command eval --impure --raw --expr 'with import <nixpkgs> {}; stdenv.cc.cc.lib'
```