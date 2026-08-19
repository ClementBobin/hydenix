{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hydenix.hm.awww;
in
{
  options.hydenix.hm.swww = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.hydenix.hm.enable;
      description = "Enable awww wallpaper daemon";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (lib.mkIf cfg.enable awww) # wallpaper daemon for wayland
    ];
  };
}
