{ stdenv, fetchurl, ocaml, ppxlib }:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.verison}-melange";
  version = "0.3.2";
  
  src = fetchurl {
    url = "https://github.com/melange-re/melange/releases/download/${version}/melange-${version}.tbz";
    sha256 = "";
  };
  
  strictDeps = true;
  nativeBuildInputs = [
    ocaml
    ppxlib
  ];

  propagatedBuildInputs = [
    
  ];
}

