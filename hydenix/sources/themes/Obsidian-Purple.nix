{ pkgs, mkTheme }:
mkTheme rec {
  name = "Obsidian-Purple";
  src = pkgs.fetchFromGitHub {
    owner = "amit-0i";
    repo = "Obsidian-Purple";
    rev = "b73f00b1202f9891473572f038fa52efaa622951";
    name = name;
    sha256 = "sha256-wmply5k/FP1QKobCp+ZeaCzdHIlURAxdur3xXAF7qD0=";
  };
  meta = {
    name = name;
    description = "HyDE Theme: Obsidian-Purple";
    homepage = "https://github.com/amit-0i/Obsidian-Purple";
  };
}
