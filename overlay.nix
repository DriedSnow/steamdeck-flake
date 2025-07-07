{ config, pkgs, inputs, ... }: 
{  
  nixpkgs = { 
    overlays = [
      (self: super: {
        update-sys = pkgs.writeScriptBin "update-sys" ''
          cd ~/.config/home-manager
          git pull
          nix-channel --update
          home-manager switch -b backup
          # flatpak is installed by default so added just in case
          flatpak update
        '';
      })
      (final: prev: {
        qsp-tools = inputs.qsp-flake.packages."${pkgs.system}".default;
      })
    ];
  };
}
