{ pkgs, mkTheme }:
mkTheme rec {
  name = "Crimson-Blue";
  src = pkgs.fetchFromGitHub {
    owner = "amit-0i";
    repo = "Crimson-Blue";
    rev = "ee6da6ffe1d8e2a14d1ee993ea1e5074f3158c44";
    name = name;
    sha256 = "sha256-MP2uTpH0rayCwHM2gWIaCbB0tARbMKLY9CUAZXPkM4U=";
  };
  meta = {
    name = name;
    description = "HyDE Theme: Crimson-Blue";
    homepage = "https://github.com/amit-0i/Crimson-Blue";
  };
}
