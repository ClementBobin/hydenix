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
  config = lib.mkIf (cfg.enable) {
    home.file = {
      ".local/share/hypr/lua/key_binds.lua" =
        if cfg.keybindings.overrideConfig != null then
          {
            text = cfg.keybindings.overrideConfig;
            force = true;
          }
        else
          {
            text = ''
              ${lib.readFile "${pkgs.hyde}/Configs/.local/share/hypr/lua/key_binds.lua"}

              hl.input({
                  kb_layout = "${lib.concatStringsSep "," cfg.kb_layout}"
              })

              ${cfg.keybindings.extraConfig}
            '';
            force = true;
          };
    };
  };
}
