{ pkgs, mkTheme }:
mkTheme rec {
  name = "CIA";
  src = pkgs.fetchFromGitHub {
    owner = "CapGuizera";
    repo = "hyde-agency-themes";
    name = name;
    rev = "542e35d68a392b2a72cf0bd4ba496cc4093c817d";
    sha256 = "sha256-ODdhmBcJxK2evgwXGoWdiBrbXChWLWFwgGdeFaM6YrY=";
  };
  meta = {
    description = "HyDE Theme: CIA";
    homepage = "https://github.com/CapGuizera/hyde-agency-themes";
  };
}
