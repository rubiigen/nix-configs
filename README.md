# funny nixos configs

# So, what is everything?
+ Venus - maya's Surface Book 2
+ Alyssum - maya's goofy Kaby Lake rig
+ Millwright - alyx's Coffee Lake Rig
+ Hyperion - alyx's Acer ConceptD (CC715)
+ Nomad - alyx's ThinkPad L13 Gen 2 (AMD)
+ Jupiter - alyx's MacPro5,1 

# But, why?
There was a couple motivators that moved me personally to nix, here are a couple
+ Firstly, NVIDIA. I was fed up of having to go through the effort to fix nvidia every time i reinstalled my OS
+ Secondly, talk of reinstalling... I reinstall my OS often and installing drivers, etc got boring fast.
+ Furthermore, the configuration is genuinely quicker to do in nixos because its just a programming language essentially
+ Lastly, I know how to set up qemu-kvm w/ gpu passthrough in nixos, can't say that about most other distros

# Thats all well and good, what is in this config?

+ homes - this is home manager setup. This is split by host and has a `common` folder that all the per host comfigs use. This is done for splitting stuff like sway configs
+ hosts - again, split by host, this is the configuration.nix's of each system
+ wallpapers - just wallpapers so that they can be pulled in with a git clone
+ README - the document you're reading right now! :p
+ flake.lock - this locks our config to a certain point in time (and is updated by running `nix flake update` - very helpful for keeping a system as is
+ flake.nix - this is the main flake file! basically everything branches off this
+ shell.nix - special shell file to use with `nix-shell`
+ tape.nix - something maya conjured up for DTS tape archival :3

# Can I do anything?
Yes! contributions are very warmly welcomed! Noticed something that can be done better? make a pull request!

# Should I use nixos
No. God no. While I kid, the documentation is a bit lacklustre so do go in with an open mind!

# Who to thank for this hellscape

+ notashelf - otherwise known as raf - got me into nixos in the first place - is also the person i stole the really nice ags conf from
+ floppydisk - shamelessly stole stuff from his config on more than one occasion
+ multiple others I forget

# Thanks for taking the time to read this dumpster fire!

-alyx + maya
