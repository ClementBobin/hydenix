{ pkgs, mkTheme }:
mkTheme rec {
  name = "DanDaDan";
  src = pkgs.fetchFromGitHub {
    owner = "aasaaDev";
    repo = "DanDaDan";
    name = name;
    rev = "2453631019b187bee0ba460a3fe58a2316c7a51f";
    sha256 = "sha256-WBg6n6P0F7mxjYp3YuLIT3/GXCusp4PniJ50TpdoNZk=";
  };
  meta = {
    description = "HyDE Theme: DanDaDan";
    homepage = "https://github.com/aasaaDev/DanDaDan";
  };
}
