# funny nixos configs

# So, what is everything?
+ Millwright - alyx's Coffee Lake Rig
+ Nomad - alyx's ThinkPad L13 Gen 2 (AMD)
+ Jupiter - alyx's MacPro5,1 
+ Firefly - Dell XPS M1330 (not added yet. Has not arrived yet.

# But, why?
There was a couple motivators that moved me personally to nix, here are a couple
+ Firstly, NVIDIA. I was fed up of having to go through the effort to fix nvidia every time i reinstalled my OS
+ Secondly, talk of reinstalling... I reinstall my OS often and installing drivers, etc got boring fast.
+ Furthermore, the configuration is genuinely quicker to do in nixos because its just a programming language essentially
+ Lastly, I know how to set up qemu-kvm w/ gpu passthrough in nixos, can't say that about most other distros (not as big a thing as it used to be, for now i run my OS in a PVE container)

# Thats all well and good, what is in this config?

+ homes - this is home manager setup. This is split by host and has a `common` folder that all the per host comfigs use. This is done for splitting stuff like sway configs
+ hosts - again, split by host, this is the configuration.nix's of each system
+ wallpapers - just wallpapers so that they can be pulled in with a git clone
+ README - the document you're reading right now! :p
+ flake.lock - this locks our config to a certain point in time (and is updated by running `nix flake update` - very helpful for keeping a system as is
+ flake.nix - this is the main flake file! basically everything branches off this

# Can I do anything?
Yes! contributions are very warmly welcomed! Noticed something that can be done better? make a pull request!

# Should I use nixos
No. God no. While I kid, the documentation is a bit lacklustre so do go in with an open mind!

# Who to thank for this hellscape

+ notashelf - otherwise known as raf - got me into nixos in the first place - is also the person i stole the really nice ags conf from
+ floppydisk - shamelessly stole stuff from his config on more than one occasion
+ multiple others I forget
+ aegiscarr - halftone-hot-pink.png && halftone-purple.png @ wallpapers/

# Thanks for taking the time to read this dumpster fire!

-alyx
