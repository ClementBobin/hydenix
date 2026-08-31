{ pkgs, mkTheme }:
mkTheme rec {
  name = "MI6";
  src = pkgs.fetchFromGitHub {
    owner = "CapGuizera";
    repo = "hyde-agency-themes";
    name = name;
    rev = "542e35d68a392b2a72cf0bd4ba496cc4093c817d";
    sha256 = "sha256-cosU+0wJSaQspcjYEZA5dMoZARz+8vQM+49Vyf2JvA8=";
  };
  meta = {
    description = "HyDE Theme: MI6";
    homepage = "https://github.com/CapGuizera/hyde-agency-themes";
  };
}
