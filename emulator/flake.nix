{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        name = "simple";
        src = ./.;
        pkgs = nixpkgs.legacyPackages.${system};
      in
      rec {
        packages = { } // (if system == "x86_64-linux" then {
          spanner-emulator =
            let
              version = "1.5.2";
              inherit (pkgs) stdenv lib;
            in
            stdenv.mkDerivation rec
            {
              name = "spanner-emulator";
              src = pkgs.fetchurl {
                url =
                  "https://storage.googleapis.com/cloud-spanner-emulator/releases/${version}/cloud-spanner-emulator_linux_amd64-${version}.tar.gz";
                sha256 = "e02e53776f36865dd581234c0c21a54add77d88fb956023aa47f99d96c0af788";
              };
              sourceRoot = ".";
              nativeBuildInputs = [
                pkgs.autoPatchelfHook
              ];
              buildInputs = [
                # pkgs.glibc
                pkgs.gcc-unwrapped
              ];
              unpackPhase = ''
                mkdir -p $out/bin
                tar -xzf $src -C $out/bin
              '';
              meta = with nixpkgs.lib; {
                homepage = "https://github.com/GoogleCloudPlatform/cloud-spanner-emulator";
                description =
                  "Cloud Spanner Emulator is a local emulator for the Google Cloud Spanner database service.";
                platforms = platforms.linux;
              };
            };
        } else { });
        devShells = { } // (if system == "x86_64-linux" then {
          default = pkgs.mkShell rec {
            libPath = with pkgs; lib.makeLibraryPath [
              # pkgs.libstdcxx6
              # pkgs.gcc6
              pkgs.stdenv.cc.cc.lib # libstdc++.so.6
            ];
            LD_LIBRARY_PATH = "${libPath}";
            # LD_LIBRARY_PATH = "/opt/glibc/lib";
            buildInputs = [
              self.packages.${system}.spanner-emulator
            ];
          };
        } else { });

      }
    );
}


