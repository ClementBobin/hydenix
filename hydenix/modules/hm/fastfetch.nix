{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hydenix.hm.fastfetch;
in
{
  options.hydenix.hm.fastfetch = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.hydenix.hm.enable;
      description = "Enable fastfetch configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    home.file = {
      ".config/fastfetch" = {
        source = "${pkgs.hyde}/Configs/.config/fastfetch";
        recursive = true;
      };
    };
  };
}
