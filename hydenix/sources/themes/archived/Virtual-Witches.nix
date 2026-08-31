{ pkgs, mkTheme }:
mkTheme rec {
  name = "Virtual-Witches";
  src = pkgs.fetchFromGitHub {
    owner = "G00380316";
    repo = "Virtual-Witches";
    name = name;
    rev = "f7e4655f4923a3a4e556b3dab688a5fabadf7675";
    sha256 = "sha256-cosU+0wJSaQspcjYEZA5dMoZARz+8vQM+49Vyf2JvA8=";
  };
  meta = {
    description = "HyDE Theme: Virtual-Witches";
    homepage = "https://github.com/G00380316/Virtual-Witches";
  };
}
