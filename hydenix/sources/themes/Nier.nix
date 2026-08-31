{ pkgs, mkTheme }:
mkTheme rec {
  name = "Nier";
  src = pkgs.fetchFromGitHub {
    owner = "saber-88";
    repo = "Nier";
    name = name;
    rev = "4e0e51b3a20d7afb7c0b20bb38b8beb0d7db4de0";
    sha256 = "sha256-cosU+0wJSaQspcjYEZA5dMoZARz+8vQM+49Vyf2JvA8=";
  };
  meta = {
    description = "HyDE Theme: Nier";
    homepage = "https://github.com/saber-88/Nier";
  };
}
