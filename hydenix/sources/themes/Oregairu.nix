{ pkgs, mkTheme }:
mkTheme rec {
  name = "Oregairu";
  src = pkgs.fetchFromGitHub {
    owner = "elritardato";
    repo = "Oregairu";
    name = name;
    rev = "4e0e51b3a20d7afb7c0b20bb38b8beb0d7db4de0";
    sha256 = "sha256-cosU+0wJSaQspcjYEZA5dMoZARz+8vQM+49Vyf2JvA8=";
  };
  meta = {
    description = "HyDE Theme: Oregairu";
    homepage = "https://github.com/elritardato/Oregairu";
  };
}
