{ config, pkgs, pkgs-unstable, inputs, ... }: 
{  
  nixpkgs = { 
    overlays = [
      (self: super: {
        update-sys = pkgs.writeScriptBin "update-sys" ''
          cd ~/.config/home-manager
          # this is just to make sure that it can update
          git reset --hard;git pull
          nix flake update
          nix-channel --update
          home-manager switch -b backup
          # flatpak is installed by default so added just in case
          if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ];then
            pkexec --user deck flatpak update
          else
            flatpak update
          fi
        '';
      })
      (final: prev: {
        qsp-tools = inputs.qsp-flake.packages."${pkgs.system}".default;
      })
    ];
  };
}
