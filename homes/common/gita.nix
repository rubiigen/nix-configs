_: {
  # enable programs
  programs = {
    git = {
	enable = true;
	userName = "MadamBwabbington";
        userEmail = "beansoup112@protonmail.com";
	extraConfig = {
		commit.gpgsign = true;
		gpg.format = "ssh";
		user.signingkey = "~/.ssh/id_ed25519.pub";
		init.defaultBranch = "master";
        };
    };
    # ... add more programs as you see fit
  };
}
