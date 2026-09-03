{
  description = "Nix & home-manager configuration for HyDE, an Arch Linux based Hyprland desktop";

  inputs = {
    # Hydenix's nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/release-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Nix-index-database - for comma and command-not-found
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyde = {
      url = "github:HyDE-Project/HyDE/v26.08.21";
      flake = false;
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # HyDE related binaries
    hyq = {
      url = "github:ClementBobin/hyprquery";
    };
    hydectl = {
      url = "github:ClementBobin/hydectl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hyde-ipc = {
    #   url = "github:richen604/hyde-ipc";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # }
    # # TODO: don't know if still needed, but keeping for now
    # hyde-config = {
    #   url = "github:richen604/hyde-config";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };
  outputs =
    { ... }@inputs:
    let
      system = "x86_64-linux";

      defaultConfig = import ./lib/config {
        inherit inputs;
      };

      # Create VM variant of the NixOS configuration
      vmConfig = import ./lib/vms/nixos-vm.nix {
        inherit inputs;
        nixosConfiguration = defaultConfig;
      };

      demoVmConfig = import ./lib/vms/demo-vm.nix {
        inherit inputs;
      };
    in
    {

      lib.vmConfig = import ./lib/vms/nixos-vm.nix;

      # Direct module access
      homeModules.default = import ./hydenix/modules/hm;
      nixosModules.default = import ./hydenix/modules/system;

      overlays.default = import ./hydenix/sources/overlay.nix { inherit inputs; };

      templates.default = {
        path = ./template;
        description = "Template for hydenix configuration";
      };

      nixosConfigurations.default = defaultConfig;

      packages.${system} = {
        # Use the VM configuration as default
        default = vmConfig.config.system.build.vm;

        # Helper to manage hyde updates
        hyde-update = import ./lib/hyde-update { inherit inputs; };

        # Add hyq, hydectl, hyde-ipc, and hyde-config for building
        hyq = inputs.hyq.packages.${system}.default;
        hydectl = inputs.hydectl.packages.${system}.default;
        #hyde-config = inputs.hyde-config.packages.${system}.default;
        # hyde-ipc = inputs.hyde-ipc.packages.${system}.default;
      };

      checks.${system} = {
        hyq = inputs.self.packages.${system}.hyq;
        hydectl = inputs.self.packages.${system}.hydectl;
        #hyde-config = inputs.self.packages.${system}.hyde-config;
        #FIXME: hyde-ipc has 2gb of build dependencies, so disable for now to prevent gh actions timeouts
        # hyde-ipc = inputs.self.packages.${system}.hyde-ipc;
      };

      devShells.${system}.default = import ./lib/dev-shell.nix { inherit inputs; };
    };
}
