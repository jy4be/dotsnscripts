#!/usr/bin/bash


# Define the clock
Clock() {
        DATETIME=$(date "+%a %b %d, %T")

        echo -n "[$DATETIME]"
}

#Define the battery
Battery() {
        BATPERC=$(acpi --battery | cut -d, -f1,2)
	#BATCHRGSTAT=$(acpi -a | cut -d)
        echo "[$BATPERC] "
}

#Define the Internet Connection
Internet() {
	INETSTAT=$(nmcli device status | grep connected| tr -s " ")
	netinfo="[NO CONNECTION]"
	if test "$INETSTAT"; then
		type=$(echo $INETSTAT | cut -d ' ' -f2)
		name=$(echo $INETSTAT | cut -d ' ' -f4)

		netinfo="[$type: $name]"
	fi

	echo "%{A1:st -e nmtui:}${netinfo}%{A}"
}

DESKTOPS() {
	desktops=$(bspc query -D --names | tr "\n" " ")
	desktopCur=$(bspc query -D --names -n focused)
	desktopsMark=$( echo " $desktops" | sed -r "s/ $desktopCur +/%{R} $desktopCur %{R}/g")
	echo "[$desktopsMark]"
}


NAME() {
	winID=$(bspc query -N focused -n)
	winName=$(bspc query -T -n $winID | tr ',{' '\n' | grep "className" | cut -d\" -f4)
	if test "$winName"; then
		echo "[$winName]"
	fi
}

#Define the Sound Volume
SndVolume() {
	VOLPERC=$(amixer sget Master | sed -n '5p' | cut -d '[' -f2)

	#This Line has cost me approx. 3 Years of my life.
	echo "%{A1:st -f 'Liberation Mono-14' -e alsamixer:}%{A2:amixer sset Master \$(echo -e \"0\n25\n50\n75\n100\" | dmenu -p \"Set Volume Percentage\")%:}%{A4:amixer sset Master 5%+:}%{A5:amixer sset Master 5%-:}[Volume: $VOLPERC %{A}%{A}%{A}%{A}"
}

# Print the percentage
Update() {
	echo "%{S1}%{l}%{B#1E1E2E}%{F#D9E0EE} $(Clock) $(Internet) $(DESKTOPS)  %{c}$(NAME) %{r}$(SndVolume) $(Battery)"
}

#Update loop
while true; do
	Update
	sleep 0.5;
done
