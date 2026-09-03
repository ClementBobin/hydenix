{
  lib,
  ...
}:
{
  imports = [
    ./mutable.nix
    ./comma.nix
    ./display-management.nix
    ./dolphin.nix
    ./editors.nix
    ./fastfetch.nix
    ./firefox.nix
    ./gtk.nix
    ./git.nix
    ./hyde.nix
    ./hyprland
    ./lockscreen.nix
    ./notifications.nix
    ./qt.nix
    ./rofi.nix
    ./screenshots.nix
    ./shell.nix
    ./social.nix
    ./awww.nix
    ./terminals.nix
    ./theme.nix
    ./uwsm.nix
    ./waybar.nix
    ./wlogout.nix
    ./xdg.nix
  ];

  options.hydenix.hm = {
    enable = lib.mkEnableOption "Enable Hydenix home-manager modules globally";
  };

  config = {
    hydenix.hm.enable = lib.mkDefault false;

    # let home-manager control itself
    programs.home-manager.enable = true;

    home.stateVersion = "26.05";
  };

}
