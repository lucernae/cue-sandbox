{stdenv, autoPatchelfHook, curl, cacert, fetchurl, lib}:
stdenv.mkDerivation rec {
    pname = "dagger-cue";
    version = "0.2.232";
    src = fetchurl {
          url = "https://dl.dagger.io/dagger-cue/install.sh";
          sha256 = "sha256-Z+KUuOhzrv00AzENIbe1/AvC9pREYXbT/iSJtHC1OqE=";
    };
    dontUnpack = true;
    buildInputs = [ curl cacert ];
    nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
    dontStrip = stdenv.isDarwin;
    installPhase = ''
        mkdir -p $out $out/bin
        cat $src | VERSION="${version}" BIN_DIR=$out/bin sh
    '';
    meta = {
        description = "Dagger SDK for CUE";
        platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
    };
}