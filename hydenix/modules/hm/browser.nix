{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.hydenix.hm.browser;

  # Map browsers to their packages (using pkgs.)
  browserToPackage = with pkgs; {
    chrome   = [ google-chrome ];
    firefox  = [ firefox ];
    brave    = [ brave ];
    zen      = [ (inputs.zen-browser.packages.${pkgs.system}.default) ];
    tor      = [ tor-browser ];
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