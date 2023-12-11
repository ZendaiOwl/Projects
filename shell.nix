let
  pkgs = import <nixpkgs> { };

  libraries = with pkgs;[
    webkitgtk
    gtk3
    cairo
    gdk-pixbuf
    glib
    dbus
    openssl_3
  ];

  packages = with pkgs; [
    pkg-config
    dbus
    openssl_3
    glib
    gtk3
    libsoup
    webkitgtk
    appimagekit
  ];
in
pkgs.mkShell {
  buildInputs = packages;

  shellHook =
    ''
      export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH
    '';
  preFixup = ''
    gappsWrapperArgs+=(
      --set WEBKIT_DISABLE_COMPOSITING_MODE 1
      --prefix XDG_DATA_DIRS : ${pkgs.lib.concatMapStringsSep ":" (x: "${x}/share") [ pkgs.gnome.adwaita-icon-theme pkgs.shared-mime-info ]}
      --prefix XDG_DATA_DIRS : ${pkgs.lib.concatMapStringsSep ":" (x: "${x}/share/gsettings-schemas/${x.name}") [ pkgs.glib pkgs.gsettings-desktop-schemas pkgs.gtk3 ]}
      --prefix GIO_EXTRA_MODULES : ${pkgs.glib-networking}/lib/gio/modules
    )
  '';
}

