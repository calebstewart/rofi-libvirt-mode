{
  description = "Rofi Script Mode for controlling libvirt domains";

  # Nixpkgs / NixOS version to use.
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    packages = {
      rofi-libvirt-mode = pkgs.writeShellApplication {
        name = "rofi-libvirt-mode";
        
        runtimeInputs = with pkgs; [
          libvirt
          coreutils
          libnotify
          virt-viewer
          gnugrep
        ];

        text = builtins.readFile ./rofi-libvirt-mode;
      };

      default = self.packages.${system}.rofi-libvirt-mode;
    };
  });
}
