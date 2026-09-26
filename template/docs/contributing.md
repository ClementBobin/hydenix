<img align="right" width="75px" alt="NixOS" src="https://github.com/HyDE-Project/HyDE/blob/master/Source/assets/nixos.png?raw=true"/>

# contributing

contributions of all kinds are welcome — bug fixes, new themes, documentation improvements, and new module options.

## dev environment

this project uses [direnv](https://direnv.net/) for pre-commit hooks (formatting, commit-lint).

```bash
# install direnv
nix-env -iA nixpkgs.direnv        # nix
brew install direnv                 # macOS
apt-get install direnv              # Debian/Ubuntu

# enable hooks in the repo
direnv allow
```

more information about the codebase is in the [template README](../.https://github.com/ClementBobin/hydenix/template/README.md).

## commit format

this project enforces [conventional commits](https://www.conventionalcommits.org/). every commit must follow:

```
type(optional-scope): subject

[optional body]

[optional footer(s)]
```

**type** — must be one of:

| type | when to use |
|---|---|
| `feat` | a new feature |
| `fix` | a bug fix |
| `docs` | documentation-only changes |
| `style` | formatting, whitespace, no logic change |
| `refactor` | code change that is neither a fix nor a feature |
| `perf` | performance improvement |
| `test` | adding or updating tests |
| `chore` | maintenance, dependency updates |

**scope** — optional, lowercase, describes the area changed. examples: `vm`, `themes`, `hm`, `shell`, `docs`, `sddm`.

**subject** — must not end with a period and must be descriptive.

**examples:**

```
feat(themes): add Tokyo-Night theme source
fix(shell): correct zsh plugin loading order
docs(options): document hyprland.shaders.overrides
chore: update nixpkgs input
```

the changelog is generated automatically from these messages — well-formatted commits make the history useful for everyone.

## pull request process

1. fork the repository
2. create a feature branch: `git checkout -b feat/my-thing`
3. make your changes and commit using conventional commits
4. push: `git push origin feat/my-thing`
5. open a pull request against the `dev` branch

> [!NOTE]
> target the `dev` branch, not `main`. `main` is only updated on release.

## adding a theme

1. add a `.nix` file under [`hydenix/sources/themes/`](https://github.com/ClementBobin/hydenix/tree/dev/hydenix/sources/themes) following the existing files as a template.
2. register the theme in [`hydenix/sources/themes/default.nix`](https://github.com/ClementBobin/hydenix/blob/dev/hydenix/sources/themes/default.nix).
3. open a PR with a commit like `feat(themes): add My-Theme`.

## adding an SDDM theme

1. add a `.nix` file under [`hydenix/sources/sddm/`](https://github.com/ClementBobin/hydenix/tree/dev/hydenix/sources/sddm).
2. register it in [`hydenix/sources/sddm/default.nix`](https://github.com/ClementBobin/hydenix/blob/dev/hydenix/sources/sddm/default.nix).
3. update the `hydenix.sddm.theme` enum in the module options if needed.
