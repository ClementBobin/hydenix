{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.hydenix.spotify;

  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};

  # Map document clients to their packages
  clientsToPackage = with pkgs; {
    spicetify = null;
    spotify = spotify;
  };

  # Get packages for enabled clients
  enabledPackages = lib.filter (pkg: pkg != null)
    (map (c: clientsToPackage.${c}) cfg.clients);
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.spicetify
  ];

  options.modules.hydenix.spotify = {
    clients = lib.mkOption {
      type = lib.types.listOf (lib.types.enum (lib.attrNames clientsToPackage));
      default = [];
      description = "List of spotify clients to install";
    };

    spicetify = {
      extensions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "shuffle"
          "autoSkipExplicit"
          "autoVolume"
          "adblock"
          "coverAmbience"
        ];
        description = "List of Spicetify extension names to enable.";
      };
      apps = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "marketplace"
          "ncsVisualizer"
        ];
        description = "List of Spicetify apps to enable.";
      };
      theme = lib.mkOption {
        type = lib.types.str;
        default = "text";
        description = "Spicetify theme to use.";
      };
      colorScheme = lib.mkOption {
        type = lib.types.str;
        default = "Spotify";
        description = "Spicetify color scheme to use.";
      };
    };
  };

  config = lib.mkIf (cfg.clients != []) {
    home = {
        packages = finalPackages;
        file = {
            ".config/spotify-flags.conf" = lib.mkIf (lib.elem "spotify" cfg.clients) {
                source = "${pkgs.hyde}/Configs/.config/spotify-flags.conf";
            };
            ".config/electron-flags.conf" = {
                source = "${pkgs.hyde}/Configs/.config/electron-flags.conf";
            };
        };
    };

    # Configure mpv media player if it's in the clients list
    programs = {
      spicetify = lib.mkIf (lib.elem "spicetify" cfg.clients) {
        enable = true;
        enabledExtensions = with spicePkgs.extensions; [
          # Convert extension names to actual extension paths/derivations
        ] ++ (map (ext: spicePkgs.extensions.${ext}) cfg.spicetify.extensions);
        theme = spicePkgs.themes.${cfg.spicetify.theme};
        colorScheme = cfg.spicetify.colorScheme;
        enabledCustomApps = with spicePkgs.apps; [
          # Convert app names to actual app paths/derivations
        ] ++ (map (app: spicePkgs.apps.${app}) cfg.spicetify.apps);
      };
    };
  };
}