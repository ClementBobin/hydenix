{ pkgs, mkTheme }:
mkTheme rec {
  name = "DanDaDan";
  src = pkgs.fetchFromGitHub {
    owner = "aasaaDev";
    repo = "DanDaDan";
    name = name;
    rev = "2453631019b187bee0ba460a3fe58a2316c7a51f";
    sha256 = "sha256-cosU+0wJSaQspcjYEZA5dMoZARz+8vQM+49Vyf2JvA8=";
  };
  meta = {
    description = "HyDE Theme: DanDaDan";
    homepage = "https://github.com/aasaaDev/DanDaDan";
  };
}
