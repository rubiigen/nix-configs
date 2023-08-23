_: {
  # enable programs
  programs = {
    git = {
	enable = true;
	userName = "RionWren";
	userEmail = "rionwren@proton.me";
	extraConfig = {
		commit.gpgsign = true;
		gpg.format = "ssh";
		user.signingkey = "~/.ssh/id_ed25519.pub";
		init.defaultBranch = "master";
        };
    };
    firefox.enable = true;
    neovim.enable = true;
    # ... add more programs as you see fit
  };
}
