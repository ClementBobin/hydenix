<img align="right" width="75px" alt="NixOS" src="https://github.com/HyDE-Project/HyDE/blob/master/Source/assets/nixos.png?raw=true"/>

# faq

- [general](#general)
  - [why should I use NixOS?](#why-should-i-use-nixos)
  - [how do I learn more about nix?](#how-do-i-learn-more-about-nix)
- [hydenix](#hydenix)
  - [what are the module options?](#what-are-the-module-options)
  - [what if I want to customise hydenix?](#what-if-i-want-to-customise-hydenix)
  - [how do I persist changes across rebuilds?](#how-do-i-persist-changes-across-rebuilds)
  - [how do I add a new theme?](#how-do-i-add-a-new-theme)
  - [why do themes still appear after I remove them?](#why-do-themes-still-appear-after-i-remove-them)
  - [what is mutable.nix?](#what-is-mutablenix)
  - [common errors](#common-errors)
  - [requesting features](#requesting-features)
  - [what are some example configurations?](#what-are-some-example-configurations)
- [other](#other)
  - [how do I run hyprland in a vm?](#how-do-i-run-hyprland-in-a-vm)

---

## general

### why should I use NixOS?

NixOS offers several key advantages:

1. **reproducible setups** — roll back to a working state instantly if something breaks.
2. **configuration as code** — version-control your entire OS setup with git.
3. **no dependency hell** — packages are isolated; multiple versions can coexist.
4. **declarative approach** — describe the desired state, not the steps to get there.
5. **risk-free experimentation** — test configurations without permanent consequences.
6. **developer-friendly** — spin up isolated environments with precise dependencies.

there is a learning curve, but the benefits compound over time.

<div align="right"><a href="#faq"><img src="https://img.shields.io/badge/Back_to_Top-↑-blue" alt="Back to Top"/></a></div>

### how do I learn more about nix?

> [!TIP]
> nix can feel overwhelming at first. these resources are a great starting point:

- [nix packages search](https://search.nixos.org/packages)
- [nixos options search](https://search.nixos.org/options)
- [home-manager options](https://home-manager-options.extranix.com/?query=&release=master)
- [nixos wiki](https://nixos.wiki)
- [nixpkgs discourse](https://discourse.nixos.org)
- [nixpkgs issues](https://github.com/NixOS/nixpkgs/issues)

<div align="right"><a href="#faq"><img src="https://img.shields.io/badge/Back_to_Top-↑-blue" alt="Back to Top"/></a></div>

---

## hydenix

### what are the module options?

see [options.md](./options.md) for the full list of `hydenix.*` and `hydenix.hm.*` options, with types, defaults, and examples.

<div align="right"><a href="#faq"><img src="https://img.shields.io/badge/Back_to_Top-↑-blue" alt="Back to Top"/></a></div>

### what if I want to customise hydenix?

hydenix is designed to be extended. you can:

- **use module options** — most behaviour is controllable via `hydenix.*` and `hydenix.hm.*` options (see [options.md](./options.md)).
- **use `extraConfig`** — for hyprland, kitty, shell, and waybar, append raw config via the `extraConfig` / `configText` / `userStyle` options.
- **disable a module and write your own** — set `hydenix.hm.<module>.enable = false` and add your own NixOS/home-manager config alongside it.
- **import your own modules and flakes** — add inputs to `flake.nix` and import them in `configuration.nix` or `modules/hm/default.nix`.

> [!NOTE]
> overriding module internals can cause subtle breakage. ask in [discord](https://discord.gg/AYbJ9MJez7) if you're unsure.

<div align="right"><a href="#faq"><img src="https://img.shields.io/badge/Back_to_Top-↑-blue" alt="Back to Top"/></a></div>

### how do I persist changes across rebuilds?

> [!IMPORTANT]
> do not edit mutable runtime files directly — they may be overwritten on the next rebuild.\
> all persistent changes must live in your flake.

**themes** — if you switch themes at runtime (e.g. with `Meta + Shift + T`), update your flake to make it permanent:

```nix
hydenix.hm.theme.active = "Tokyo-Night";
```

**other runtime files** — use `home.file` in `modules/hm/default.nix` to pin any file from your flake:

```nix
home.file = {
  # pin kitty config
  # cp ~/.config/kitty/kitty.conf ~/path/to/flake/kitty.conf
  ".config/kitty/kitty.conf".source = ./kitty.conf;

  # pin waybar layout state
  # cp ~/.config/waybar/config.ctl ~/path/to/flake/config.ctl
  ".config/waybar/config.ctl".source = ./config.ctl;
};
```

see [home.file options](https://home-manager-options.extranix.com/?query=home.file&release=master) for more.

<div align="right"><a href="#faq"><img src="https://img.shields.io/badge/Back_to_Top-↑-blue" alt="Back to Top"/></a></div>

### how do I add a new theme?

themes must exist in [`hydenix/sources/themes/`](https://github.com/ClementBobin/hydenix/tree/dev/hydenix/sources/themes). to add your own:

1. open a PR to add a `.nix` file for your theme to that directory.
2. once merged, add the theme name to `hydenix.hm.theme.themes` in your config.

<!-- TODO: link to a full theme contribution guide once it exists -->

<div align="right"><a href="#faq"><img src="https://img.shields.io/badge/Back_to_Top-↑-blue" alt="Back to Top"/></a></div>

### why do themes still appear after I remove them?

themes are installed to `~/.config/hyde/themes/` at activation time and are not automatically removed when you drop them from `hydenix.hm.theme.themes`. to clean them up manually:

```bash
rm -rf ~/.config/hyde/themes/THEME_NAME
```

<div align="right"><a href="#faq"><img src="https://img.shields.io/badge/Back_to_Top-↑-blue" alt="Back to Top"/></a></div>

### what is mutable.nix?

`mutable.nix` is a custom home-manager module that extends `home.file`, `xdg.configFile`, and `xdg.dataFile` with a `mutable` option. files marked `mutable = true` are **copied** rather than symlinked, making them writable at runtime (e.g. for HyDE's theme switcher, wallbash, etc.).

key points:
- mutable files can be changed at runtime by HyDE scripts.
- they are re-copied from the store on each rebuild, so runtime changes are not permanent (see [how do I persist changes](#how-do-i-persist-changes-across-rebuilds)).
- use `home.activation` with `lib.hm.dag.entryAfter [ "mutableGeneration" ]` to run scripts after mutable files are laid down.

credit: [@piousdeer](https://gist.github.com/piousdeer/b29c272eaeba398b864da6abf6cb5daa)

<div align="right"><a href="#faq"><img src="https://img.shields.io/badge/Back_to_Top-↑-blue" alt="Back to Top"/></a></div>

### common errors

#### `Existing file '...' is in the way of '...'`

home-manager tries to create a file that already exists and was not created by home-manager.

**solution 1 — remove the conflicting file:**

```bash
rm ~/.config/kitty/kitty.conf
sudo nixos-rebuild switch --flake .#hydenix
```

**solution 2 — back it up first:**

```bash
mv ~/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf.bak
sudo nixos-rebuild switch --flake .#hydenix
```

**solution 3 — let home-manager back up automatically (one-time):**

```nix
# configuration.nix
home-manager.backupFileExtension = "backup";
```

> [!WARNING]
> this only works once. if the conflict appears again after the next rebuild you will need to resolve it manually.

<div align="right"><a href="#faq"><img src="https://img.shields.io/badge/Back_to_Top-↑-blue" alt="Back to Top"/></a></div>

### requesting features

open a [feature request](https://github.com/ClementBobin/hydenix/issues/new?template=feature_request.md) on GitHub, or discuss it in [discord](https://discord.gg/AYbJ9MJez7) first.

<div align="right"><a href="#faq"><img src="https://img.shields.io/badge/Back_to_Top-↑-blue" alt="Back to Top"/></a></div>

### what are some example configurations?

see [community configs](./community.md).

<div align="right"><a href="#faq"><img src="https://img.shields.io/badge/Back_to_Top-↑-blue" alt="Back to Top"/></a></div>

---

## other

### how do I run hyprland in a vm?

Hyprland in a VM is not well supported upstream. see [hyprland — running in a VM](https://wiki.hyprland.org/Getting-Started/Installation/#running-in-a-vm) for the latest guidance.

you need: VT-x / AMD-V enabled in BIOS, virtio, and OpenGL 3.3+ support on the host.

non-NixOS hosts should wrap the run command with [nixGL](https://github.com/nix-community/nixGL):

```bash
nixGL nix run github:ClementBobin/hydenix
```

<details>
<summary>host hardware requirements</summary>

**CPU**
- Intel with VT-x or AMD with AMD-V
- virtualisation enabled in BIOS/UEFI

**GPU**
- NVIDIA GTX 600+ (proprietary driver)
- AMD HD 7000+
- Intel HD 4000+ (Ivy Bridge)
- OpenGL 3.3+ required

</details>

<details>
<summary>1. install host drivers</summary>

```bash
# NVIDIA
# Debian/Ubuntu
sudo apt install nvidia-driver nvidia-utils
# Arch
sudo pacman -S nvidia nvidia-utils
# NixOS
{ hardware.graphics.enable = true;
  hardware.nvidia.modesetting.enable = true; }

# AMD
# Debian/Ubuntu
sudo apt install mesa-utils vulkan-tools
# Arch
sudo pacman -S mesa lib32-mesa vulkan-radeon
# NixOS
{ hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [ amdvlk ]; }

# Intel
# Debian/Ubuntu
sudo apt install mesa-utils intel-media-va-driver
# Arch
sudo pacman -S mesa lib32-mesa intel-media-driver
# NixOS
{ hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [ intel-media-driver ]; }

# KVM
modprobe kvm && modprobe kvm_intel  # or kvm_amd
# NixOS
{ boot.kernelModules = [ "kvm-intel" ];  # or kvm-amd
  virtualisation.libvirtd.enable = true; }
```

</details>

<details>
<summary>2. verify setup</summary>

```bash
egrep -c '(vmx|svm)' /proc/cpuinfo   # should return > 0
lsmod | grep kvm
glxinfo | grep "OpenGL"
```

</details>

<details>
<summary>3. recommended QEMU flags</summary>

```bash
-device virtio-vga-gl
-display gtk,gl=on,grab-on-hover=on
-usb -device usb-tablet
-cpu host
-enable-kvm
-machine q35
-device intel-iommu
-device ich9-intel-hda
-device hda-output
-vga none
```

</details>

<div align="right"><a href="#faq"><img src="https://img.shields.io/badge/Back_to_Top-↑-blue" alt="Back to Top"/></a></div>
