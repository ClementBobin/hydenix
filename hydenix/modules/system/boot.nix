{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hydenix.boot;
in
{
  options.hydenix.boot = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.hydenix.enable;
      description = "Enable boot module";
    };

    kernelPackages = lib.mkOption {
      type = lib.types.attrs;
      default = pkgs.linuxPackages_zen;
      description = "Kernel packages to use";
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      kernelPackages = cfg.kernelPackages;
      loader ={
        # systemd-boot configuration
        systemd-boot = {
          enable = true;
          consoleMode = "auto";
          editor = false; # Disable the GRUB editor for security
        };
        efi.canTouchEfiVariables = true;
      };
    };
  };
}
