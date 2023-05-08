{ pkgs, ocamlPackages, nix-filter }:
with ocamlPackages; buildDunePackage rec {
  pname = "minimal-melange";
  version = "0.0.0-dev";
  
  src = with nix-filter.lib;
    filter {
      root = ./../.;
      iniclude = [
        "dune-project"
        "src"
      ];
    };

  propagateBuildInputs = [
    melange 
    reason_react 
  ];
}
