_: {
  # enable programs
  programs = {
    waybar.enable = true;
    git = {
	enable = true;
	userName = "RionWren";
	userEmail = "rionwren@proton.me";
	extraConfig = {
	# ssh key signed commits (why)
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
