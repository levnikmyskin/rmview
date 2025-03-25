{
  description = "Fast live viewer for reMarkable 1 and 2";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in rec {
      packages.rmview = pkgs.callPackage ./default.nix {
        inherit (pkgs.qt5) wrapQtAppsHook;
      };
      packages.default = packages.rmview;

      apps.default = {
        type = "app";
        program = "${self.packages.${system}.rmview}/bin/rmview";
      };

      devShells.default = pkgs.mkShell {
        inputsFrom = [self.packages.${system}.rmview];
        packages = with pkgs; [
          qt5.qttools # for pyrcc5
        ];
      };
    });
}
