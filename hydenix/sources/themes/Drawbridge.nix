{ pkgs, mkTheme }:
mkTheme rec {
  name = "Drawbridge";
  src = pkgs.fetchFromGitHub {
    owner = "aasaaDev";
    repo = "Drawbridge";
    name = name;
    rev = "ef7818a61f2203a85f710ddb53f5a72030eb40ba";
    sha256 = "sha256-lqmH4bYiuG2hdaUt4lI/WPBossrPQwplnBBiAgCRO7A=";
  };
  meta = {
    description = "HyDE Theme: Drawbridge";
    homepage = "https://github.com/aasaaDev/Drawbridge";
  };
}
