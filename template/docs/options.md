<img align="right" width="75px" alt="NixOS" src="https://github.com/HyDE-Project/HyDE/blob/master/Source/assets/nixos.png?raw=true"/>

# hydenix options

- [hydenix options](#hydenix-options)
- [how to read this document](#how-to-read-this-document)
- [required options](#required-options)
- [system options](#system-options)
- [hydenix.audio](#hydenixaudio)
- [hydenix.boot](#hydenixboot)
- [hydenix.hardware](#hydenixhardware)
- [hydenix.hyprland (system)](#hydenixhyprland-system)
- [hydenix.network](#hydenixnetwork)
- [hydenix.nix](#hydenixnix)
- [hydenix.sddm](#hydenixsddm)
- [hydenix.system](#hydenixsystem)
- [home-manager options](#home-manager-options)
- [hydenix.hm](#hydenixhm)
- [hydenix.hm.awww](#hydenixhmawww)
- [hydenix.hm.browser](#hydenixhmbrowser)
- [hydenix.hm.comma](#hydenixhmcomma)
- [hydenix.hm.dolphin](#hydenixhmdolphin)
- [hydenix.hm.editors](#hydenixhmeditors)
- [hydenix.hm.fastfetch](#hydenixhmfastfetch)
- [hydenix.hm.git](#hydenixhmgit)
- [hydenix.hm.gtk](#hydenixhmgtk)
- [hydenix.hm.hyde](#hydenixhmhyde)
- [hydenix.hm.hyprland](#hydenixhmhyprland)
- [hydenix.hm.lockscreen](#hydenixhmlockscreen)
- [hydenix.hm.management-utility](#hydenixhmmanagement-utility)
- [hydenix.hm.notifications](#hydenixhmnotifications)
- [hydenix.hm.qt](#hydenixhmqt)
- [hydenix.hm.rofi](#hydenixhmrofi)
- [hydenix.hm.screenshots](#hydenixhmscreenshots)
- [hydenix.hm.shell](#hydenixhmshell)
- [hydenix.hm.social](#hydenixhmsocial)
- [hydenix.hm.spotify](#hydenixhmspotify)
- [hydenix.hm.terminals](#hydenixhmterminals)
- [hydenix.hm.theme](#hydenixhmtheme)
- [hydenix.hm.uwsm](#hydenixhmuwsm)
- [hydenix.hm.waybar](#hydenixhmwaybar)
- [hydenix.hm.wlogout](#hydenixhmwlogout)
- [hydenix.hm.xdg](#hydenixhmxdg)

---

## how to read this document

Each option is shown with its type, default value, and a short description. You can always find the source of truth by searching the repo:

[search hydenix options on GitHub](https://github.com/ClementBobin/hydenix/search?q=options.hydenix)

> [!important]
> `hydenix.hm.*` options **must** be set inside a home-manager module (e.g. `./modules/hm/default.nix`), not in `configuration.nix`.

---

## required options

You **must** set these four options, or hydenix will refuse to build.

```nix
# configuration.nix
hydenix = {
  enable   = true;
  hostname = "my-machine";
  timezone = "Europe/Paris";
  locale   = "fr_FR.UTF-8";
};

# modules/hm/default.nix
hydenix.hm.enable = true;
```

| Option | Type | Description |
|---|---|---|
| `hydenix.enable` | `bool` | Master switch. Must be `true`. |
| `hydenix.hostname` | `str` | Network hostname of the machine. |
| `hydenix.timezone` | `str` | System timezone (e.g. `"America/Vancouver"`). |
| `hydenix.locale` | `str` | System locale (e.g. `"en_CA.UTF-8"`). |

---

## system options

These options live in `configuration.nix` (or any NixOS module).

### hydenix.audio

Enables PipeWire with ALSA, PulseAudio compatibility, WirePlumber, and Bluetooth audio (blueman).

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.audio.enable` | `bool` | `hydenix.enable` | Enable the audio module. |

```nix
hydenix.audio.enable = true;
```

---

### hydenix.boot

Configures the bootloader (systemd-boot + EFI) and the kernel.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.boot.enable` | `bool` | `hydenix.enable` | Enable the boot module. |
| `hydenix.boot.kernelPackages` | `attrs` | `pkgs.linuxPackages_zen` | Kernel packages to use. |

```nix
hydenix.boot = {
  enable         = true;
  kernelPackages = pkgs.linuxPackages_zen; # or pkgs.linuxPackages_latest, etc.
};
```

---

### hydenix.hardware

Installs system-level hardware utilities: `brightnessctl`, `udiskie`, `ntfs3g`, `exfat`, `libinput`, `lm_sensors`, `pciutils`.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hardware.enable` | `bool` | `hydenix.enable` | Enable the hardware module. |

```nix
hydenix.hardware.enable = true;
```

---

### hydenix.hyprland (system)

Sets up the Hyprland compositor at the NixOS level: enables the `hyprland` program with UWSM, configures the XDG portal, sets up polkit, DBus, GnuPG SSH agent, and PAM services for hyprlock/swaylock.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hyprland.enable` | `bool` | `true` | Enable the system-level Hyprland module. |

```nix
hydenix.hyprland.enable = true;
```

> [!note]
> This is the **system** counterpart. Per-user Hyprland configuration lives under [`hydenix.hm.hyprland`](#hydenixhmhyprland).

---

### hydenix.network

Enables NetworkManager, a firewall (allowing SSH on port 22), and installs `networkmanagerapplet`.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.network.enable` | `bool` | `hydenix.enable` | Enable the network module. |

```nix
hydenix.network.enable = true;
```

---

### hydenix.nix

Configures the Nix daemon: enables flakes and nix-command, sets up binary caches (nixos, hyprland, nix-community), enables store optimisation, and pins `nixpkgs` with `allowUnfree = true` via the hydenix overlay.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.nix.enable` | `bool` | `true` | Enable the Nix configuration module. |

```nix
hydenix.nix.enable = true;
```

---

### hydenix.sddm

Installs and configures the SDDM display manager with Wayland support, HiDPI, and an SDDM theme from the hydenix overlay.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.sddm.enable` | `bool` | `true` | Enable the SDDM module. |
| `hydenix.sddm.theme` | `str` | `"sddm-astronaut-theme"` | SDDM theme name. Must exist in [`hydenix/sources/sddm/`](https://github.com/ClementBobin/hydenix/tree/main/hydenix/sources/sddm). |

Available SDDM themes: `"sddm-astronaut-theme"`, `"Agency"`.

```nix
hydenix.sddm = {
  enable = true;
  theme  = "sddm-astronaut-theme"; # or "Agency"
};
```

---

### hydenix.system

Installs general system utilities (`jq`, `imagemagick`, `fzf`, `trash-cli`, `ark`, etc.), enables Bluetooth, OpenSSH, `upower`, `libinput`, `gvfs`, and `nix-ld`.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.system.enable` | `bool` | `true` | Enable the system utilities module. |

```nix
hydenix.system.enable = true;
```

---

## home-manager options

All `hydenix.hm.*` options must be set inside a home-manager module. In the default template this is `./modules/hm/default.nix`.

### hydenix.hm

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.enable` | `bool` | `false` | Master switch for all home-manager modules. |

```nix
hydenix.hm.enable = true;
```

---

### hydenix.hm.awww

Installs the `awww` Wayland wallpaper daemon.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.awww.enable` | `bool` | `hydenix.hm.enable` | Enable awww. |

```nix
hydenix.hm.awww.enable = true;
```

---

### hydenix.hm.browser

Installs one or more browsers. The `MOZ_ENABLE_WAYLAND` environment variable is set automatically.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.browser.clients` | `listOf (enum ["chrome" "firefox" "brave" "zen"])` | `[]` | Browsers to install. |

```nix
hydenix.hm.browser.clients = [ "firefox" "zen" ];
```

Available values: `"chrome"`, `"firefox"`, `"brave"`, `"zen"`.

---

### hydenix.hm.comma

Enables [comma (`,`)](https://github.com/nix-community/comma) — run any Nix package without installing it first. Integrates with `nix-index` and your active shell.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.comma.enable` | `bool` | `hydenix.hm.enable` | Enable comma. |

```nix
hydenix.hm.comma.enable = true;

# then in your terminal:
# , cowsay "hello"
```

---

### hydenix.hm.dolphin

Installs the KDE Dolphin file manager with thumbnail support, sets it as the default `inode/directory` handler, and deploys HyDE's dolphin configuration.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.dolphin.enable` | `bool` | `hydenix.hm.enable` | Enable Dolphin. |

```nix
hydenix.hm.dolphin.enable = true;
```

---

### hydenix.hm.editors

Installs and configures text editors, sets MIME type associations, and exports `$EDITOR` / `$VISUAL`.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.editors.enable` | `bool` | `hydenix.hm.enable` | Enable the editors module. |
| `hydenix.hm.editors.vscode.enable` | `bool` | `true` | Install VS Code (FHS wrapped). |
| `hydenix.hm.editors.vscodium.enable` | `bool` | `true` | Install VSCodium (FHS wrapped). |
| `hydenix.hm.editors.neovim` | `bool` | `true` | Install Neovim. |
| `hydenix.hm.editors.vim` | `bool` | `true` | Install Vim. |
| `hydenix.hm.editors.default` | `str` | `"code"` | Default editor binary name (used for `$EDITOR`, `$VISUAL`, and MIME associations). |

```nix
hydenix.hm.editors = {
  enable          = true;
  vscode.enable   = true;
  vscodium.enable = false;
  neovim          = true;
  vim             = false;
  default         = "code"; # or "nvim", "vim", "codium", …
};
```

---

### hydenix.hm.fastfetch

Deploys HyDE's fastfetch configuration to `~/.config/fastfetch`.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.fastfetch.enable` | `bool` | `hydenix.hm.enable` | Enable the fastfetch config. |

```nix
hydenix.hm.fastfetch.enable = true;
```

---

### hydenix.hm.git

Configures `git` via home-manager, setting user identity and sensible defaults (`pull.rebase = false`, `init.defaultBranch = "main"`).

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.git.enable` | `bool` | `hydenix.hm.enable` | Enable the git module. |
| `hydenix.hm.git.name` | `any` | `false` | Git user name. |
| `hydenix.hm.git.email` | `any` | `false` | Git user email. |

```nix
hydenix.hm.git = {
  enable = true;
  name   = "John Doe";
  email  = "john@example.com";
};
```

---

### hydenix.hm.gtk

Installs GTK3/GTK4 theming tools (`nwg-look`, `gnome-tweaks`, `emote`, etc.) and deploys mutable GTK config files that HyDE updates when switching themes.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.gtk.enable` | `bool` | `hydenix.hm.enable` | Enable the GTK theming module. |

```nix
hydenix.hm.gtk.enable = true;
```

---

### hydenix.hm.hyde

Core HyDE module. Installs `hyde`, `hydectl`, `hyde-config`, `hyq`, cursor themes, Nerd Fonts, OCR tools, and deploys all HyDE runtime scripts, wallbash templates, waybar shared assets, and the `hyde-config` systemd service.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.hyde.enable` | `bool` | `hydenix.hm.enable` | Enable the HyDE core module. |

```nix
hydenix.hm.hyde.enable = true;
```

> [!important]
> This module is a dependency for most other `hydenix.hm.*` modules. Disabling it will break theme switching, wallbash, and many HyDE scripts.

---

### hydenix.hm.hyprland

Per-user Hyprland configuration: deploys HyDE's hyprland configs, shaders, workflows, and hypridle. Supports appending extra config or completely overriding the main `hyprland.lua`.

#### main options

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.hyprland.enable` | `bool` | `hydenix.hm.enable` | Enable the hyprland home-manager module. |
| `hydenix.hm.hyprland.extraConfig` | `lines` | `""` | Lines appended to `hyprland.lua` (e.g. custom keybinds, monitor rules). |
| `hydenix.hm.hyprland.overrideMain` | `nullOr lines` | `null` | If set, replaces the entire `hyprland.lua`. Use with care. |
| `hydenix.hm.hyprland.suppressWarnings` | `bool` | `false` | Suppress warnings when using overrides. |

```nix
hydenix.hm.hyprland = {
  enable      = true;
  extraConfig = ''
    bind = SUPER, T, exec, kitty
    monitor = DP-1, 2560x1440@144, 0x0, 1
  '';
};
```

#### hypridle

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.hyprland.hypridle.extraConfig` | `lines` | `""` | Lines appended after the default hypridle config. |
| `hydenix.hm.hyprland.hypridle.overrideConfig` | `nullOr lines` | `null` | Full replacement for `hypridle.conf`. |

```nix
hydenix.hm.hyprland.hypridle = {
  extraConfig = ''
    listener {
      timeout = 600
      on-timeout = systemctl suspend
    }
  '';
};
```

#### shaders

Custom or override GLSL shaders placed in `~/.config/hypr/shaders/`.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.hyprland.shaders.overrides` | `attrsOf lines` | `{}` | Map of `filename -> shader source`. Overrides or adds custom shaders. |

```nix
hydenix.hm.hyprland.shaders.overrides = {
  "my-filter.frag" = ''
    precision mediump float;
    varying vec2 v_texcoord;
    uniform sampler2D tex;
    void main() {
      gl_FragColor = texture2D(tex, v_texcoord);
    }
  '';
};
```

#### workflows

Override or add Hyprland workflow presets. Built-in presets: `01-default`, `editing`, `gaming`, `powersaver`, `snappy`.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.hyprland.workflows.overrides` | `attrsOf lines` | `{}` | Map of `workflow-name -> lua source`. Overrides a built-in preset or creates a new one. |

```nix
hydenix.hm.hyprland.workflows.overrides = {
  "gaming" = ''
    -- Custom gaming workflow
    hyprland.keyword("decoration:blur:enabled", "false")
  '';
  "my-workflow" = ''
    -- Brand new workflow
    hyprland.keyword("animations:enabled", "false")
  '';
};
```

---

### hydenix.hm.lockscreen

Installs and configures lockscreen tools. Supports `hyprlock` (default) and `swaylock`.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.lockscreen.enable` | `bool` | `hydenix.hm.enable` | Enable the lockscreen module. |
| `hydenix.hm.lockscreen.hyprlock` | `bool` | `true` | Install and configure hyprlock. |
| `hydenix.hm.lockscreen.swaylock` | `bool` | `false` | Install and configure swaylock. |
| `hydenix.hm.lockscreen.kb_layout` | `str` | `"us"` | Keyboard layout used on the lockscreen input. |
| `hydenix.hm.lockscreen.theme` | `enum` | `"HyDE"` | Hyprlock theme. |

Available themes: `"HyDE"`, `"Anurati"`, `"Arfan on Clouds"`, `"IBM Plex"`, `"IMB Xtented"`, `"SF Pro"`, `"greetd"`, `"greetd-wallbash"`.

```nix
hydenix.hm.lockscreen = {
  enable    = true;
  hyprlock  = true;
  swaylock  = false;
  kb_layout = "fr";
  theme     = "SF Pro";
};
```

---

### hydenix.hm.management-utility

Installs optional display management GUIs (from `pkgs-unstable`).

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.management-utility.clients` | `listOf (enum ["nwg-displays" "wdisplays"])` | `[]` | Display management utilities to install. |

```nix
hydenix.hm.management-utility.clients = [ "nwg-displays" ];
```

---

### hydenix.hm.notifications

Installs `dunst` and deploys HyDE's mutable dunst configuration (updated by wallbash on theme change).

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.notifications.enable` | `bool` | `hydenix.hm.enable` | Enable the notifications module. |

```nix
hydenix.hm.notifications.enable = true;
```

---

### hydenix.hm.qt

Installs Qt5/Qt6 theming packages (`qt6ct`, `qtwayland`, `Kvantum`, `breeze-icons`) and deploys HyDE's mutable Qt config files.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.qt.enable` | `bool` | `hydenix.hm.enable` | Enable the Qt theming module. |

```nix
hydenix.hm.qt.enable = true;
```

---

### hydenix.hm.rofi

Installs `rofi` (with the `rofi-calc` plugin) and deploys HyDE's rofi themes.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.rofi.enable` | `bool` | `hydenix.hm.enable` | Enable the rofi module. |

```nix
hydenix.hm.rofi.enable = true;
```

---

### hydenix.hm.screenshots

Installs screenshot and screen capture tools.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.screenshots.enable` | `bool` | `hydenix.hm.enable` | Enable the screenshots module. |
| `hydenix.hm.screenshots.grim.enable` | `bool` | `true` | Install `grim` (Wayland screenshot tool). |
| `hydenix.hm.screenshots.slurp.enable` | `bool` | `true` | Install `slurp` (region selection). |
| `hydenix.hm.screenshots.satty.enable` | `bool` | `true` | Install `satty` (screenshot annotation). |
| `hydenix.hm.screenshots.swappy.enable` | `bool` | `false` | Install `swappy` (screenshot editor). |

```nix
hydenix.hm.screenshots = {
  enable        = true;
  grim.enable   = true;
  slurp.enable  = true;
  satty.enable  = true;
  swappy.enable = false;
};
```

---

### hydenix.hm.shell

Configures shells and prompt tools. Zsh is enabled by default with Oh-My-Zsh, autosuggestions, syntax highlighting, and common aliases. Fish is also supported.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.shell.enable` | `bool` | `hydenix.hm.enable` | Enable the shell module. |
| `hydenix.hm.shell.zsh.enable` | `bool` | `true` | Enable and configure Zsh. |
| `hydenix.hm.shell.zsh.plugins` | `listOf str` | `["sudo"]` | Oh-My-Zsh plugins to enable. |
| `hydenix.hm.shell.zsh.configText` | `lines` | `""` | Extra text appended to `.zshrc`. |
| `hydenix.hm.shell.bash.enable` | `bool` | `false` | Enable Bash. |
| `hydenix.hm.shell.fish.enable` | `bool` | `false` | Enable Fish with HyDE config. |
| `hydenix.hm.shell.starship.enable` | `bool` | `true` | Enable the Starship prompt. |
| `hydenix.hm.shell.p10k.enable` | `bool` | `false` | Enable Powerlevel10k (Zsh only). |
| `hydenix.hm.shell.pokego.enable` | `bool` | `false` | Show a random Pokémon on shell startup. |
| `hydenix.hm.shell.fastfetch.enable` | `bool` | `true` | Run fastfetch on shell startup. |

```nix
hydenix.hm.shell = {
  enable = true;
  zsh = {
    enable     = true;
    plugins    = [ "sudo" "git" "docker" ];
    configText = ''
      export MY_VAR="hello"
      alias gs="git status"
    '';
  };
  starship.enable  = true;
  pokego.enable    = true;
  fastfetch.enable = false;
};
```

---

### hydenix.hm.social

Installs Discord and/or Vesktop with Electron Wayland flags.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.social.enable` | `bool` | `hydenix.hm.enable` | Enable the social module. |
| `hydenix.hm.social.discord.enable` | `bool` | `true` | Install Discord. |
| `hydenix.hm.social.vesktop.enable` | `bool` | `true` | Install Vesktop (enhanced Discord client). |

```nix
hydenix.hm.social = {
  enable         = true;
  discord.enable = false;
  vesktop.enable = true;
};
```

---

### hydenix.hm.spotify

Installs Spotify and/or Spicetify (a Spotify theme/extension manager).

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.spotify.clients` | `listOf (enum ["spotify" "spicetify"])` | `[]` | Spotify clients to install. |
| `hydenix.hm.spotify.spicetify.extensions` | `listOf str` | `["shuffle" "autoSkipExplicit" "autoVolume" "adblock" "coverAmbience"]` | Spicetify extensions to enable. |
| `hydenix.hm.spotify.spicetify.apps` | `listOf str` | `["marketplace" "ncsVisualizer"]` | Spicetify apps to enable. |
| `hydenix.hm.spotify.spicetify.theme` | `str` | `"text"` | Spicetify theme name. |
| `hydenix.hm.spotify.spicetify.colorScheme` | `str` | `"Spotify"` | Spicetify color scheme. |

```nix
# Plain Spotify
hydenix.hm.spotify.clients = [ "spotify" ];

# Spicetify only (wraps the installed Spotify)
hydenix.hm.spotify = {
  clients = [ "spicetify" ];
  spicetify = {
    extensions  = [ "shuffle" "adblock" "coverAmbience" ];
    apps        = [ "marketplace" ];
    theme       = "text";
    colorScheme = "Spotify";
  };
};
```

> [!note]
> `"spicetify"` wraps Spotify — you don't need both `"spotify"` and `"spicetify"` in `clients`.

---

### hydenix.hm.terminals

Installs terminal emulators. Kitty is enabled by default and configured with HyDE's colour-managed `hyde.conf`.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.terminals.enable` | `bool` | `hydenix.hm.enable` | Enable the terminals module. |
| `hydenix.hm.terminals.kitty.enable` | `bool` | `true` | Install and configure Kitty. |
| `hydenix.hm.terminals.kitty.configText` | `lines` | `""` | Extra lines appended to `kitty.conf` after the HyDE defaults. |

```nix
hydenix.hm.terminals = {
  enable = true;
  kitty = {
    enable     = true;
    configText = ''
      font_size 13.0
      background_opacity 0.95
    '';
  };
};
```

---

### hydenix.hm.theme

Manages HyDE themes: installs selected theme packages, creates symlinks in `~/.config/hyde/themes/`, and applies the active theme at activation time via `theme.switch.sh`.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.theme.enable` | `bool` | `hydenix.hm.enable` | Enable the theme module. |
| `hydenix.hm.theme.active` | `str` | `"Catppuccin Mocha"` | Name of the active theme to apply on login. |
| `hydenix.hm.theme.themes` | `listOf str` | `["Catppuccin Mocha" "Catppuccin Latte"]` | Themes to install (must exist in [`hydenix/sources/themes/`](https://github.com/ClementBobin/hydenix/tree/main/hydenix/sources/themes)). |
| `hydenix.hm.theme.random` | `enum ["none" "theme" "wallpaper" "all"]` | `"none"` | Apply a random theme, wallpaper, or both on activation. |

```nix
hydenix.hm.theme = {
  enable = true;
  active = "Tokyo-Night";
  themes = [
    "Catppuccin Mocha"
    "Tokyo-Night"
    "Dracula"
    "Rose-Pine"
  ];
  random = "none"; # or "theme", "wallpaper", "all"
};
```

<details>
<summary>All available themes</summary>

```
1-Bit            AbyssGreen       Abyssal-Wave     Agency
Amethyst-Aura    AncientAliens    Another-World    Bad-Blood
BlueSky          Breezy-Autumn    CIA              Cat-Latte
Catppuccin-Latte Catppuccin-Macchiato Catppuccin-Mocha Chisa
Code-Garden      Cosmic-Blue      Crimson-Blade    Crimson-Blue
DanDaDan         Decay-Green      DoomBringers     Dracula
Drawbridge       Edge-Runner      Electra          Eternal-Arctic
Ever-Blushing    FBI              Frosted-Glass    Graphite-Mono
Green-Lush       Greenify         Grukai           Gruvbox-Retro
Hack-the-Box     Ice-Age          Joker            LimeFrenzy
MI6              Mac-OS           Material-Sakura  Monokai
Monterey-Frost   Moonlight        Nier             Nightbrew
Nordic-Blue      Obsidian-Purple  One-Dark         Oregairu
Oxo-Carbon       Paranoid-Sweet   Peace-Of-Mind    Pixel-Dream
Rain-Dark        Red-Stone        Rose-Pine        Scarlet-Night
Solarized-Dark   Soulsborne       Synth-Wave       Timeless-Dream
Tokyo-Night      Tundra           Vanta-Black      Windows-11
```

Browse source files: [hydenix/sources/themes/](https://github.com/ClementBobin/hydenix/tree/main/hydenix/sources/themes)

</details>

---

### hydenix.hm.uwsm

Deploys UWSM (Universal Wayland Session Manager) configuration files from HyDE.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.uwsm.enable` | `bool` | `hydenix.hm.enable` | Enable the UWSM config module. |

```nix
hydenix.hm.uwsm.enable = true;
```

---

### hydenix.hm.waybar

Installs Waybar and deploys HyDE's full waybar configuration (layouts, modules, styles). Supports injecting custom CSS.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.waybar.enable` | `bool` | `hydenix.hm.enable` | Enable the waybar module. |
| `hydenix.hm.waybar.waybar.enable` | `bool` | `true` | Install Waybar and its dependencies. |
| `hydenix.hm.waybar.userStyle` | `lines` | `""` | Custom CSS written to `~/.config/waybar/user-style.css`. Imported last, so it overrides defaults. |

```nix
hydenix.hm.waybar = {
  enable = true;
  userStyle = ''
    /* make the bar slightly transparent */
    window#waybar {
      background-color: rgba(0, 0, 0, 0.75);
    }
  '';
};
```

---

### hydenix.hm.wlogout

Installs `wlogout` and deploys HyDE's wlogout configuration.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.wlogout.enable` | `bool` | `hydenix.hm.enable` | Enable the wlogout module. |
| `hydenix.hm.wlogout.wlogout.enable` | `bool` | `true` | Install wlogout. |

```nix
hydenix.hm.wlogout = {
  enable         = true;
  wlogout.enable = true;
};
```

---

### hydenix.hm.xdg

Configures XDG base directories, user directories, MIME portals, and sets the full set of `XDG_*` environment variables. Creates standard user directories (`~/Documents`, `~/Downloads`, etc.) on activation.

| Option | Type | Default | Description |
|---|---|---|---|
| `hydenix.hm.xdg.enable` | `bool` | `hydenix.hm.enable` | Enable XDG base directory configuration. |

```nix
hydenix.hm.xdg.enable = true;
```

---

## full example

Below is a complete minimal configuration. Place the system block in `configuration.nix` and the home-manager block in `modules/hm/default.nix`.

```nix
# configuration.nix
hydenix = {
  enable   = true;
  hostname = "nixos";
  timezone = "Europe/Paris";
  locale   = "fr_FR.UTF-8";

  audio.enable = true;
  boot = {
    enable         = true;
    kernelPackages = pkgs.linuxPackages_zen;
  };
  hardware.enable = true;
  network.enable  = true;
  nix.enable      = true;
  sddm = {
    enable = true;
    theme  = "sddm-astronaut-theme";
  };
  hyprland.enable = true;
  system.enable   = true;
};
```

```nix
# modules/hm/default.nix
hydenix.hm = {
  enable = true;

  browser.clients = [ "firefox" ];

  editors = {
    enable        = true;
    vscode.enable = true;
    neovim        = true;
    default       = "code";
  };

  git = {
    enable = true;
    name   = "Your Name";
    email  = "you@example.com";
  };

  hyprland = {
    enable      = true;
    extraConfig = ''
      bind = SUPER, Return, exec, kitty
    '';
  };

  lockscreen = {
    enable    = true;
    hyprlock  = true;
    kb_layout = "fr";
    theme     = "HyDE";
  };

  shell = {
    enable = true;
    zsh = {
      enable  = true;
      plugins = [ "sudo" "git" ];
    };
    starship.enable = true;
  };

  theme = {
    enable = true;
    active = "Catppuccin Mocha";
    themes = [ "Catppuccin Mocha" "Tokyo-Night" "Dracula" ];
  };

  terminals = {
    enable = true;
    kitty = {
      enable     = true;
      configText = "font_size 13.0\n";
    };
  };

  waybar = {
    enable    = true;
    userStyle = ''
      window#waybar { background-color: rgba(0,0,0,0.8); }
    '';
  };
};
```