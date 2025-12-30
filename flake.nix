{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {

      packages.${system}.default = pkgs.stdenv.mkDerivation rec {
        pname = "pianoteq_trial";
        version = "9.1.0";
        src = pkgs.requireFile {
          name = "pianoteq_trial_v910.tar.xz";
          sha256 = "wCBTVFKZ7Nl5IEHFI3vyffVQdVtNrG3FLpxh6v9H6Ec=";
          url = "https://www.modartt.com/try?file=pianoteq_trial_v910.tar.xz";
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
          # runHook preInstall
          mkdir -p $out/bin
          mv -t $out/bin x86-64bit/Pianoteq\ 9
          # runHook postInstall
        '';
      };

    };
}
