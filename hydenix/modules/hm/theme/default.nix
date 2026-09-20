{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hydenix.hm.theme;

  # Helper function to find a theme package by name, returns null if not found
  findThemeByName = themeName: pkgs.hydenix-themes.${themeName} or null;

  # Filter out themes that don't have corresponding packages
  availableThemes = lib.filter (themeName: findThemeByName themeName != null) cfg.themes;

  # Determine the command to run using the absolute home directory path
  themeCommand =
    if cfg.random == "theme" then
      "${config.home.homeDirectory}/.local/bin/random-theme.sh -t"
    else if cfg.random == "wallpaper" then
      "${config.home.homeDirectory}/.local/bin/random-theme.sh -w"
    else if cfg.random == "all" then
      "${config.home.homeDirectory}/.local/bin/random-theme.sh -a"
    else
      "${config.home.homeDirectory}/.local/lib/hyde/theme.switch.sh -s \"${cfg.active}\"";
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

    random = lib.mkOption {
      type = lib.types.enum [
        "none"
        "theme"
        "wallpaper"
        "all"
      ];
      default = "none";
      description = "Choose whether to apply a random theme, wallpaper, or both on activation.";
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

    # Walks through the themes and creates symlinks in the hyde themes directory
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
        (map (theme: {
          ".config/hyde/themes/${theme.name}" = {
            source = "${theme.pkg}/share/hyde/themes/${theme.name}";
            force = true;
            recursive = true;
            mutable = true;
          };
        }) themesList)
        ++ [
          {
            ".local/bin/random-theme.sh" = {
              source = ./random-theme.sh;
              executable = true;
            };
          }
        ]
      );

    # Applies what it can before graphical.target, think of this like a "first content paint"
    home.activation.setTheme = lib.hm.dag.entryAfter [ "mutableGeneration" ] ''
      # Define path with required tools
      export PATH="${
        lib.makeBinPath (
          with pkgs;
          [
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
          ]
        )
      }:$HOME/.local/bin:$PATH"

      # Set up logging
      LOG_FILE="$HOME/.local/state/hyde/theme-switch.log"
      mkdir -p $HOME/.local/state/hyde
      # Clear the log file before writing
      : > "$LOG_FILE"
      chmod 644 $LOG_FILE

      echo "Applying theme configuration (random: ${cfg.random})..." | tee -a "$LOG_FILE"

      export LOG_LEVEL=debug

      # Run the determined theme command
      ${themeCommand} >> "$LOG_FILE" 2>&1

      echo "Theme switch completed. Log saved to $LOG_FILE" | tee -a "$LOG_FILE"
    '';

    # Sets dconf settings correctly
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
        ExecStart = "${config.home.homeDirectory}/.local/lib/hyde/dconf.set.sh";
        Environment = "PATH=${
          lib.makeBinPath (
            with pkgs;
            [
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
            ]
          )
        }:${config.home.homeDirectory}/.local/bin";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    # Reapplies the theme to fix dconf
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
        ExecStart = "${themeCommand} || true";
        Environment = "PATH=${
          lib.makeBinPath (
            with pkgs;
            [
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
            ]
          )
        }:${config.home.homeDirectory}/.local/bin";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

  };
}