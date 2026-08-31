{ pkgs, mkTheme }:
mkTheme rec {
  name = "Drawbridge";
  src = pkgs.fetchFromGitHub {
    owner = "aasaaDev";
    repo = "Drawbridge";
    name = name;
    rev = "ef7818a61f2203a85f710ddb53f5a72030eb40ba";
    sha256 = "sha256-cosU+0wJSaQspcjYEZA5dMoZARz+8vQM+49Vyf2JvA8=";
  };
  meta = {
    description = "HyDE Theme: Drawbridge";
    homepage = "https://github.com/aasaaDev/Drawbridge";
  };
}
