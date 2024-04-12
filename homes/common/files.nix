{
  pkgs,
  lib,
  inputs,
  ...
}: {
   home = {
     file.".config/hypr/hyprlock.conf".source= ./hyprlock.conf;
     file.".config/lockonsleep/config.sh".source = ./lock.sh;
     file.".config/foot/foot.ini".source = ./foot.ini;
   };
}
