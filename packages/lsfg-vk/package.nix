# lsfg-vk 2.0.0, vendored from nixpkgs-unstable.
#
# Import with the STABLE package set so it is built with the system's
# stdenv/libstdc++ (avoids "GLIBCXX_3.4.35 not found" when the layer loads):
#
#   nixpkgs.overlays = [
#     (final: prev: { lsfg-vk = final.callPackage ./lsfg-vk.nix { }; })
#   ];
#
# Needs nixpkgs.config.allowUnfree = true (CC BY-NC-ND license).
{
  lib,
  stdenv,
  fetchgit,
  cmake,
  vulkan-headers,
  vulkan-loader,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lsfg-vk";
  version = "2.0.0";

  src = fetchgit {
    url = "https://git.lsfg-vk.dev/lsfg-vk.git";
    tag = finalAttrs.version;
    # On version bump: set to lib.fakeHash, rebuild, copy the real hash.
    hash = "sha256-vp0/adJdVV73C2RFjcEE90KjWiZJQhiqqOlYQ89RG+Y=";
  };

  # Local patches go here, e.g. patches = [ ./my-fix.patch ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    vulkan-headers
  ];

  cmakeFlags = [
    (lib.cmakeFeature "LSFGVK_LAYER_LIBRARY_PATH" "${placeholder "out"}/lib/liblsfg-vk-layer.so")
    (lib.cmakeBool "LSFGVK_MANAGED" true)
  ];

  /*
    Without this: "terminate called after throwing an instance of
    'std::runtime_error' what(): Failed to load vulkan library!"
  */
  postFixup = ''
    patchelf --add-rpath "${lib.getLib vulkan-loader}/lib" "$out/bin/lsfg-vk-cli"
  '';

  # If 26.05 complains about either of these, delete the line.
  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Vulkan layer for frame generation (Requires owning Lossless Scaling)";
    homepage = "https://lsfg-vk.dev/";
    license = lib.licenses.cc-by-nc-nd-40;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      Gliczy
      pabloaul
    ];
    mainProgram = "lsfg-vk-cli";
  };
})
