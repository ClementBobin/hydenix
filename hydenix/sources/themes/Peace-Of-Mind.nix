{ pkgs, mkTheme }:
mkTheme rec {
  name = "Peace Of Mind";
  src = pkgs.fetchFromGitHub {
    owner = "Maroc02";
    repo = "Peace-Of-Mind";
    rev = "632fb4a0cba5af9d01b5b35899629565076ca295";
    name = name;
    sha256 = "sha256-9FpH9PvykUHzJOp3NkWeExoM2taesHmVmruUge5xH3M=";
  };
  meta = {
    name = name;
    description = "HyDE Theme: Peace Of Mind";
    homepage = "https://github.com/Maroc02/Peace-Of-Mind";
  };
}
