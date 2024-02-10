{
  inputs,
  pkgs,
  home,
  ...
}: {

  home.packages = [pkgs.webcord-vencord];

  services.arrpc.enable = true;
}
