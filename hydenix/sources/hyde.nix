{ pkgs, inputs }:
pkgs.stdenv.mkDerivation {
  name = "hyde-modified";
  src = inputs.hyde;

  nativeBuildInputs = with pkgs; [
    gnutar
    unzip
  ];

  buildPhase = ''
    # remove assets folder
    rm -rf Source/assets

    rm -rf Configs/.local/lib/hyde/resetxdgportal.sh
    rm -rf Configs/.local/bin/hydectl
    rm -rf Configs/.local/bin/hyde-ipc
    rm -rf Configs/.local/lib/hyde/hyde-config
    rm -rf Configs/.local/lib/hyde/hyq
    rm -rf Configs/.local/bin/hyq

    # Update waybar killall command in all HyDE files
    find . -type f -print0 | xargs -0 sed -i 's/killall waybar/killall .waybar-wrapped/g'

    # update dunst
    find . -type f -print0 | xargs -0 sed -i 's/killall dunst/killall .dunst-wrapped/g'

    # update kitty
    find . -type f -print0 | xargs -0 sed -i 's/killall kitty/killall .kitty-wrapped/g'
    find . -type f -print0 | xargs -0 sed -i 's/killall -SIGUSR1 kitty/killall -SIGUSR1 .kitty-wrapped/g'

    # fix find commands for symlinks
    find . -type f -executable -print0 | xargs -0 sed -i 's/find "/find -L "/g'
    find . -type f -name "*.sh" -print0 | xargs -0 sed -i 's/find "/find -L "/g'

    # Fix grimblast references to use global PATH instead of missing internal lib path
    find . -type f -print0 | xargs -0 sed -i 's|\$LIB_DIR/hyde/screenshot/grimblast|grimblast|g'

    sed -i '/tesseract_package_prefix=/,/^    done$/d' Configs/.local/lib/hyde/shutils/ocr.sh
    sed -i '/echo \$tesseract_languages/d' Configs/.local/lib/hyde/shutils/ocr.sh

    # remove lines 128-130 from Configs/.local/lib/hyde/theme.switch.sh
    sed -i '128,130d' Configs/.local/lib/hyde/theme.switch.sh

    # remove pkill command from rofilaunch.sh
    sed -i '2d' Configs/.local/lib/hyde/rofilaunch.sh

    # PATCH gamelauncher.sh
    sed -i 's|exec "\$cmd"|exec $cmd|' Configs/.local/lib/hyde/gamelauncher.sh

    # BUILD FONTS
    mkdir -p $out/share/fonts/truetype
    for fontarchive in ./Source/arcs/Font_*.tar.gz; do
      if [ -f "$fontarchive" ]; then
        tar xzf "$fontarchive" -C $out/share/fonts/truetype/
      fi
    done

    # BUILD GRUB THEMES
    mkdir -p $out/share/grub/themes
    tar xzf ./Source/arcs/Grub_Retroboot.tar.gz -C $out/share/grub/themes
    tar xzf ./Source/arcs/Grub_Pochita.tar.gz -C $out/share/grub/themes

    # BUILD ICONS
    mkdir -p $out/share/icons
    tar xzf ./Source/arcs/Icon_Wallbash.tar.gz -C $out/share/icons

    # BUILD GTK THEME
    mkdir -p $out/share/themes
    tar xzf ./Source/arcs/Gtk_Wallbash.tar.gz -C $out/share/themes
  '';

  installPhase = ''
    mkdir -p $out
    cp -r . $out
  '';
}