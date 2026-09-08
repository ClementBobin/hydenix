{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hydenix.hyprland;
in
{
  options.hydenix.hyprland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable system module";
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      libnotify # Desktop notification library
      wl-clipboard # Wayland clipboard utilities
      wl-clip-persist # Keep Wayland clipboard even after programs close (avoids crashes)
      gnumake # Build automation tool
      polkit_gnome # authentication agent for privilege escalation
      dbus # inter-process communication daemon
      mesa # OpenGL implementation and GPU drivers
      dconf # configuration storage system
      dconf-editor # dconf editor
      xdg-utils # Collection of XDG desktop integration tools
      desktop-file-utils # for updating desktop database
      hicolor-icon-theme # Base fallback icon theme
      cava # audio visualizer
      cliphist # clipboard manager
      wayland # for wayland support
      egl-wayland # for wayland support
      xwayland # for x11 support
      gobject-introspection # for python packages

      hypridle
    ];

    environment.variables = {
      NIXOS_OZONE_WL = "1";
    };

    programs.hyprland = {
      package = pkgs.hyprland;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
      enable = true;
      withUWSM = true;
    };

    services.dbus.enable = true;
    programs.dconf.enable = true;
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # For polkit authentication
    security.polkit.enable = true;
    security.pam.services.swaylock = { };
    security.rtkit.enable = true;
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
    
    # For proper XDG desktop integration
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

  };
}
