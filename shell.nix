{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {

  packages = [
    (pkgs.python311.withPackages(ps: with pkgs; [ 
      python311Packages.distutils-extra python311Packages.distlib
    ]))
  ];

  buildInputs = with pkgs; [
    ncurses zlib gawk wget gettext openssl libxslt wget unzip gnumake   ];
  
  shellHook = ''
   ssh root@192.168.7.1 "sysupgrade -b /tmp/backup-image-builder.tar.gz"
   rm -Rf ./.nix-shell
   mkdir -p ./.nix-shell
   scp root@192.168.7.1:/tmp/backup-image-builder.tar.gz ./.nix-shell
   tar xvf .nix-shell/backup-image-builder.tar.gz
   rm -Rf ./imagebuilder-resize-squashfs/inject_files
   mkdir -p ./imagebuilder-resize-squashfs/inject_files
   mv etc ./imagebuilder-resize-squashfs/inject_files/
   cd ./imagebuilder-resize-squashfs/
   alias build="sudo bash ./resize-squashfs.sh"
  '';

  LOCALE_ARCHIVE = if pkgs.stdenv.isLinux then "${pkgs.glibcLocales}/lib/locale/locale-archive" else "";
}

# vim: set tabstop=2 shiftwidth=2 expandtab:

