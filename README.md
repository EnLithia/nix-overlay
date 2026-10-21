To add overlay use:
```
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = "https://github.com/EnLithia/nix-overlay/archive/refs/heads/main.tar.gz";
    }))
  ];
```
To install packages do:
```
  environment.systemPackages = with pkgs; [
    EnLithia.vdl
    EnLithia.gdl
    EnLithia.mdl
    EnLithia.mvdl
    EnLithia.gallery-dl
  ];
```
To get a hash of a repo use:
```
nix-prefetch-github mikf gallery-dl --rev v1.30.5
```
