{
  description = "NixOS integration for Google's (unstable) GLOME login mechanism";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

  inputs.glome.url = "github:google/glome";
  inputs.glome.flake = false;

  outputs = { self, flake-utils, glome, nixpkgs }: {
    overlay = (final: prev: {
      glome = prev.callPackage ./pkgs/glome.nix { glome-src = glome; };
    });

    nixosModules.glome = import ./nixos/glome.nix;
    nixosModules.default = self.nixosModules.glome;
  } // (flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ self.overlay ];
      };
    in rec {
      packages.glome = pkgs.glome;
      defaultPackage = pkgs.glome;
    }
  ));
}
