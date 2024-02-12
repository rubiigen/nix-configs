{
  exec-once = [
    "waybar"
    "swaybg --image ~/.config/nixos/wallpapers/front.png --mode fill"
    "nm-applet"
    "blueman-applet"
    "swaync"
    "udiskie &"
    "dbus-update-activation-environmnt --systemd DISPLAY WAYLAND-DISPLAY"
    "bash ~/.config/lockonsleep/config.sh"
    "swayosd-server"
  ];

  monitor = [
    "DP-3,1920x1080@239.760,1200x520,1"
    "DVI-D-1,1600x1200,0x0,1,transform,3"
  ];

  "env" = "XCURSOR_SIZE,24";
  "$mod" = "SUPER";
  input = {
    kb_layout = "us";
    follow_mouse = 1;
    touchpad.natural_scroll = "no";
    sensitivity = 0;
    accel_profile = "flat";
  };

  general = {
    gaps_in = 5;
    gaps_out = 20;
    border_size = 2;
    "col.active_border" = "rgba(cba6f7ff) rgba(cba6f7ff) 45deg";
    "col.inactive_border" = "rgba(440C88FF)";
    layout = "dwindle";
  };

  decoration = {
    rounding = 10;
    blur = {
      enabled = true;
      size = 8;
      passes = 1;
      new_optimizations = 1;
    };
    drop_shadow = "yes";
    shadow_range = 4;
    shadow_render_power = 3;
    "col.shadow" = "rgba(1a1a1aee)";
  };

  windowrulev2 = [
    "float, title:^(Picture-in-Picture)$"
    "pin, title:^(Picture-in-Picture)$"
    "move 67% 72%, title:^(Picture-in-Picture)$"
    "size 33% 28%, title:^(Picture-in-Picture)$"
  ];

  animations = {
    enabled = true;
    bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
    animation = [
      "windows, 1, 7, myBezier"
      "windowsOut, 1, 7, default, popin 80%"
      "border, 1, 10, default"
      "borderangle, 1, 8, default"
      "fade, 1, 7, default"
      "workspaces, 1, 6, default"
    ];
  };

  dwindle = {
    pseudotile = true;
    preserve_split = "yes";
  };

  master = {
    new_is_master = true;
  };

  gestures = {
    workspace_swipe = false;
  };

  misc = {
    disable_hyprland_logo = true;
  };

  binde = [
    # Volume stuffs
    ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
    ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
    ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
  ];
  bind = [
    # basic binds
    "$mod, Return, exec, foot"
    "$mod SHIFT, Q, killactive, "
    "$mod, M, exit, "
    "$mod SHIFT, space, togglefloating, "
    "$mod, S, exec, wofi --show drun"
    "$mod, E, exec, nemo"
    "$mod, P, pseudo,"
    "$mod, J, togglesplit,"
    "$mod SHIFT, F, exec, hyprctl dispatch exit"
    "$mod SHIFT, S, exec, grim -g \"$(slurp)\" - | wl-copy"
    "$mod, left, movewindow, l"
    "$mod, right, movewindow, r"
    "$mod, up, movewindow, up"
    "$mod, down, movewindow, down"
    "$mod, T, fullscreen"
    # Switch workspaces
    "$mod, 1, workspace, 1"
    "$mod, 2, workspace, 2"
    "$mod, 3, workspace, 3"
    "$mod, 4, workspace, 4"
    "$mod, 5, workspace, 5"
    "$mod, 6, workspace, 6"
    "$mod, 7, workspace, 7"
    "$mod, 8, workspace, 8"
    "$mod, 9, workspace, 9"
    # Move a window to a given workspace
    "$mod SHIFT, 1, movetoworkspace, 1"
    "$mod SHIFT, 2, movetoworkspace, 2"
    "$mod SHIFT, 3, movetoworkspace, 3"
    "$mod SHIFT, 4, movetoworkspace, 4"
    "$mod SHIFT, 5, movetoworkspace, 5"
    "$mod SHIFT, 6, movetoworkspace, 6"
    "$mod SHIFT, 7, movetoworkspace, 7"
    "$mod SHIFT, 8, movetoworkspace, 8"
    "$mod SHIFT, 9, movetoworkspace, 9"
    # Use mouse to scroll through existing workspaces
    "$mod, mouse_down, workspace, e+1"
    "$mod, mouse_up, workspace, e-1"
  ];
  bindm = [
    "$mod, mouse:272, movewindow"
    "$mod, mouse:273, resizewindow"
  ];
}
