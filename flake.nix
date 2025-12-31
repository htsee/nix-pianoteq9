{
  description = "A flake for pianoteq9";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      ver = "9.1.0";
      verForFile = v: builtins.replaceStrings [ "." ] [ "" ] v;
    in
    {

      packages.${system}.default = pkgs.stdenv.mkDerivation rec {
        pname = "pianoteq_trial";
        version = ver;
        src = pkgs.requireFile {
          name = "pianoteq_trial_v${verForFile ver}.tar.xz";
          sha256 = "wCBTVFKZ7Nl5IEHFI3vyffVQdVtNrG3FLpxh6v9H6Ec=";
          url = "https://www.modartt.com/try?file=pianoteq_trial_v${verForFile ver}.tar.xz";
        };

        nativeBuildInputs = with pkgs; [
          autoPatchelfHook
          copyDesktopItems
          makeWrapper
          librsvg
        ];

        buildInputs = with pkgs; [
          (lib.getLib stdenv.cc.cc)
          alsa-lib
          freetype
          libglvnd
        ];

        installPhase = ''
                              mkdir -p $out/bin
          										mkdir -p $out/lib/vst3
          										mkdir -p $out/lib/lv2
                              mv -t $out/bin x86-64bit/Pianoteq\ 9
                    					mv -t $out/lib/vst3 x86-64bit/Pianoteq\ 9.vst3
                    					mv -t $out/lib/lv2 x86-64bit/Pianoteq\ 9.lv2
        '';
      };

    };
}
