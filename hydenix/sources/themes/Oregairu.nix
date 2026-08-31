{ pkgs, mkTheme }:
mkTheme rec {
  name = "Oregairu";
  src = pkgs.fetchFromGitHub {
    owner = "elritardato";
    repo = "Oregairu";
    name = name;
    rev = "f7e4655f4923a3a4e556b3dab688a5fabadf7675";
    sha256 = "sha256-cosU+0wJSaQspcjYEZA5dMoZARz+8vQM+49Vyf2JvA8=";
  };
  meta = {
    description = "HyDE Theme: Oregairu";
    homepage = "https://github.com/elritardato/Oregairu";
  };
}
