{
  lib,
  iconv,
  darwin,
  stdenv,
  makeRustPlatform,
  rust-bin,
}:
let
  rust = rust-bin.stable.latest.default.override {
    extensions = [ "rust-src" "rust-analyzer" ];
  };
  rustPlatform = makeRustPlatform {
    cargo = rust;
    rustc = rust;
  };
in
rustPlatform.buildRustPackage rec {
  pname = "todo-dioxus";
  version = "0.1.0";

  src = ./.;

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  buildInputs =
    [ iconv ]
    ++ (lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.DiskArbitration
      darwin.apple_sdk.frameworks.AppKit
      darwin.apple_sdk.frameworks.WebKit
    ]);

  meta = {
    description = "TODO in Dioxus";
    homepage = "https://github.com/Denommus/todo-dioxus";
    license = lib.licenses.mit;
    maintainers = [ "yuridenommus@gmail.com" ];
  };
}
