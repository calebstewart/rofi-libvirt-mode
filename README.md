# Rofi Libvirt Mode
This repository implements a custom Rofi script mode for interacting with libvirt domains.
The main menu shows a list of libvirt domains. Upon selecting a domain, a set of options
is provided for starting, stopping, editing or viewing the domain depending on the domain
state.

There is not currently any options for force-stopping or restarting a domain. This is mainly
for quickly interactin with domains and side-stepping the normal `virt-manager` UI, which
I dislike for my workflows.

The script depends on:

* `virt-manager` for editing VMs
* `virsh` for starting/stopping VMs
* `grep` and `coreutils` for parsing the output of `virsh`
* `virt-viewer` for opening a VM

The script assumes that `LIBVIRT_DEFAULT_URI` is set in the environment which is necessary
becasuse a connection argument is required to open `virt-manager` with a specific domain
view target. It is also obviously used by `virsh` to define the connection to be used.

## Installation
The `rofi-libvirt-mode` script can be placed anywhere. If you don't want to use the
absolute script path in your Rofi commands, you should place it under a directory
in your path (e.g. `~/.local/bin` is commonly in the user path).

In NixOS, you can add this repository as an input to your flake:

```nix
inputs.rofi-libvirt-mode = {
  url = "github:calebstewart/rofi-libvirt-mode";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

Then, add the package to `environment.systemPackages` for NixOS or `home.packages`:

```nix
# For NixOS
environment.systemPackages = [rofi-libvirt-mode.packages.${system}.default];

# For Home Manager
home.packages = [rofi-libvirt-mode.packages.${system}.default];
```

Alternatively, you could generate command strings with the absolute Nix Store path
directly in your config without installing the command globally. For example, in
Hyprland, you could set:

```nix
wayland.windowManager.hyprland = {
  settings = {
    binds = [
      "SUPER, M, exec, rofi -show libvirt -modes \"libvirt:${rofi-libvirt-mode.packages.${system}.default}/bin/rofi-libvirt-mode\""
    ];
  };
};
```

## Usage
If installed within your path, you can execute the libvirt mode with:

```sh
rofi -show libvirt -modes "libvirt:rofi-libvirt-mode"
```

For more information on running custom script modes for rofi, see `man 5 rofi-script`.
