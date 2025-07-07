{ config, pkgs, inputs, ... }: 
{  
  nixpkgs = { 
    overlays = [
      (final: prev: {
        qsp-tools = inputs.qsp-flake.packages."${pkgs.system}".default;
      })
    ];
  };
}
