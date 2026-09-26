<img align="right" width="75px" alt="NixOS" src="https://github.com/HyDE-Project/HyDE/blob/master/Source/assets/nixos.png?raw=true"/>

# troubleshooting & issues

- [nix build errors](#nix-build-errors)
- [system errors and runtime bugs](#system-errors-and-runtime-bugs)
- [hyprland / display issues](#hyprland--display-issues)
- [home-manager conflicts](#home-manager-conflicts)
- [opening an issue](#opening-an-issue)

---

## nix build errors

> [!TIP]
> nix error messages can be long. the actual cause is almost always somewhere in the **middle** of the output, not the last line.

useful flags to add to any `nixos-rebuild` command:

```bash
# verbose output
sudo nixos-rebuild switch --flake .#hydenix -v

# full traceback
sudo nixos-rebuild switch --flake .#hydenix --show-trace

# both
sudo nixos-rebuild switch --flake .#hydenix -v --show-trace
```

**common causes:**

- a required option is missing — check [options.md](./options.md) for required fields
- a theme name does not match the available list — see [sources/themes](https://github.com/ClementBobin/hydenix/tree/dev/hydenix/sources/themes)
- a file path in `home.file` does not exist in your flake directory
- files not tracked by git — run `git add .` before rebuilding

---

## system errors and runtime bugs

collect the following before reporting an issue:

```bash
# system journal (current boot)
journalctl -b

# home-manager service status
sudo systemctl status home-manager-$USER.service

# nix and system info
nix-shell -p nix-info --run "nix-info -m"

# hyprland log (if display issues)
cat ~/.local/share/hyprland/hyprland.log
```

---

## hyprland / display issues

**hyprland does not start:**

```bash
# check the hyprland log
cat ~/.local/share/hyprland/hyprland.log | tail -50

# check if UWSM started correctly
systemctl --user status uwsm-app@hyprland.service
```

**blank screen / cursor only:**

- make sure `hydenix.hm.theme.active` is set to a theme that is also in `hydenix.hm.theme.themes`
- run `hyde-shell reload` from a TTY to regenerate the theme cache

**GPU / rendering issues:**

- nvidia users: check that `hardware.nvidia.modesetting.enable = true` is set in `configuration.nix`
- for VM setups, see [how do I run hyprland in a VM](./faq.md#how-do-i-run-hyprland-in-a-vm)

---

## home-manager conflicts

### `Existing file '...' is in the way of '...'`

occurs when a file that was not created by home-manager is blocking a managed path.

```bash
# remove the conflicting file
rm ~/.config/kitty/kitty.conf

# or back it up
mv ~/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf.bak
```

then rebuild. to prevent this on future rebuilds, manage the file via `home.file` in your flake (see [faq — persisting changes](./faq.md#how-do-i-persist-changes-across-rebuilds)).

### mutable file was overwritten

some files are intentionally mutable (see [what is mutable.nix](./faq.md#what-is-mutablenix)). changes to these files at runtime are reset on rebuild by design. to make a change permanent, track the file in your flake via `home.file`.

---

## opening an issue

before opening an issue, please:

1. search [existing issues](https://github.com/ClementBobin/hydenix/issues) — it may already be reported or fixed
2. check [CHANGELOG.md](../../CHANGELOG.md) to see if it was recently changed
3. read through this page and [faq.md](./faq.md)

when opening an issue, include:

- output of `nix-shell -p nix-info --run "nix-info -m"`
- the full error message (with `--show-trace` if a build error)
- relevant lines from `journalctl -b` or `~/.local/share/hyprland/hyprland.log`
- the relevant section of your `configuration.nix` / `modules/hm/default.nix`

→ [open an issue](https://github.com/ClementBobin/hydenix/issues/new)
→ [ask in discord](https://discord.gg/AYbJ9MJez7)
→ [github discussions](https://github.com/ClementBobin/hydenix/discussions)
