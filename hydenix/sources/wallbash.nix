{ lib, stdenv, pkgs }:

stdenv.mkDerivation {
  pname = "icon-wallbash";
  version = "0.1.0";

  src = pkgs.fetchurl {
    url = "https://github.com/HyDE-Project/HyDE/raw/refs/heads/master/Source/arcs/Icon_Wallbash.tar.gz";
    sha256 = "sha256-W9xW2YKXtKA1jwawZpAUqbqMLQ62TkUtbdmqAJWSZ8g=";
  };

  nativeBuildInputs = with pkgs; [ jdupes ];

  installPhase = ''
    mkdir -p $out/share/icons/Wallbash-Icon
    tar -xzf $src -C $out/share/icons/Wallbash-Icon
    jdupes --recurse $out/share/icons
  '';

  meta = { description = "Icon theme wallbash recolors"; };
}