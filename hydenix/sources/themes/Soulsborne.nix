{ pkgs, mkTheme }:
mkTheme rec {
  name = "Soulsborne";
  src = pkgs.fetchFromGitHub {
    owner = "elritardato";
    repo = "Soulsborne";
    name = name;
    rev = "8c2da9685326e849cdab07f6b74ae177d1205d5e";
    sha256 = "sha256-g9ol9HAJY05Fy2Bxr4fqa7iIJvATfn39KD4XoHQwQ+Q=";
  };
  meta = {
    description = "HyDE Theme: Soulsborne";
    homepage = "https://github.com/elritardato/Soulsborne";
  };
}
