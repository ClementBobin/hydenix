{ lib, stdenv, pkgs }:

stdenv.mkDerivation {
  pname = "bibata-modern-ice";
  version = "2.0.7";

src = pkgs.fetchurl {
    url = "https://github.com/LOSEARDES77/Bibata-Cursor-hyprcursor/releases/download/1.0/hypr_Bibata-Modern-Ice.tar.gz";
    sha256 = "sha256-3ttG6Hnr9TPtvIiIbQrsSodu5iZV4Y62xaKvQmkdLPg=";
  };

  installPhase = ''
    mkdir -p $out/share/icons/Bibata-Modern-Ice
    tar -xzf $src -C $out/share/icons/Bibata-Modern-Ice
  '';

  meta = { description = "Bibata Modern Ice cursor set"; };
}