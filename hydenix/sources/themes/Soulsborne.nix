{ pkgs, mkTheme }:
mkTheme rec {
  name = "Soulsborne";
  src = pkgs.fetchFromGitHub {
    owner = "elritardato";
    repo = "Soulsborne";
    name = name;
    rev = "8c2da9685326e849cdab07f6b74ae177d1205d5e";
    sha256 = "sha256-cosU+0wJSaQspcjYEZA5dMoZARz+8vQM+49Vyf2JvA8=";
  };
  meta = {
    description = "HyDE Theme: Soulsborne";
    homepage = "https://github.com/elritardato/Soulsborne";
  };
}
