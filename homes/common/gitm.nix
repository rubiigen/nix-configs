_: {
  # enable programs
  programs = {
    git = {
	enable = true;
	userName = "beanigen";
	userEmail = "mailto:***REMOVED***";
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
