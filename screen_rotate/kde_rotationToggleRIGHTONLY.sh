#!/usr/bin/env bash
#
# Now have 3 monitors
#  -- --  
#  --
# ------------------
#  -- |
#  --

bottom_screen="DP-2"
left_screen="DP-3"
right_screen="HDMI-A-1"

IFS=$"\n"
state=($(kscreen-doctor -o | grep "Rotation\|Output" ))

#   determine which screen shows up first
first_screen=${state[0]}
second_screen=${state[1]}
third_screen=${state[2]}

IFS=$"\s"
# indecies weird, don't sweat
first_rotation=${state[1]:8:1}
second_rotation=${state[2]:8:1}
third_rotation=${state[3]:8:1}

function labelScreens() {
  if [[ $first_screen =~ $right_screen  ]] then 
     echo $first_rotation
  elif [[ $second_screen =~ $right_screen ]] then 
     echo $second_rotation
  else
     echo $third_rotation
  fi
}

r_screen_rot=$(labelScreens)
              
   

function setHorz () {
  kscreen-doctor output.$right_screen.rotation.none 
  kscreen-doctor output.$right_screen.position.1920,0
}
function setVert () {
  kscreen-doctor output.$right_screen.rotation.right
  kscreen-doctor output.$right_screen.position.1920,-420
}

# screen rotation vales; 1: horizontal, 2: left, 8 right
function toggleRightScreen () {
  case $r_screen_rot in 
    1) setVert ;;
    8) setHorz ;;
    *) notify-send "bad screen rotation right: $r_screen_rot left: $l_screen_rot"
  esac
}

# run
toggleRightScreen
