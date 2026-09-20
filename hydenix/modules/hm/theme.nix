{
  config,
  lib,
  pkgs,
  ...
}:
# TODO: relook
let
  cfg = config.hydenix.hm.theme;

  # Helper function to find a theme package by name, returns null if not found
  findThemeByName = themeName: pkgs.hydenix-themes.${themeName} or null;

  # Filter out themes that don't have corresponding packages
  availableThemes = lib.filter (themeName: findThemeByName themeName != null) cfg.themes;
in
{
  options.hydenix.hm.theme = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.hydenix.hm.enable;
      description = "Enable theme module";
    };

    active = lib.mkOption {
      type = lib.types.str;
      default = "Catppuccin Mocha";
      description = "Active theme name";
    };

    themes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "Catppuccin Mocha"
        "Catppuccin Latte"
      ];
      description = "Available theme names";
    };
  };

  config = lib.mkIf cfg.enable {
    # Create a combined theme package using symlinkJoin with only selected themes
    home.packages = [
      (pkgs.symlinkJoin {
        name = "hydenix-themes";
        paths = lib.filter (p: p != null) (map findThemeByName availableThemes);
        meta = {
          description = "Combined HyDE themes package";
          platforms = pkgs.lib.platforms.all;
        };
      })
    ];

    # walks through the themes and creates symlinks in the hyde themes directory
    home.file =
      let
        # Find the package for each theme name, filtering out missing ones
        themesList = lib.filter (t: t.pkg != null) (
          map (themeName: {
            name = themeName;
            pkg = findThemeByName themeName;
          }) availableThemes
        );
      in
      lib.mkMerge (
        map (theme: {
          ".config/hyde/themes/${theme.name}" = {
            source = "${theme.pkg}/share/hyde/themes/${theme.name}";
            force = true;
            recursive = true;
            mutable = true;
          };
        }) themesList
      );

    # sets dconf settings correctly
    systemd.user.services.setThemeDconf = {
      Unit = {
        Description = "Apply Hyde theme dconf settings";
        After = [
          "graphical-session.target"
          "dbus.service"
        ];
        Wants = [ "dbus.service" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = ''
          ${config.home.homeDirectory}/.local/lib/hyde/dconf.set.sh
        '';
        Path = with pkgs; [
          dconf
          glib
          hyprland
          util-linux
          which
          coreutils
          imagemagick
          gawk
          parallel
          awww
          waybar
          kitty
          dunst
          libnotify
          "${config.home.homeDirectory}/.local/bin"
        ];
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    # reapplies the theme to fix dconf
    systemd.user.services.setTheme = {
      Unit = {
        Description = "Apply Hyde theme settings (full theme switch)";

        Requires = [ "setThemeDconf.service" ];

        After = [
          "graphical-session.target"
          "dbus.service"
          "setThemeDconf.service"
        ];

        Wants = [ "dbus.service" ];

        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = ''
          ${config.home.homeDirectory}/.local/lib/hyde/theme.switch.sh -s "${cfg.active}" || true
        '';
        Path = with pkgs; [
          awww
          killall
          hyprland
          dunst
          libnotify
          systemd
          waybar
          kitty
          gawk
          coreutils
          parallel
          imagemagick
          which
          util-linux
          dconf
          "${config.home.homeDirectory}/.local/bin"
        ];
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

  };
}
