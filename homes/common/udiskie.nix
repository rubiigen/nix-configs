{
  inputs,
  pkgs,
  home,
  ...
}: {
  services.udiskie = {
	enable = true;
	notify = false;
  };
}
