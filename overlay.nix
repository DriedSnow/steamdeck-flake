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
            echo "Flatpak update is not allowed over ssh as it needs root when over ssh"
          else
            flatpak update
          fi
          # this is because i think it does not update nix. home-manager updates its self.
          nix profile upgrade nix
        '';
      })
      (final: prev: {
        # qsp-tools = inputs.qsp-flake.packages."${pkgs.system}".default;
        Qqsp = inputs.qsp-tools.packages."${pkgs.system}".Qqsp;
        qgen = inputs.qsp-tools.packages."${pkgs.system}".qgen;
      })
    ];
  };
}
