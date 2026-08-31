{ pkgs }:
let
  mkSddmTheme = import ./utils/mkSddmTheme.nix { inherit pkgs; };
  # Helper function to call each theme file with pkgs and mkSddmTheme
  callTheme = file: import file { inherit pkgs mkSddmTheme; };
in
{
  "Agency" = callTheme ./Agency.nix;
  "sddm-astronaut-theme" = pkgs.sddm-astronaut;
}
