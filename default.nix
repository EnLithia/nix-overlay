self: super: {
  enlithia = {
    gallery-dl = super.callPackage ./packages/gallery-dl/package.nix {};
    yt-dlp = super.callPackage ./packages/yt-dlp/package.nix {};
    alvr = super.callPackage ./packages/alvr/package.nix {};
    lsfg-vk = super.callPackage ./packages/lsfg-vk/package.nix {};

    vdl = super.writeShellScriptBin "vdl" (builtins.readFile ./scripts/vdl.sh);
    mvdl = super.writeShellScriptBin "mvdl" (builtins.readFile ./scripts/mvdl.sh);
    mdl = super.writeShellScriptBin "mdl" (builtins.readFile ./scripts/mdl.sh);
    gdl = super.writeShellScriptBin "gdl" (builtins.readFile ./scripts/gdl.sh);
    pythonhere = super.writeShellScriptBin "pythonhere" (builtins.readFile ./scripts/pythonhere.sh);
    repair = super.writeShellScriptBin "repair" (builtins.readFile ./scripts/repair.sh);

  };
}
