{
  description = "My Home Manager configuration";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    qsp-flake = {
      url = "git+ssh://git@github.com/DriedSnow/qsp-flake.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      # url = "github:nix-community/home-manager/master";
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, qsp-flake, nix4nvchad, ... }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      extraSpecialArgs = { inherit system inputs; };
    in {
      homeConfigurations = {
        "deck" = home-manager.lib.homeManagerConfiguration {
          inherit extraSpecialArgs;
          inherit pkgs;
          modules = [ ./home.nix ];
        };
      };
    };
}
