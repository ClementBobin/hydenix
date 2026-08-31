{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hydenix.hm.hyprland;

  workflowPresets = [
    "01-default"
    "editing"
    "gaming"
    "powersaver"
    "snappy"
  ];
in
{
  config = lib.mkIf (cfg.enable) {
    home.file = lib.mkMerge [
      # All workflow presets (with overrides)
      (lib.listToAttrs (
        map (workflow: {
          name = ".local/share/hypr/lua/workflows/${workflow}.lua";
          value =
            if cfg.workflows.overrides ? ${workflow} then
              {
                text = cfg.workflows.overrides.${workflow};
                force = true;
              }
            else
              {
                source = "${pkgs.hyde}/Configs/.local/share/hypr/lua/workflows/${workflow}.lua";
              };
        }) workflowPresets
      ))

      # Custom workflows (exclude the standard presets)
      (lib.mapAttrs' (name: content: {
        name = ".local/share/hypr/lua/workflows/${name}.lua";
        value = {
          text = content;
          force = true;
        };
      }) (lib.filterAttrs (name: _: !(lib.elem name workflowPresets)) cfg.workflows.overrides))
    ];
  };
}
