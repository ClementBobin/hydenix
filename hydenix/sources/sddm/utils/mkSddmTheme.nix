{ pkgs }:
{
  name,
  src,
  meta,
}:
let

  # Helper function to find the first directory in a path
  findFirstDir = ''
    findFirstDir() {
      local path="$1"
      if [ -d "$path" ]; then
        local first_dir=$(find "$path" -mindepth 1 -maxdepth 1 -type d | head -n 1)
        if [ -n "$first_dir" ]; then
          basename "$first_dir"
        else
          echo ""
        fi
      else
        echo ""
      fi
    }
  '';

  # Combined theme package that includes all arcs
  pkg = pkgs.stdenv.mkDerivation {
    inherit name src;
    pname = name;

    version = "1.0.0";

    nativeBuildInputs = with pkgs; [
      gnutar
    ];

    dontPatchELF = true;
    dontRewriteSymlinks = true;
    dontDropIconThemeCache = true;

    installPhase = ''
      runHook preInstall

      # Create theme directory structure
      mkdir -p $out/share/sddm/themes/"${name}"

      ${findFirstDir}

      cp -r sddm/"${name}"/. $out/share/sddm/themes/"${name}"/

      runHook postInstall
    '';

    meta = with pkgs.lib; {
      inherit (meta) description homepage priority;
      license = licenses.mit;
      platforms = platforms.all;
    };
  };

in
pkg
