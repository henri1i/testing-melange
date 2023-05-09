{
  description = "A Minimal Melange Project";

  inputs = {
    nixpkgs.url = "github:anmonteiro/nix-overlays";
    nix-filter.url = "github:numtide/nix-filter";
    flake-utils.url = "github:numtide/flake-utils";
    dream2nix.url = "github:nix-community/dream2nix";
  };

  outputs = { self, nixpkgs, nix-filter, flake-utils, dream2nix }:
    let
      name = "nectify-web";
      nodejs = 18;
      mkOutputs = pkgs:
       let
        d2n = dream2nix.lib.init { inherit pkgs; config.projectRoot = ./.; };

        fullNode = pkgs."nodejs-${builtins.toString nodejs}_x";
        slimNode = pkgs."nodejs-slim-${builtins.toString nodejs}_x";

        output = d2n.dream2nix-interface.makeOutputs {
          source = ./.;
          settings = [{ subsystem.nodejs = nodejs; }];
        };
        fullPkg = output.packages.default;
        slimPkg = pkgs.stdenv.mkDerivation {
          inherit name;
          unpackPhase = ":";
          
          installPhase = ''
            mkdir $out

            # Copy static files
            # mkdir -p $out/share
            # cp -r ${fullPkg}/lib/node_modules/${name}/_site $out/share/${name}

            # Copy server file
            mkdir -p $out/lib/node_modules
            cp -r ${fullPkg}/node_modules $out/node_modules
          '';

          fixupPhase = ''
            chmod +w $out/lib/node_modules/${name}/_bin
            sed -i -e 's|${fullNode}|${slimNode}|g' $out/lib/node_modules/${name}/_bin/*
          '';

          disallowedReferences = [fullNode pkgs.python3];
        };
      in
      {
        devShells.default = output.devShells.default.overrideAttrs (old: {
          shellHook = ''
            ${old.shellHook} 
            export npm_package_config_server=localhost:8080
          '';
        });

        packages.full = fullPkg;
        packages.default = slimPkg;
      };
    in flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; }; in
      mkOutputs pkgs
    ) // {
      checks = self.packages;
    };
    # in flake-utils.lib.eachDefaultSystem (system:
    #   let
    #     pkgs = (nixpkgs.makePkgs { 
    #       inherit system; 
    #     }).extend (self: super: {
    #       ocamlPackages = super.ocaml-ng.ocamlPackages_5_0;
    #     });

    #     project = pkgs.callPackage ./nix/project.nix {
    #       inherit nix-filter app;
    #     };
    #   in
    #   {
    #     
    #     packages = { inherit project; };
    #     devShells.default = pkgs.mkShell {
    #       inputsFrom = [ project ];
    #     };
    #   }
    # );
}
