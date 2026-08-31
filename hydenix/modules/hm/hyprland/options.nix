{
  config,
  lib,
  ...
}:

let
  cfg = config.hydenix.hm.hyprland;
in
{
  options.hydenix.hm.hyprland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.hydenix.hm.enable;
      description = "Enable hyprland module";
    };
    overrideMain = lib.mkOption {
      type = lib.types.nullOr lib.types.lines;
      default = null;
      description = "Complete override of hyprland.lua";
    };
    suppressWarnings = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Suppress warnings about configuration overrides";
    };

    # Shader configurations
    shaders = {
      overrides = lib.mkOption {
        type = lib.types.attrsOf lib.types.lines;
        default = { };
        description = "Override or add custom shaders";
        example = lib.literalExpression ''
          {
            "my-filter.frag" = '''
              precision mediump float;
              // Custom shader code
            ''';
          }
        '';
      };
    };

    # Workflow configurations
    workflows = {
      overrides = lib.mkOption {
        type = lib.types.attrsOf lib.types.lines;
        default = { };
        description = "Override or add custom workflows";
        example = lib.literalExpression ''
          {
            "my-workflow.conf" = '''
              // Custom workflow configuration
            ''';
          }
        '';
      };
    };

    # Hypridle configurations
    hypridle = {
      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Additional hypridle configuration";
      };
      overrideConfig = lib.mkOption {
        type = lib.types.nullOr lib.types.lines;
        default = null;
        description = "Complete hypridle configuration override";
      };
    };

    # Keybindings configurations
    keybindings = {
      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Additional keybindings configuration";
      };
      overrideConfig = lib.mkOption {
        type = lib.types.nullOr lib.types.lines;
        default = null;
        description = "Complete keybindings configuration override";
      };
    };

    # Window rules configurations
    windowrules = {
      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Additional window rules configuration";
      };
      overrideConfig = lib.mkOption {
        type = lib.types.nullOr lib.types.lines;
        default = null;
        description = "Complete window rules configuration override";
      };
    };
  };
}
