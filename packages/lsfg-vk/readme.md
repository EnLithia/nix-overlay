# lsfg-vk (local package)

Vendored copy of the `lsfg-vk` 2.0.0 package from nixpkgs-unstable, built against the stable (26.05) toolchain.

## Why this exists

Stable nixpkgs only ships lsfg-vk 1.0.0. Installing 2.0.0 straight from unstable builds it with unstable's newer GCC, and the layer then fails to load on a stable system:

```
libstdc++.so.6: version `GLIBCXX_3.4.35' not found
  (required by .../lsfg-vk-2.0.0/lib/liblsfg-vk-layer.so)
Requested layer "VK_LAYER_LSFGVK_frame_generation" failed to load.
```

Building the same expression with the stable package set (`callPackage` from the stable `pkgs`) fixes the mismatch.

## Usage

Wire it into an overlay using the stable package set:

```nix
self: super: {
  nathanlithia = {
    lsfg-vk = super.callPackage ./packages/lsfg-vk/package.nix {};
  };
}
```

Then install it:

```nix
environment.systemPackages = [ pkgs.nathanlithia.lsfg-vk ];
```

Requirements:

- `nixpkgs.config.allowUnfree = true;` (license is CC BY-NC-ND)
- Remove any `unstable.lsfg-vk` entry so only one copy and one Vulkan manifest are in the profile

## Verify

```
VK_LOADER_DEBUG=all vkcube 2>&1 | grep -iE "lsfg|GLIBCXX"
```

Expected: `Loaded lsfg-vk layer version 2.0.0`, no `GLIBCXX` error, no "failed to load".

## Updating

1. Change `version` in `package.nix`.
2. Set `hash = lib.fakeHash;`, rebuild, and copy the real hash from the error.
3. Rebuild with `sudo nixos-rebuild switch`.

Once stable nixpkgs ships 2.0.0 or newer, this local copy can be removed in favor of `pkgs.lsfg-vk`.

## Notes

- Requires a copy of Lossless Scaling (`Lossless.dll`) to actually generate frames.
- Profiles live in `~/.config/lsfg-vk/conf.toml`.
- Set `DISABLE_LSFGVK=1` to disable the layer for a single run.
- `postFixup` adds the Vulkan loader to the rpath of `lsfg-vk-cli`; without it the CLI fails with "Failed to load vulkan library!".
