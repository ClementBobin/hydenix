{ pkgs, mkTheme }:
mkTheme rec {
  name = "Breezy Autumn";
  src = pkgs.fetchFromGitHub {
    owner = "Maroc02";
    repo = "Breezy-Autumn";
    # locking commit
    rev = "959294bf8bc67d2fcb5e419047c949a8500f8e18";
    name = name;
    sha256 = "sha256-PmjM1YRggJw2NUEAspswWgI1J91EicvzZvnno1GW2bk=";
  };
  meta = {
    name = name;
    description = "HyDE Theme: Breezy Autumn";
    homepage = "https://github.com/Maroc02/Breezy-Autumn";
  };
}
