{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hydenix.sddm;

  # Helper function to find a theme package by name, returns null if not found
  findThemeByName = themeName: pkgs.hydenix-sddm-theme.${themeName} or null;

  # Filter out themes that don't have corresponding packages
  activeThemePkg = findThemeByName cfg.theme;
in
{
  options.hydenix.sddm = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable sddm module";
    };

    theme = lib.mkOption {
      type = lib.types.str;
      default = "sddm-astronaut-theme";
      description = "Active SDDM theme name";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      hyde
      sddm-astronaut
    ] ++ lib.optional (activeThemePkg != null) activeThemePkg;

    # Add this section to ensure cursor theme is properly loaded
    environment.sessionVariables = {
      #XCURSOR_THEME = "Bibata-Modern-Ice";
      XCURSOR_SIZE = "24";
    };

    services.displayManager.sddm = {
      enable = true;
      theme = if activeThemePkg != null
        then "${activeThemePkg}/share/sddm/themes/${cfg.theme}"
        else cfg.theme;
      wayland = {
        enable = true;
      };
      extraPackages = with pkgs.kdePackages; [
        qtsvg
        qtmultimedia
        qtvirtualkeyboard
      ];
      settings = {
        Theme = {
          #CursorTheme = "Bibata-Modern-Ice";
          CursorSize = "24";
        };
        General = {
          # Set default session globally
          DefaultSession = "hyprland.desktop";
        };
        Wayland = {
          EnableHiDPI = true;
        };
      };
    };
  };
}
