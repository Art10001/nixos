# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.wireless.iwd.enable = true;  # Enables wireless support via iwd.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Chile/Continental";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.windowManager.fluxbox.enable = true;
  ##services.xserver.windowManager.labwc.enable = true; #hmmmm
  #programs.labwc.enable = true;
  #programs.wayfire.enable = true; #no more wayland
  #services.xserver.desktopManager.gnome.enable = true; #gnome ruins networking

  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  hardware.pulseaudio.enable = true;
  services.pipewire.enable = false;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.reden = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     initialPassword = "pw123";
     packages = with pkgs; [
       tree
       openssl
       python311Packages.qrcode
     ];
   };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     curl
     lynx
     portablemc
     cool-retro-term
     google-chrome
     sysstat
     gcc
     gfortran
     qemu
     git
     openssl
     zlib
     mosh
     tor
     snowflake
     yggdrasil
     nload
     iftop
     nmap
     ffmpeg-full
     mpv
     nedit
     tmux
     appimage-run
     virtualenv
     python3
     bc
     python311Packages.qrcode
     nasm
     aria2
     imagemagick
     wineWowPackages.stableFull
     p7zip
     feh
     htop
     bemenu
     file
     inetutils
     tintin
     perl538Packages.DigestSHA3
     mupdf
     temurin-bin-8
     redshift
     xcalib
     parallel-full
     usb-modeswitch
     usb-modeswitch-data
     pkgs.linuxKernel.packages.linux_xanmod_stable.rtl8852bu #new driver
     #rtw89-firmware #maybe?; wasn't needed
     alsa-utils
     fish
   ];
nixpkgs.config.allowUnfree = true;
networking.nameservers = [ "94.140.14.14" ];
xdg.portal.enable = true;
xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
services.flatpak.enable = true;
services.picom.enable = false;
boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;
boot.kernelModules = [ "8852bu" ];
boot.extraModulePackages = with config.boot.kernelPackages; [ rtl8852bu ]; #new driver installed
environment.sessionVariables.NIXOS_OZONE_WL = "1";
##Nvidia
hardware.opengl.enable = true;
  # Load nvidia driver for Xorg and Wayland
services.xserver.videoDrivers = ["nvidia"]; #no more nvidia with xanmod; now trying manual update

#hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
#  version = "555.58.02";
#  sha256_64bit = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
#  sha256_aarch64 = "sha256-8hyRiGB+m2hL3c9MDA/Pon+Xl6E788MZ50WrrAGUVuY=";
#  openSha256 = "sha256-8hyRiGB+m2hL3c9MDA/Pon+Xl6E788MZ50WrrAGUVuY=";
#  settingsSha256 = "sha256-ZpuVZybW6CFN/gz9rx+UJvQ715FZnAOYfHn5jt5Z2C8=";
#  persistencedSha256 = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
#}; # no longer necessary after 24.11
hardware.nvidia.modesetting.enable = true;
hardware.nvidia.nvidiaSettings = true;
hardware.nvidia.forceFullCompositionPipeline = true;
hardware.nvidia.open = false;
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
 # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
######Nvidia
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
   services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
   networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

