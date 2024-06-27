{
  description = "devenv";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        dfxSrc =
          if system == "x86_64-linux" then
            {
              url = "https://github.com/dfinity/sdk/releases/download/0.19.0/dfx-0.19.0-x86_64-linux.tar.gz";
              sha256 = "c40387d13ab6ed87349fa21a98835f8d384f867333806ee6b9025891ed96e5c5";
            }
          else if system == "x86_64-darwin" || system == "aarch64-darwin" then
            {
              url = "https://github.com/dfinity/sdk/releases/download/0.19.0/dfx-0.19.0-x86_64-darwin.tar.gz";
              sha256 = "f61179fa9884f111dbec20c293d77472dcf66d04b0567818fe546437aadd8ce6";
            }
          else
            { };

        dfx = pkgs.stdenv.mkDerivation {
          name = "dfx-${system}";
          src = pkgs.fetchurl dfxSrc;

          buildInputs = [
            pkgs.gnutar
            pkgs.gzip
          ];

          unpackPhase = "tar -xzf $src";

          installPhase = ''
            mkdir -p $out/bin
            cp dfx $out/bin/
          '';
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            # ic
            dfx

            # zig
            zig
            zls

            # wasm
            wabt

            # to compile C code
            llvmPackages.bintools
            llvmPackages.libclang.lib
            llvmPackages.clang

            # nix
            nixfmt-rfc-style
          ];

          shellHook = ''
            echo "welcome to your nix shell"
          '';
        };
      }
    );
}
