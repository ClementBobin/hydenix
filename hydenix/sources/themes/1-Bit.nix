{ pkgs, mkTheme }:
mkTheme rec {
  name = "1-Bit";
  src = pkgs.fetchFromGitHub {
    owner = "amit-0i";
    repo = "1-Bit";
    # locking commit
    rev = "84b2f94e8a340d324deaf293449e5508553eb128";
    name = name;
    sha256 = "sha256-dYRZKGHO0Q8x4h80Q+PrajaPaY/ZJHZgnp3QVI5d0Lc=";
  };
  meta = {
    name = name;
    description = "HyDE Theme: 1-Bit";
    homepage = "https://github.com/amit-0i/1-Bit";
  };
}
