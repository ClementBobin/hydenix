<div align="center">

[![NixOS Unstable](https://img.shields.io/badge/NixOS-unstable-ebbcba.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)
[![Release](https://img.shields.io/github/v/release/ClementBobin/hydenix?style=flat-square&color=c79bf0)](https://github.com/ClementBobin/hydenix/releases)
[![Last Commit](https://img.shields.io/github/last-commit/ClementBobin/hydenix/dev?style=flat-square&color=ebbcba)](https://github.com/ClementBobin/hydenix/commits/dev)
[![Nix Flake Check](https://img.shields.io/github/actions/workflow/status/ClementBobin/hydenix/flake-check.yml?style=flat-square&color=c79bf0&label=flake%20check)](https://github.com/ClementBobin/hydenix/actions/workflows/flake-check.yml)

</div>

<div align="center">
<a href="https://discord.gg/AYbJ9MJez7">
<img alt="Dynamic JSON Badge" src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fdiscordapp.com%2Fapi%2Finvites%2FmT5YqjaJFh%3Fwith_counts%3Dtrue&query=%24.approximate_member_count&suffix=%20members&style=for-the-badge&logo=discord&logoSize=auto&label=The%20HyDe%20Project&labelColor=ebbcba&color=c79bf0">
</a>
<br>

<video alt="Demo" src="https://github.com/user-attachments/assets/7f8fadc8-e293-4482-a851-e9c6464f5265">

</div>

<br>

<img align="right" width="75px" alt="NixOS" src="https://github.com/HyDE-Project/HyDE/blob/master/Source/assets/nixos.png?raw=true"/>

# hydenix

a nixos and home-manager configuration for [HyDE](https://github.com/HyDE-Project/HyDE)

**features / why nixos?**

- declarative `hydenix` and `hydenix.hm` configuration options
- leveraged module system — easily extend, disable, or override any module
- close feature parity with [HyDE](https://github.com/HyDE-Project/HyDE)
- every community [hyde-gallery theme](https://github.com/HyDE-Project/hyde-gallery) ([70+ themes](https://github.com/ClementBobin/hydenix/tree/dev/hydenix/sources/themes))
- reproducible environments with easy rollbacks
- version control for your entire desktop

## requirements

- a minimal install of NixOS — follow instructions on [nixos.org](https://nixos.org/download/#nixos-iso)

> [!IMPORTANT]
> some functional programming experience is recommended.\
> new to nix? see [nix resources](./template/docs/faq.md#how-do-i-learn-more-about-nix) or ask in [discussions](https://github.com/ClementBobin/hydenix/discussions) / [discord](https://discord.gg/AYbJ9MJez7).

## quick start

```bash
# create a directory and initialise the template
mkdir hydenix && cd hydenix
nix flake init -t github:ClementBobin/hydenix

# generate your hardware configuration
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix

# track with git (required for flakes)
git init && git add .

# build and switch
sudo nixos-rebuild switch --flake .#hydenix
```

See the full [installation guide](./template/docs/installation.md) for details.

## documentation

| | |
|---|---|
| [installation](./template/docs/installation.md) | step-by-step setup guide |
| [module options](./template/docs/options.md) | all `hydenix.*` and `hydenix.hm.*` options with examples |
| [upgrading](./template/docs/upgrading.md) | how to upgrade, downgrade, or pin a version |
| [faq](./template/docs/faq.md) | common questions and customisation tips |
| [troubleshooting](./template/docs/troubleshooting.md) | diagnosing nix errors and system issues |
| [contributing](./template/docs/contributing.md) | commit conventions and pull request process |
| [community configs](./template/docs/community.md) | real-world configurations from the community |

## hydenix vm

if your system supports virtualisation, the NixOS VM is a great way to try hydenix without installing it.

```bash
# run directly from the flake (no install required)
nix run github:ClementBobin/hydenix
```

> [!NOTE]
> any configuration changes require the VM to be rebuilt. run `rm hydenix.qcow2` to discard the old image.

if you run into issues, see the [VM guide](./template/docs/faq.md#how-do-i-run-hyprland-in-a-vm).
