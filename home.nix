{ config, pkgs, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "deck";
  home.homeDirectory = "/home/deck";

  imports = [
    inputs.nix4nvchad.homeManagerModule
    ./overlay.nix
  ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  # added the builtins.attrValues and inherit as it is better then with and i dont want to type pkgs. all the time
  home.packages = builtins.attrValues {
    inherit (pkgs)
      qsp-tools
      onboard
      tldr
      trash-cli
      vlc
      yt-dlp
      ani-cli;
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/deck/etc/profile.d/hm-session-vars.sh
  #
  programs.bash = {
    enable = true;
  };
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  programs.nvchad = {
    enable = true;
    extraPackages = with pkgs; [
      nodePackages.bash-language-server
      docker-compose-language-service
      dockerfile-language-server-nodejs
      emmet-language-server
      nixd
      (python3.withPackages(ps: with ps; [
        python-lsp-server
        flake8
      ]))
    ];
    hm-activation = true;
    backup = true;
  };
  services.home-manager.autoUpgrade = {
    enable = true;
    frequency = "daily";
  };
  nix = {
    gc.automatic = true;
    gc.frequency = "weekly";
    gc.persistent = true;
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      builders = "ssh://build x86_64-linux /home/deck/.ssh/id_ed25519_build 16 2 nixos-test,big-parallel,kvm";
    };
  };

  # Let Home Manager install and manage itself.
  targets.genericLinux.enable = true;
  programs.home-manager.enable = true;
}
