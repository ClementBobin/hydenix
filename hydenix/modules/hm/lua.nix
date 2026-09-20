{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hydenix.hm.hyde;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      lua55Packages.luarocks
      (pkgs.lua5_5.withPackages (ps: with ps; [
        luafilesystem
        luasec
        luasocket
        argparse
        dkjson
      ]))
      gobject-introspection
      glib
      libffi
      gsettings-desktop-schemas
    ];

    home.sessionVariables = {
      OPENSSL_DIR = "${pkgs.openssl.dev}";
      OPENSSL_INCDIR = "${pkgs.openssl.dev}/include";
      OPENSSL_LIBDIR = "${pkgs.openssl.out}/lib";
      GI_TYPELIB_PATH = "${pkgs.glib.out}/lib/girepository-1.0:${pkgs.gobject-introspection.out}/lib/girepository-1.0:$GI_TYPELIB_PATH";
      XDG_DATA_DIRS = lib.mkForce "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.glib.out}/share/gsettings-schemas/${pkgs.glib.name}:$XDG_DATA_DIRS";
    };

    home.activation.linkHydeGobject = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      LUADIR="$HOME/.local/state/hyde/lua_env"
      if [ -d "$LUADIR" ]; then
        mkdir -p "$LUADIR/lib/girepository-1.0"
        for tp in ${pkgs.gobject-introspection}/lib/girepository-1.0/* ${pkgs.glib.out}/lib/girepository-1.0/*; do
          if [ -e "$tp" ]; then
            ln -sf "$tp" "$LUADIR/lib/girepository-1.0/"
          fi
        done
      fi
    '';

    home.file = {
      ".local/bin/luarocks" = {
        source = pkgs.writeShellScript "luarocks-wrapper" ''
          REAL_LUAROCKS="/etc/profiles/per-user/${config.home.username}/bin/luarocks"
          if [ ! -x "$REAL_LUAROCKS" ]; then
            REAL_LUAROCKS="$(command -v luarocks)"
          fi

          export PKG_CONFIG_PATH="${pkgs.glib.dev}/lib/pkgconfig:${pkgs.libffi.dev}/lib/pkgconfig:${pkgs.gobject-introspection.dev}/lib/pkgconfig:${pkgs.openssl.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"

          for arg in "$@"; do
            if [ "$arg" = "install" ]; then
              exec "$REAL_LUAROCKS" "$@" OPENSSL_DIR="${pkgs.openssl.dev}" OPENSSL_INCDIR="${pkgs.openssl.dev}/include" OPENSSL_LIBDIR="${pkgs.openssl.out}/lib"
            fi
          done
          exec "$REAL_LUAROCKS" "$@"
        '';
        executable = true;
      };
    };
  };
}