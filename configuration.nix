#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#Infinity config {{{
# Let's me boot {{{
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  # No, I wanna rice :)
  boot.loader.grub.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.extraModulePackages = with config.boot.kernelPackages; [ zenpower ];
  boot.blacklistedKernelModules = [ "k10temp" ];
  boot.kernelModules = [ "zenpower" ];

  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}"
  ];

  networking.hostName = "Infinity"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  
  # Virtualization 
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [ virt-manager ];

# Set your time zone.
  time.timeZone = "Europe/Zagreb";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  #  useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.windowManager.awesome.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
# }}}
 # Services {{{
   #adb {{{
     programs.adb.enable = true;
#}}}
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e,caps:escape";
  # Printing {{{
  # services.printing.enable = true;
#}}}

  # Sound {{{
#  sound.enable = true;
#  hardware.pulseaudio.enable = true;
#pipewire
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  # If you want to use JACK applications, uncomment this
  jack.enable = true;
};
#}}}

  # AMD {{{
   # {{{ Vulkan
   hardware.opengl.extraPackages = with pkgs; [
   amdvlk
   ];
  # }}}
 #}}}
#}}}
# Packages {{{
  # kdeconnect
   programs.kdeconnect.enable = true;

  # Enable unsafe packages
  nixpkgs.config.allowUnfree = true;  

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.infinity = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      autoPatchelfHook
      aseprite
      awesome
      blender
      blender-hip
      bun
      cbonsai
      cool-retro-term
      clang
      clinfo
#      discord
      (pkgs.discord.override  {
        withOpenASAR = true;
        withVencord = true;
      })
      fish
      firefox
      flameshot
      flatpak
      gcc
      git
      gnome.gnome-disk-utility
      gnome.nautilus
      gnome-usage
      gnome.gnome-software
      go-mtpfs
      gparted
      heroic
      htop
      inkscape
      itch
      kdenlive
      keepassxc
      kitty
      krita
      legendary-gl
      libstdcxx5
      libnotify
      librewolf
      libsForQt5.kdeconnect-kde
      libwacom
      lmms
      lolcat
      lutris
      mc
      mpv
      neovim
      neo-cowsay
      nodejs_18
      nvtop-amd
      osu-lazer
      obs-studio
      pokemonsay
      prismlauncher
      pavucontrol
      protonup-qt
      protontricks
      python3
      steam-run
      stdenv.cc.cc.lib
      scrcpy
      spice-vdagent
      spotify
      syncthing
      svkbd
      tree
      unzip
      virtualbox
      wget
      weather
      wine
      winetricks
      qemu
      qownnotes
      qpwgraph
      xsecurelock
      zenmonitor
      zig
   ];
};

  nixpkgs.config.permittedInsecurePackages = [
   "electron-11.5.0"
];




#}}}
# Not needed a lot {{{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
#}}}
#}}}

# vim:foldmethod=marker
