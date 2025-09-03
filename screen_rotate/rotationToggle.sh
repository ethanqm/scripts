#!/usr/bin/bash
#
# --------------
#   - -  ;  - |
# --------------
#   | -  ;  | |
# --------------

state=($(kscreen-doctor -o | grep Rotation ))
l_dirty=${state[2]} # has ANSI colors at the start
r_dirty=${state[5]} # has ANSI colors at the start
# only take last character
l_screen_rot=${l_dirty:6:1}
r_screen_rot=${r_dirty:6:1}

left_screen="DP-3"
right_screen="HDMI-A-1"

# right screen position depends on both screens' rotation
function setHorzHorz () {
	kscreen-doctor output.$left_screen.rotation.none \
	  output.$right_screen.rotation.none \
	  output.$left_screen.position.0,0 \
	  output.$right_screen.position.1920,0
}
function setVertHorz () {
	kscreen-doctor output.$left_screen.rotation.left \
	  output.$right_screen.rotation.none \
	  output.$left_screen.position.0,0 \
	  output.$right_screen.position.1080,420
}
function setHorzVert () {
	kscreen-doctor output.$left_screen.rotation.none \
	  output.$right_screen.rotation.left \ # change when longer cable 
	  output.$left_screen.position.0,0 \
	  output.$right_screen.position.1920,-420
}

function setVertVert () {
	kscreen-doctor output.$left_screen.rotation.left \
	  output.$right_screen.rotation.left \ # change when longer cable
	  output.$left_screen.position.0,0 \
	  output.$right_screen.position.1080,0
}

# screen rotation vales; 1: horizontal, 2: left
function toggleLeftScreen () {
	case $l_screen_rot in 
		1) case $r_screen_rot in 
			1) setVertHorz ;; # | -
			2) setVertVert ;; # | |
		   esac ;;
		2) case $r_screen_rot in
			1) setHorzHorz ;;  # - -
			2) setHorzVert ;;  # - |
			*) notify-send "bad right screen rotation: r_screen_rot"
		   esac ;;
	  *) notify-send "bad screen rotation left: l_screen_rot right: r_screen_rot"
  esac
}
function toggleRightScreen () {
	case $r_screen_rot in 
		1) case $l_screen_rot in 
			1) setHorzVert ;; # - |
			2) setVertVert ;; # | |
			 esac ;;
		2) case $l_screen_rot in
			1) setHorzHorz ;;  # - -
			2) setVertHorz ;;  # | -
			*) notify-send "bad left screen rotation: l_screen_rot"
		   esac ;;
	  *) notify-send "bad screen rotation right: r_screen_rot left: l_screen_rot"
  esac
}

if [ $1 == "left" ]; then
	toggleLeftScreen
elif [ $1 == "right" ]; then
	toggleRightScreen
else
	notify-send "Unrecognised arg $@"
fi
