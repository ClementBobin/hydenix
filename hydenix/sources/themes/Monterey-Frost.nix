{ pkgs, mkTheme }:
mkTheme rec {
  name = "Monterey Frost";
  src = pkgs.fetchFromGitHub {
    owner = "rishav12s";
    repo = "Monterey-Frost";
    rev = "559edd928d63183c8269052f4739b3d07dca9091";
    name = name;
    sha256 = "sha256-ECG7wyIa0RdZteTEdQjpVjhbf62XXz0rW3Ea494461E=";
  };
  meta = {
    description = "Mac-OS inspired dark theme";
    homepage = "https://github.com/rishav12s/Monterey-Frost";
  };
}
