{
  description = "A Minimal Melange Project";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nix-filter.url = "github:numtide/nix-filter";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nix-filter, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        ocamlPackages = pkgs.ocaml-ng.ocamlPackages_4_14;
        project = pkgs.callPackage ./nix/project.nix {
          inherit nix-filter ocamlPackages;
        };
      in
      {
        packages = { inherit project; };
        devShells.default = pkgs.mkShell {
          inputsFrom = [ project ];
        };
      }
    );
}
