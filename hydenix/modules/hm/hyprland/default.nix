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
  imports = [
    ./assertions.nix
    ./hypridle.nix
    ./options.nix
    ./shaders.nix
    ./workflows.nix
  ];

  config = lib.mkIf cfg.enable {
    # Always include packages and base setup
    home.packages = [
      pkgs.hyprutils
      pkgs.hyprpicker
      pkgs.hyprcursor
      pkgs.lua
    ];

    home.activation.createHyprConfigs = lib.hm.dag.entryAfter [ "mutableGeneration" ] ''
      mkdir -p "$HOME/.config/hypr/themes"
      mkdir -p "$HOME/.config/hypr/shaders"
      mkdir -p "$HOME/.config/hypr/workflows"

      touch "$HOME/.config/hypr/themes/colors.conf"
      touch "$HOME/.config/hypr/themes/theme.conf"
      touch "$HOME/.config/hypr/themes/wallbash.conf"

      chmod 644 "$HOME/.config/hypr/themes/colors.conf"
      chmod 644 "$HOME/.config/hypr/themes/theme.conf"
      chmod 644 "$HOME/.config/hypr/themes/wallbash.conf"

    '';

    home.file = {
      ".local/share/hypr/" = {
        source = "${pkgs.hyde}/Configs/.local/share/hypr/";
        recursive = true;
        force = true;
      };
      ".config/hypr/" = {
        source = "${pkgs.hyde}/Configs/.config/hypr/";
        recursive = true;
        force = true;
      };
      ".config/hypr/hyprland.lua" = {
        text = ''
          ${lib.readFile "${pkgs.hyde}/Configs/.config/hypr/hyprland.lua"}

          ${cfg.extraConfig}
        '';
        mutable = true;
        force = true;
      };
    };
  };
}
