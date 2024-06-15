{inputs, ...}: { 
 # i apologise for how much of a fucking mess this file is lmfao -maya
  imports = [ inputs.nvf.homeManagerModules.default ];
  # enable programs
  programs = {
    neovim-flake = {
      enable = true;
      settings = {
        vim = {

          useSystemClipboard = true;
          theme = {
            enable = true;
            name = "catppuccin";
            style = "mocha";
          };

          languages = {
	    nix.enable = true;
            nix.lsp.enable = true;
	    ts.enable = true;
	    python.enable = true;
            python.lsp.enable = true;
	    html.enable = true;
            enableFormat = true;
            enableLSP = true;
            enableTreesitter = true;
          };
          
          startPlugins = [
            "plenary-nvim"
          ];

          autopairs.enable = true;

          statusline.lualine = {
            enable = true;
          };
          dashboard.startify = {
            enable = true;
            # idk need to configure this -maya
          };

          ui = {
            borders = {
              enable = true;
            };
            breadcrumbs.enable = true;
          };

          visuals.smoothScroll.enable = true;
          lsp = {
            enable = true;
          };
        };
      };
    };
    # ... add more programs as you see fit
  };
}
