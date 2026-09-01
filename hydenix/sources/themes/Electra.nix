{ pkgs, mkTheme }:
mkTheme rec {
  name = "Electra";
  src = pkgs.fetchFromGitHub {
    owner = "XBEAST1";
    repo = "Electra";
    rev = "953676ce3962b0ce2bf8bf06c67584f325183e4a";
    name = name;
    sha256 = "sha256-PG2Vud9BTMuOkT2dHYNl1sDdTFsMLugc5qfWWs/fYFE=";
  };
  meta = {
    name = name;
    description = "HyDE Theme: Electra";
    homepage = "https://github.com/XBEAST1/Electra";
  };
}
