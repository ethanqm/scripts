#!/usr/bin/bash
#
# --------------
#   - -  ;  - |
# --------------
#   | -  ;  | |
# --------------

left_screen="DP-3"
right_screen="HDMI-A-1"

IFS=$"\n"
state=($(kscreen-doctor -o | grep "Rotation\|Output" ))

#   determine which screen shows up first
first_screen=${state[0]}
second_screen=${state[1]}

IFS=$"\s"
# indecies weird, don't sweat
first_rotation=${state[1]:8:1}
second_rotation=${state[2]:8:1}

l_screen_rot=$([[ $first_screen =~ $left_screen ]] &&
	echo $first_rotation || echo $second_rotation )
r_screen_rot=$([[ $first_screen =~ $right_screen ]] &&
	echo $first_rotation || echo $second_rotation )



# right screen position depends on both screens' rotation
function setHorzHorz () {
  kscreen-doctor output.$left_screen.rotation.none \
    output.$right_screen.rotation.none 
  kscreen-doctor output.$left_screen.position.0,0 \
    output.$right_screen.position.1920,0
}
function setVertHorz () {
  kscreen-doctor output.$left_screen.rotation.left \
    output.$right_screen.rotation.none 
  kscreen-doctor output.$left_screen.position.0,0 \
    output.$right_screen.position.1080,420
}
function setHorzVert () {
  kscreen-doctor output.$left_screen.rotation.none \
    output.$right_screen.rotation.right
  kscreen-doctor output.$left_screen.position.0,0 \
    output.$right_screen.position.1920,-420
}
function setVertVert () {
  kscreen-doctor output.$left_screen.rotation.left \
    output.$right_screen.rotation.right
  kscreen-doctor output.$left_screen.position.0,0 \
    output.$right_screen.position.1080,0
}

# screen rotation vales; 1: horizontal, 2: left, 8 right
function toggleLeftScreen () {
  case $l_screen_rot in 
    1) case $r_screen_rot in 
      1) setVertHorz ;; # | -
      8) setVertVert ;; # | |
       esac ;;
    2) case $r_screen_rot in
      1) setHorzHorz ;;  # - -
      8) setHorzVert ;;  # - |
      *) notify-send "bad right screen rotation: $r_screen_rot"
       esac ;;
    *) notify-send "bad screen rotation left: $l_screen_rot right: $r_screen_rot"
  esac
}
function toggleRightScreen () {
  case $r_screen_rot in 
    1) case $l_screen_rot in 
      1) setHorzVert ;; # - |
      2) setVertVert ;; # | |
       esac ;;
    8) case $l_screen_rot in
      1) setHorzHorz ;;  # - -
      2) setVertHorz ;;  # | -
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
