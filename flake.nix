{
  description = "Todo in Dioxus";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      rust-overlay,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import rust-overlay) ];
        };

        package = pkgs.callPackage ./todo-dioxus.nix { };
      in
      {
        packages.default = package;
        packages.todo-dioxus = package;

        devShells.default = pkgs.mkShell {
          inputsFrom = [ package ];
          buildInputs = [ pkgs.nixfmt-rfc-style ];
        };
      }
    );
}
