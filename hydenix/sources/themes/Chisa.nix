{ pkgs, mkTheme }:
mkTheme rec {
  name = "Chisa";
  src = pkgs.fetchFromGitHub {
    owner = "Frz013";
    repo = "Chisa";
    name = name;
    rev = "8a2ebb72f4b77e4e5f6ca5d3c858d3fff5a0a2bb";
    sha256 = "sha256-cosU+0wJSaQspcjYEZA5dMoZARz+8vQM+49Vyf2JvA8=";
  };
  meta = {
    description = "HyDE Theme: Chisa";
    homepage = "https://github.com/Frz013/Chisa";
  };
}
