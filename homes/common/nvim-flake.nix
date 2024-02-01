{inputs, ...}: { 

  imports = [ inputs.neovim-flake.homeManagerModules.default ];
  # enable programs
  programs = {
    neovim-flake.enable = true;
    # ... add more programs as you see fit
  };
}
