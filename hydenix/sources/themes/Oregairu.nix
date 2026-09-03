{ pkgs, mkTheme }:
mkTheme rec {
  name = "Oregairu";
  src = pkgs.fetchFromGitHub {
    owner = "elritardato";
    repo = "Oregairu";
    name = name;
    rev = "4e0e51b3a20d7afb7c0b20bb38b8beb0d7db4de0";
    sha256 = "sha256-fgA0s9k/YfXqbQ28/gJC3BsPyaTutdsytYEzR6iZp3A=";
  };
  meta = {
    description = "HyDE Theme: Oregairu";
    homepage = "https://github.com/elritardato/Oregairu";
  };
}
