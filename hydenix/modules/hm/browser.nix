{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.hydenix.hm.browser;

  # Handles both local build and template flake inputs path for zen-browser
  zenInput = if inputs ? zen-browser then inputs.zen-browser else inputs.hydenix.inputs.zen-browser;

  # Map browsers to their packages (using pkgs or zenInput packages)
  browserToPackage = with pkgs; {
    chrome   = [ google-chrome ];
    firefox  = [ firefox ];
    brave    = [ brave ];
    zen      = [ zenInput.packages.${pkgs.stdenv.system}.default ]; # Pulls zen from zen-browser input
  };

  # Get packages for enabled browsers
  browserPackages = lib.concatMap (browser: browserToPackage.${browser} or []) cfg.clients;

in
{
  options.hydenix.hm.browser = {
    clients = lib.mkOption {
      type = lib.types.listOf (lib.types.enum (lib.attrNames browserToPackage));
      default = [];
    };
  };

  config = {
    home = {
      packages = lib.unique (browserPackages);

      sessionVariables = {
        MOZ_ENABLE_WAYLAND = "1";
      };
    };
  };
}