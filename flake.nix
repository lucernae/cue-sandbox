{
  description = "cue-sandbox";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    devshell.url = "github:numtide/devshell";
  };

  outputs = { self, nixpkgs, flake-utils, devshell, ... }:
    flake-utils.lib.eachDefaultSystem (system: {
      devShell =
        let
          # pkgsOverlay = (final: prev: {
          #   dagger = final.callPackage ./dagger.nix {};
          #   dagger-cue = final.callPackage ./dagger-cue.nix {};
          # });
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ devshell.overlay ];
          };
        in
        pkgs.devshell.mkShell {
          name = "cue-sandbox";
          commands = [
            {
                name = "go";
                package = pkgs.go;
            }
            {
                name = "cue";
                package = pkgs.cue;
            }
            {
                name = "dagger";
                package = pkgs.callPackage ./dagger.nix {};
            }
            {
                name = "dagger-cue";
                package = pkgs.callPackage ./dagger-cue.nix {};
            }
          ];
          packages = with pkgs; [ nixpkgs-fmt ];
          env = [];
        };
    });
}
