{
  description = "Rust package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = "ptrace-inject";
          version = "0.1.2";

          src = ./.;

          cargoLock.lockFile = ./Cargo.lock;

          cargoBuildFlags = [
            "--features"
            "cli"
          ];
          # If you have native deps:
          # nativeBuildInputs = [ pkgs.pkg-config ];
          # buildInputs = [ pkgs.openssl ];

           installPhase = ''
             runHook preInstall
             install -Dm755 target/x86_64-unknown-linux-gnu/release/ptrace-inject \
               $out/bin/ptrace-inject
             runHook postInstall
           '';

          meta.mainProgram = "ptrace-inject";
        };
      });
}

