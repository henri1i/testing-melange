{ pkgs, ocamlPackages, nix-filter }:
with ocamlPackages; buildDunePackage {
  pname = "minimal-melange";
  version = "0.0.0-dev";
  
  src = with nix-filter.lib;
    filter {
      root = ./../.;
      include = [
        "dune-project"
        "src"
      ];
    };

  propagateBuildInputs = [
    reason
  ];
}
