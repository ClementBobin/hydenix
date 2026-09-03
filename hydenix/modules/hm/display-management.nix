{ pkgs-unstable, lib, config, ... }:

let
  cfg = config.hydenix.hm.management-utility;
  clientsList = cfg.clients;

  # Map service names to their corresponding packages or list of packages
  clientsToPackage = {
    nwg-displays    = [ pkgs-unstable.nwg-displays ];
    wdisplays = [ pkgs-unstable.wdisplays ];
  };

  # Flatten the list of packages from all enabled clients
  packagesToInstall = lib.unique (lib.concatMap (s: clientsToPackage.${s}) clientsList);
in
{
  options.hydenix.hm.management-utility = {
    clients = lib.mkOption {
      type = lib.types.listOf (lib.types.enum (lib.attrNames clientsToPackage));
      default = [ ];
      description = "List of display management utilities to enable";
    };
  };

  config = {
    home.packages = packagesToInstall;
  };
}
