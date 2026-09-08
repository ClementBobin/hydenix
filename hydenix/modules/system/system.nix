{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hydenix.system;
in
{
  options.hydenix.system = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable system module";
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      parallel # Shell tool for executing jobs in parallel
      jq # Command-line JSON processor
      imagemagick # Image manipulation tools
      resvg # SVG rendering library and tools
      envsubst # Environment variable substitution utility
      killall # Process termination utility
      git # distributed version control system
      fzf # command line fuzzy finder
      upower # power management/battery status daemon
      kdePackages.ark # kde file archiver
      trash-cli # cli to manage trash files
      gawk # awk implementation
      coreutils # coreutils implementation
      bash-completion # Add bash-completion package
    ];

    programs.nix-ld.enable = true;

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };

    services = {
      upower.enable = true;
      openssh.enable = true;
      libinput.enable = true;
    };

    programs.zsh.enable = true;

    # For trash-cli to work properly
    services.gvfs.enable = true;
  };
}
