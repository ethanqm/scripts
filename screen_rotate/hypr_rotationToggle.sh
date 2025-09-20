#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash
#
# --------------
#   - -  ;  - |
# --------------
#   | -  ;  | |
# --------------

left_screen="DP-3"
right_screen="HDMI-A-1"

IFS=$'\n'
state=($(hyprctl monitors | grep "Monitor\|transform"))

first_screen=${state[0]}
second_screen=${state[2]}

first_rotation=${state[1]: -1}
second_rotation=${state[3]: -1}

l_screen_rot=$([[ $first_screen =~ $left_screen ]] &&
	echo $first_rotation || echo $second_rotation )
r_screen_rot=$([[ $first_screen =~ $right_screen ]] &&
	echo $first_rotation || echo $second_rotation )

# right screen position depends on both screens' rotation
function setHorzHorz () {
	hyprctl keyword monitor $left_screen,preferred,0x0,1,transform,0
	hyprctl keyword monitor $right_screen,preferred,1920x0,1,transform,0
}
function setVertHorz () {
	hyprctl keyword monitor $left_screen,preferred,0x0,1,transform,1
	hyprctl keyword monitor $right_screen,preferred,1080x420,1,transform,0
	}
function setHorzVert () {
	hyprctl keyword monitor $left_screen,preferred,0x0,1,transform,0
	hyprctl keyword monitor $right_screen,preferred,1920x-420,1,transform,3
	}
function setVertVert () {
	hyprctl keyword monitor $left_screen,preferred,0x0,1,transform,1
	hyprctl keyword monitor $right_screen,preferred,1080x0,1,transform,3
	}

# screen rotation vales; 1: horizontal, 2: left, 3 right
function toggleLeftScreen () {
  case $l_screen_rot in 
    0) case $r_screen_rot in 
      0) setVertHorz ;; # | -
      3) setVertVert ;; # | |
       esac ;;
    1) case $r_screen_rot in
      0) setHorzHorz ;;  # - -
      3) setHorzVert ;;  # - |
      *) notify-send "bad right screen rotation: $r_screen_rot"
       esac ;;
    *) notify-send "bad screen rotation left: $l_screen_rot right: $r_screen_rot"
  esac
}
function toggleRightScreen () {
  case $r_screen_rot in 
    0) case $l_screen_rot in 
      0) setHorzVert ;; # - |
      1) setVertVert ;; # | |
       esac ;;
    3) case $l_screen_rot in
      0) setHorzHorz ;;  # - -
      1) setVertHorz ;;  # | -
      *) notify-send "bad left screen rotation: $l_screen_rot"
       esac ;;
    *) notify-send "bad screen rotation right: $r_screen_rot left: $l_screen_rot"
  esac
}
if [ $1 == "left" ]; then
	toggleLeftScreen
elif [ $1 == "right" ]; then
	toggleRightScreen
else
	notify-send "Unrecognised arg $@"
fi
