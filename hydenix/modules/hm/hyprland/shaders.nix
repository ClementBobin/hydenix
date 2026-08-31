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
    home.file = lib.mkMerge [
      # Standard shaders (generated from list)
      (lib.mkMerge [
        # Additional shader files
        {
          ".config/hypr/shaders/.compiled.cache.glsl" = {
            source = "${pkgs.hyde}/Configs/.config/hypr/shaders/.compiled.cache.glsl";
            force = true;
            mutable = true;
          };
        }
      ])

      # Custom/override shaders
      (lib.mapAttrs' (name: content: {
        name = ".config/hypr/shaders/${name}";
        value = {
          text = content;
          force = true;
        };
      }) cfg.shaders.overrides)
    ];
  };
}