{
  description = "Todo in Dioxus";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs =
            [
              pkgs.rustup
              pkgs.dioxus-cli
              pkgs.iconv
            ]
            ++ (pkgs.lib.optionals pkgs.stdenv.isDarwin [
              pkgs.darwin.apple_sdk.frameworks.DiskArbitration
              pkgs.darwin.apple_sdk.frameworks.AppKit
              pkgs.darwin.apple_sdk.frameworks.WebKit
            ]);
        };
      }
    );
}
