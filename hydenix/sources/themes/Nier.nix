{ pkgs, mkTheme }:
mkTheme rec {
  name = "Nier";
  src = pkgs.fetchFromGitHub {
    owner = "saber-88";
    repo = "Nier";
    name = name;
    rev = "bf5b0ac8b778066b781ecf55db46a95af23ed06c";
    sha256 = "sha256-cosU+0wJSaQspcjYEZA5dMoZARz+8vQM+49Vyf2JvA8=";
  };
  meta = {
    description = "HyDE Theme: Nier";
    homepage = "https://github.com/saber-88/Nier";
  };
}
