{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hydenix.hm.lockscreen;
in
{
  options.hydenix.hm.lockscreen = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.hydenix.hm.enable;
      description = "Enable lockscreen module";
    };

    hyprlock = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable hyprlock lockscreen";
    };

    swaylock = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable swaylock lockscreen";
    };

    kb_layout = lib.mkOption {
      type = lib.types.str;
      default = "us";
      description = "Keyboard layout(s) for the lockscreen input.";
      example = "fr";
    };

    theme = lib.mkOption {
      type = lib.types.enum [
        "HyDE"
        "Anurati"
        "Arfan on Clouds"
        "IBM Plex"
        "IMB Xtented"
        "SF Pro"
        "greetd"
        "greetd-wallbash"
      ];
      default = "HyDE";
      description = "Hyprlock theme to use.";
      example = "SF Pro";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (lib.mkIf cfg.hyprlock hyprlock)
      (lib.mkIf cfg.swaylock swaylock)
    ];

    home.file = lib.mkMerge [
      # Hyprlock configs
      (lib.mkIf cfg.hyprlock {
        ".config/hypr/hyprlock.conf" = {
          # Append kb_layout to the upstream hyprlock.conf
          text = ''
            ${lib.readFile "${pkgs.hyde}/Configs/.config/hypr/hyprlock.conf"}

            input {
                kb_layout = ${cfg.kb_layout}
            }
          '';
          force = true;
        };
        ".config/hypr/hyprlock/" = {
          source = "${pkgs.hyde}/Configs/.config/hypr/hyprlock/";
          recursive = true;
          mutable = true;
          force = true;
        };
        ".config/hypr/hyprlock/theme.conf" = {
          text = ''
            source = ./${cfg.theme}.conf
          '';
          force = true;
          mutable = true;
        };
      })

      # Swaylock config
      (lib.mkIf cfg.swaylock {
        ".config/swaylock/config" = {
          # Swaylock uses a key=value flat format
          text = ''
            ${lib.readFile "${pkgs.hyde}/Configs/.config/swaylock/config"}

            xkb-layout=${cfg.kb_layout}
          '';
          force = true;
        };
      })
    ];
  };
}
