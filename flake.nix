{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    elisp-helpers.url = "github:emacs-twist/elisp-helpers";

    gnu-elpa = {
      url = "github:elpa-mirrors/elpa";
      flake = false;
    };
    nongnu = {
      url = "github:elpa-mirrors/nongnu";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      eachSystem =
        f:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = eachSystem (pkgs: {
        package-lists = pkgs.callPackage ./package-lists.nix {
          gnu-elpa = inputs.gnu-elpa + "/elpa-packages";
          nongnu = inputs.nongnu + "/elpa-packages";
          inherit (inputs) elisp-helpers;
        };
      });
    };
}
