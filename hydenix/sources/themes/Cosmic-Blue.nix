{ pkgs, mkTheme }:
mkTheme rec {
  name = "Cosmic Blue";
  src = pkgs.fetchFromGitHub {
    owner = "Maroc02";
    repo = "Cosmic-Blue";
    rev = "ad8a9a50684f9ab6dbd29cd98b6c2a3f457347f3";
    name = name;
    sha256 = "sha256-ed9QxS4onniN+kABewK9kBRu9xFMvHU6em+QcP2GrFM=";
  };
  meta = {
    description = "HyDE Theme: Cosmic Blue";
    homepage = "https://github.com/Maroc02/Cosmic-Blue";
  };
}
