{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hydenix.hm.hyprland;
in
{
  config = lib.mkIf (cfg.enable && cfg.windowrules.enable) {
    home.file = {
      ".local/share/hypr/lua/window_rules.lua" =
        if cfg.windowrules.overrideConfig != null then
          {
            text = cfg.windowrules.overrideConfig;
            force = true;
          }
        else
          {
            text = ''
              ${lib.readFile "${pkgs.hyde}/Configs/.local/share/hypr/lua/window_rules.lua"}
              ${cfg.windowrules.extraConfig}
            '';
            force = true;
          };
    };
  };
}
