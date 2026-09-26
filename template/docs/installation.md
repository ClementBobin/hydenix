<img align="right" width="75px" alt="NixOS" src="https://github.com/HyDE-Project/HyDE/blob/master/Source/assets/nixos.png?raw=true"/>

# installation

> [!CAUTION]
> the template flake is designed for a **minimal install of NixOS**. install NixOS first, then follow the steps below.

## 1. initialise the flake template

```bash
mkdir hydenix && cd hydenix
nix flake init -t github:ClementBobin/hydenix
```

this copies the template into your current directory. you will find:

```
.
├── configuration.nix        # NixOS system config — edit this first
├── flake.nix                # flake inputs and outputs
├── hardware-configuration.nix  # generated in step 3
└── modules/
    └── hm/
        └── default.nix      # home-manager config — hydenix.hm.* options go here
```

## 2. configure your system

open `configuration.nix` and set at minimum:

```nix
hydenix = {
  enable   = true;
  hostname = "my-machine";   # your hostname
  timezone = "Europe/Paris"; # your timezone
  locale   = "fr_FR.UTF-8"; # your locale
};
```

then open `modules/hm/default.nix` and enable home-manager:

```nix
hydenix.hm.enable = true;
```

see [module options](./options.md) for the full list of available options and examples.

## 3. generate hardware configuration

```bash
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
```

## 4. initialise a git repository

```bash
git init && git add .
```

flakes require all files to be tracked by git. this is also good practice for version-controlling your configuration.

## 5. build and switch

```bash
sudo nixos-rebuild switch --flake .#hydenix
```

> [!NOTE]
> if the build fails, read the error carefully — it usually tells you exactly what is wrong. also see:
>
> - [troubleshooting](./troubleshooting.md)
> - [faq](./faq.md)
> - [discord](https://discord.gg/AYbJ9MJez7) or [github discussions](https://github.com/ClementBobin/hydenix/discussions)

## 6. reboot and log in

reboot your machine, log in through SDDM, and you are running hydenix.

> [!IMPORTANT]
> if this is a fresh NixOS install, set your user password before logging out:
>
> ```bash
> passwd
> ```

once logged in, regenerate the theme cache:

```bash
hyde-shell reload
```
