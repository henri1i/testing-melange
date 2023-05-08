{
  description = "A Minimal Melange Project";

  inputs = {
    nixpkgs.url = "github:anmonteiro/nix-overlays";
    nix-filter.url = "github:numtide/nix-filter";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nix-filter, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (nixpkgs.makePkgs { 
          inherit system; 
        }).extend (self: super: {
          ocamlPackages = super.ocaml-ng.ocamlPackages_4_14;
        });
        project = pkgs.callPackage ./nix/project.nix {
          inherit nix-filter;
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
