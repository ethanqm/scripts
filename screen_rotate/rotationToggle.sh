#!/usr/bin/bash
#
# --------------
#   - -  ;  - |
# --------------
#   | -  ;  | |
# --------------

state=($(kscreen-doctor -o | grep Rotation ))
#for word in "${state[@]}"; do
#  echo "word: $word"
#done
l_dirty=${state[2]} # has ANSI colors at the start
r_dirty=${state[5]} # has ANSI colors at the start
l=${l_dirty:6:1} # left screen rotation state
r=${r_dirty:6:1} # right screen rotation state

#echo "L: $l"
#echo "R: $r"

function setHorzHorz () {
	kscreen-doctor output.DP-3.rotation.none
	kscreen-doctor output.HDMI-A-1.rotation.none
	kscreen-doctor output.DP-3.position.0,0
	kscreen-doctor output.HDMI-A-1.position.1920,0
}
function setVertHorz () {
	kscreen-doctor output.DP-3.rotation.left
	kscreen-doctor output.HDMI-A-1.rotation.none
	kscreen-doctor output.DP-3.position.0,0
	kscreen-doctor output.HDMI-A-1.position.1080,420
}
function setHorzVert () {
	kscreen-doctor output.DP-3.rotation.none
	kscreen-doctor output.HDMI-A-1.rotation.left # change when longer cable
	kscreen-doctor output.DP-3.position.0,0
	kscreen-doctor output.HDMI-A-1.position.1920,-420
}

function setVertVert () {
	kscreen-doctor output.DP-3.rotation.left
	kscreen-doctor output.HDMI-A-1.rotation.left # change when longer cable
	kscreen-doctor output.DP-3.position.0,0
	kscreen-doctor output.HDMI-A-1.position.1080,0
}

function toggleLeftScreen () {
	# $l or $r: 1 means horizontal, 2 means rotate left
	case $l in 
		1) case $r in 
			1) setVertHorz ;; # | -
			2) setVertVert ;; # | |
		   esac ;;
		2) case $r in
			1) setHorzHorz ;;  # - -
			2) setHorzVert ;;  # - |
			*) notify-send "weird r value: $r"
		   esac ;;
	  *) notify-send "weird l value: $l r: $r"
  esac
}
function toggleRightScreen () {
	# $l or $r: 1 means horizontal, 2 means rotate left
	case $r in 
		1) case $l in 
			1) setHorzVert ;; # - |
			2) setVertVert ;; # | |
			 esac ;;
		2) case $l in
			1) setHorzHorz ;;  # - -
			2) setVertHorz ;;  # | -
			*) notify-send "weird l value: $l"
		   esac ;;
	  *) notify-send "weird r value: $r l: $l"
  esac
}

if [ $1 == "left" ]; then
	toggleLeftScreen
elif [ $1 == "right" ]; then
	toggleRightScreen
else
	notify-send "Unrecognised arg $@"
fi
