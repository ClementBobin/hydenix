{ pkgs, mkTheme }:
mkTheme rec {
  name = "Timeless Dream";
  src = pkgs.fetchFromGitHub {
    owner = "Maroc02";
    repo = "Timeless-Dream";
    # locking commit
    rev = "5104d77cb46a3968b5d55c5c864fb722268c5bb5";
    name = name;
    sha256 = "sha256-QZnGiMjuL+rgDm0puTwIexeaL/x6lf6SsZ8/dLWvTf4=";
  };
  meta = {
    name = name;
    description = "HyDE Theme: Timeless Dream";
    homepage = "https://github.com/Maroc02/Timeless-Dream";
  };
}
