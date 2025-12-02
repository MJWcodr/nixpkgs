{
  lib,
  stdenv,
  fetchzip,
  # glib,
  libgda6,
  gsound,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-shell-extension-copyous";
  version = "v1.1.3";

  src = fetchzip {
    url = "https://github.com/boerdereinar/copyous/releases/download/${finalAttrs.version}/copyous@boerdereinar.dev.zip";
    hash = "sha256-8LRj+wYKgMWJZYu0ViahatNEkiscCkPZEoLoitNoGbc=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    libgda6
  ];

  buildPhase = ''
    runHook preBuild
    # glib-compile-schemas --strict schemas
    runHook postBuild
  '';

  preInstall = ''
    # substituteInPlace extension.js \
    #  --replace-fail "import Gda from 'gi://Gda?version>=5.0'" "imports.gi.GIRepository.Repository.prepend_search_path('${libgda6}/lib/girepository-1.0'); const Gda = (await import('gi://Gda')).default" \
    #  --replace-fail "import GSound from 'gi://GSound'" "imports.gi.GIRepository.Repository.prepend_search_path('${gsound}/lib/girepository-1.0'); const GSound = (await import('gi://GSound')).default"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -r -T . $out/share/gnome-shell/extensions/pano@elhan.io
    runHook postInstall
  '';

  passthru = {
    extensionPortalSlug = "copyous";
    extensionUuid = "copyous@boerdereinar.dev";
  };

  meta = with lib; {
    description = "Modern Clipboard Manager for GNOME";
    homepage = "https://github.com/boerdereinar/copyous";
    license = licenses.gpl3;
    maintainers = with maintainers; [ mjwcodr ];
    platforms = platforms.linux;
  };
})
