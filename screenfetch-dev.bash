#!/usr/bin/env bash

# screenFetch - a CLI Bash script to show system/theme info in screenshots

# Copyright (c) 2010-2019 Brett Bohnenkamper <kittykatt@kittykatt.us>

#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Yes, I do realize some of this is horribly ugly coding. Any ideas/suggestions would be
# appreciated by emailing me or by stopping by http://github.com/KittyKatt/screenFetch. You
# could also drop in on the IRC channel at irc://irc.rizon.net/screenFetch.
# to put forth suggestions/ideas. Thank you.

# Requires: bash 4.0+
# Optional dependencies: xorg-xdpyinfo (resoluton detection)
#                        scrot (screenshot taking)
#                        curl (screenshot uploading)


#LANG=C
#LANGUAGE=C
#LC_ALL=C


scriptVersion="3.9.1"

######################
# Settings for fetcher
######################

# This setting controls what ASCII logo is displayed.
# distro="Linux"

# This sets the information to be displayed. Available: distro, Kernel, DE, WM, Win_theme, Theme, Icons, Font, Background, ASCII.
# To get just the information, and not a text-art logo, you would take "ASCII" out of the below variable.
valid_display=(
		'distro'
		'host'
		'kernel'
		'uptime'
		'pkgs'
		'shell'
		'res'
		'de'
		'wm'
		'wmtheme'
		'gtk'
		'disk'
		'cpu'
		'gpu'
		'mem'
)
display=(
		'distro'
		'host'
		'kernel'
		'uptime'
		'pkgs'
		'shell'
		'res'
		'de'
		'wm'
		'wmtheme'
		'gtk'
		'cpu'
		'disk'
		'gpu'
		'mem'
)
# Display Type: ASCII or Text
display_type="ASCII"
# Plain logo
display_logo="no"

# Colors to use for the information found. These are set below according to distribution.
# If you would like to set your OWN color scheme for these, uncomment the lines below and edit them to your heart's content.
# textcolor="\e[0m"
# labelcolor="\e[1;34m"

# Array: WM Process Names
# Order matters!
# Removed WM's: compiz
wmnames=(
		'fluxbox'
		'openbox'
		'blackbox'
		'xfwm4'
		'metacity'
		'kwin'
		'twin'
		'icewm'
		'pekwm'
		'flwm'
		'flwm_topside'
		'fvwm'
		'dwm'
		'awesome'
		'wmaker'
		'stumpwm'
		'musca'
		'xmonad.*'
		'i3'
		'ratpoison'
		'scrotwm'
		'spectrwm'
		'wmfs'
		'wmii'
		'beryl'
		'subtle'
		'e16'
		'enlightenment'
		'sawfish'
		'emerald'
		'monsterwm'
		'dminiwm'
		'compiz'
		'Finder'
		'herbstluftwm'
		'howm'
		'notion'
		'bspwm'
		'cinnamon'
		'2bwm'
		'echinus'
		'swm'
		'budgie-wm'
		'dtwm'
		'9wm'
		'chromeos-wm'
		'deepin-wm'
		'sway'
		'mwm'
)

# Array with full Ubuntu release codenames, used so that the script will display
# i.e. "Ubuntu 18.04 LTS (Bionic Beaver)" instead of "Ubuntu 18.04 bionic"
ubuntu_codenames=(
		'(Warty Warthog)'		#  4.10
		'(Hoary Hedgehog)'		#  5.04
		'(Breezy Badger)'		#  5.10
		'LTS (Dapper Drake)'		#  6.06
		'(Edgy Eft)'			#  6.10
		'(Feisty Fawn)'			#  7.04
		'(Gutsy Gibbon)'		#  7.10
		'LTS (Hardy Heron)'		#  8.04
		'(Intrepid Ibex)'		#  8.10
		'(Jaunty Jackalope)'		#  9.04
		'(Karmic Koala)'		#  9.10
		'LTS (Lucid Lynx)'		# 10.04
		'(Maverick Meerkat)'		# 10.10
		'(Natty Narwhal)'		# 11.04
		'(Oneiric Ocelot)'		# 11.10
		'LTS (Precise Pangolin)'	# 12.04
		'(Quantal Quetzal)'		# 12.10
		'(Raring Ringtail)'		# 13.04
		'(Saucy Salamander)'		# 13.10
		'LTS (Trusty Tahr)'		# 14.04
		'(Utopic Unicorn)'		# 14.10
		'(Vivid Vervet)'		# 15.04
		'(Wily Werewolf)'		# 15.10
		'LTS (Xenial Xerus)'		# 16.04
		'(Yakkety Yak)'			# 16.10
		'(Zesty Zapus)'			# 17.04
		'(Artful Aardvark)'		# 17.10
		'LTS (Bionic Beaver)'		# 18.04
		'(Cosmic Cuttlefish)'		# 18.10
		'(Disco Dingo)'			# 19.04
		'(Eoan Ermine)'			# 19.10
		'LTS (Focal Fossa)'		# 20.04
		'(Groovy Gorilla)'		# 20.10
		'(Hirsute Hippo)'		# 21.04
)

# Screenshot Settings
# This setting lets the script know if you want to take a screenshot or not. 1=Yes 0=No
screenshot=
# This setting lets the script know if you want to upload the screenshot to a filehost. 1=Yes 0=No
upload=
# This setting lets the script know where you would like to upload the file to.
# Valid hosts are: teknik, mediacrush, imgur, hmp, and a configurable local.
uploadLoc=
# You can specify a custom screenshot command here. Just uncomment and edit.
# Otherwise, we'll be using the default command: scrot -cd3.
# screenCommand="scrot -cd5"
shotfile=$(printf "screenFetch-%s.png" "$(date +'%Y-%m-%d_%H-%M-%S')")

# Verbose Setting - Set to 1 for verbose output.
verbosity=


# The below function will allow you to add custom lines of text to the screenfetch output.
# It will automatically be executed at the right moment if use_customlines is set to 1.
use_customlines=
customlines () {
	# The following line can serve as an example.
	# feel free to let the computer generate the output: e. g. using $(cat /etc/motd) or $(upower -d | grep THISORTHAT)
	# In the example custom0 line replace <YOUR LABEL> and <your text> with options specified by you.
	# Also make sure the $custom0 variable in out_array=... matches the one at the beginning of the line
	#
	custom0=$(echo -e "$labelcolor YOUR LABEL:$textcolor your text"); out_array=( "${out_array[@]}" "$custom0" ); ((display_index++));

	# Battery percentage and time to full/empty:
	# (uncomment lines below to use)
	#
	#custom1=$(echo -e "$labelcolor Battery:$textcolor $(upower -d | grep percentage | head -n1 | cut -d ' ' -f 15-)"); out_array=( "${out_array[@]}" "$custom1" ); ((display_index++));
	#if [ "$(upower -d | grep time)" ]; then
	#	battery_time="$(upower -d | grep time | head -n1 | cut -d ' ' -f 14-) $(upower -d | grep time | head -n1 | cut -d ' ' -f 6-7 | cut -d ':' -f1)"
	#else
	#	battery_time="power supply plugged in"
	#fi
	#custom2=$(echo -e "$labelcolor $(echo '  `->')$textcolor $battery_time"); out_array=( "${out_array[@]}" "$custom2" ); ((display_index++));

	# Display public IP:
	#custom3=$(echo -e "$labelcolor Public IP:$textcolor $(curl -s ipinfo.io/ip)"); out_array=( "${out_array[@]}" "$custom3" ); ((display_index++));

	###########################################
	##	MY CUSTOM LINES
	###########################################

	#custom4=...
}


#############################################
#### CODE No need to edit past here CODE ####
#############################################

# https://github.com/KittyKatt/screenFetch/issues/549
if [[ "${OSTYPE}" =~ "linux" || "${OSTYPE}" == "gnu" ]]; then
	# issue seems to affect Ubuntu; add LSB directories if it appears on other distros too
	export GIO_EXTRA_MODULES="/usr/lib/x86_64-linux-gnu/gio/modules:/usr/lib/i686-linux-gnu/gio/modules:$GIO_EXTRA_MODULES"
fi

#########################################
# Static Variables and Common Functions #
#########################################
c0=$'\033[0m' # Reset Text
bold=$'\033[1m' # Bold Text
underline=$'\033[4m' # Underline Text
display_index=0

# User options
gtk_2line="no"

# Static Color Definitions
colorize () {
	printf $'\033[0m\033[38;5;%sm' "$1"
}
getColor () {
	local tmp_color=""
	if [[ -n "$1" ]]; then
		if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
			if [[ ${BASH_VERSINFO[0]} -eq 4 && ${BASH_VERSINFO[1]} -gt 1 ]] || [[ ${BASH_VERSINFO[0]} -gt 4 ]]; then
				tmp_color=${1,,}
			else
				tmp_color="$(tr '[:upper:]' '[:lower:]' <<< "${1}")"
			fi
		else
			tmp_color="$(tr '[:upper:]' '[:lower:]' <<< "${1}")"
		fi
		case "${tmp_color}" in
			# Standards
			'black')					color_ret='\033[0m\033[30m';;
			'red')						color_ret='\033[0m\033[31m';;
			'green')					color_ret='\033[0m\033[32m';;
			'brown')					color_ret='\033[0m\033[33m';;
			'blue')						color_ret='\033[0m\033[34m';;
			'purple')					color_ret='\033[0m\033[35m';;
			'cyan')						color_ret='\033[0m\033[36m';;
			'yellow')					color_ret='\033[0m\033[1;33m';;
			'white')					color_ret='\033[0m\033[1;37m';;
			# Bolds
			'dark grey'|'dark gray')	color_ret='\033[0m\033[1;30m';;
			'light red')				color_ret='\033[0m\033[1;31m';;
			'light green')				color_ret='\033[0m\033[1;32m';;
			'light blue')				color_ret='\033[0m\033[1;34m';;
			'light purple')				color_ret='\033[0m\033[1;35m';;
			'light cyan')				color_ret='\033[0m\033[1;36m';;
			'light grey'|'light gray')	color_ret='\033[0m\033[37m';;
			# Some 256 colors
			'orange')					color_ret="$(colorize '202')";; #DarkOrange
			'light orange') 			color_ret="$(colorize '214')";; #Orange1
			# HaikuOS
			'black_haiku') 				color_ret="$(colorize '7')";;
			#ROSA color
			'rosa_blue') 				color_ret='\033[01;38;05;25m';;
			# ArcoLinux
			'arco_blue') color_ret='\033[1;38;05;111m';;
		esac
		[[ -n "${color_ret}" ]] && echo "${color_ret}"
	fi
}

verboseOut () {
	if [[ "$verbosity" -eq "1" ]]; then
		printf '\033[1;31m:: \033[0m%s\n' "$1"
	fi
}

errorOut () {
	printf '\033[1;37m[[ \033[1;31m! \033[1;37m]] \033[0m%s\n' "$1"
}
stderrOut () {
	while IFS='' read -r line; do
		printf '\033[1;37m[[ \033[1;31m! \033[1;37m]] \033[0m%s\n' "$line"
	done
}


####################
#  Color Defines
####################

colorNumberToCode () {
	local number="$1"
	if [[ "${number}" == "na" ]]; then
		unset code
	elif [[ $(tput colors) -eq "256" ]]; then
		code=$(colorize "${number}")
	else
		case "$number" in
			0|00) code=$(getColor 'black');;
			1|01) code=$(getColor 'red');;
			2|02) code=$(getColor 'green');;
			3|03) code=$(getColor 'brown');;
			4|04) code=$(getColor 'blue');;
			5|05) code=$(getColor 'purple');;
			6|06) code=$(getColor 'cyan');;
			7|07) code=$(getColor 'light grey');;
			8|08) code=$(getColor 'dark grey');;
			9|09) code=$(getColor 'light red');;
			  10) code=$(getColor 'light green');;
			  11) code=$(getColor 'yellow');;
			  12) code=$(getColor 'light blue');;
			  13) code=$(getColor 'light purple');;
			  14) code=$(getColor 'light cyan');;
			  15) code=$(getColor 'white');;
			*) unset code;;
		esac
	fi
	echo -n "${code}"
}


detectColors () {
	my_colors=$(sed 's/^,/na,/;s/,$/,na/;s/,/ /' <<< "${OPTARG}")
	my_lcolor=$(awk -F' ' '{print $1}' <<< "${my_colors}")
	my_lcolor=$(colorNumberToCode "${my_lcolor}")
	my_hcolor=$(awk -F' ' '{print $2}' <<< "${my_colors}")
	my_hcolor=$(colorNumberToCode "${my_hcolor}")
}

supported_distros="ALDOS, Alpine Linux, Amazon Linux, Antergos, Arch Linux (Old and Current Logos), ArcoLinux, Artix Linux, \
blackPanther OS, BLAG, BunsenLabs, CentOS, Chakra, Chapeau, Chrome OS, Chromium OS, CrunchBang, CRUX, \
Debian, Deepin, DesaOS,Devuan, Dragora, DraugerOS, elementary OS, EuroLinux, Evolve OS, Sulin, Exherbo, Fedora, Frugalware, Fuduntu, Funtoo, \
Fux, Gentoo, gNewSense, Guix System, Hyperbola GNU/Linux-libre, januslinux, Jiyuu Linux, Kali Linux, KaOS, KDE neon, Kogaion, Korora, \
LinuxDeepin, Linux Mint, LMDE, Logos, Mageia, Mandriva/Mandrake, Manjaro, Mer, Netrunner, NixOS, OBRevenge, openSUSE, \
OS Elbrus, Oracle Linux, Parabola GNU/Linux-libre, Pardus, Parrot Security, PCLinuxOS, PeppermintOS, Proxmox VE, PureOS, Qubes OS, \
Raspbian, Red Hat Enterprise Linux, ROSA, Sabayon, SailfishOS, Scientific Linux, Siduction, Slackware, Solus, Source Mage GNU/Linux, \
SparkyLinux, SteamOS, SUSE Linux Enterprise, SwagArch, TinyCore, Trisquel, Ubuntu, Viperr, Void and Zorin OS and EndeavourOS"

supported_other="Dragonfly/Free/Open/Net BSD, Haiku, macOS, Windows+Cygwin and Windows+MSYS2."

supported_dms="KDE, GNOME, Unity, Xfce, LXDE, Cinnamon, MATE, Deepin, CDE, RazorQt and Trinity."

supported_wms="2bwm, 9wm, Awesome, Beryl, Blackbox, Cinnamon, chromeos-wm, Compiz, deepin-wm, \
dminiwm, dwm, dtwm, E16, E17, echinus, Emerald, FluxBox, FLWM, FVWM, herbstluftwm, howm, IceWM, KWin, \
Metacity, monsterwm, Musca, Gala, Mutter, Muffin, Notion, OpenBox, PekWM, Ratpoison, Sawfish, ScrotWM, SpectrWM, \
StumpWM, subtle, sway, TWin, WindowMaker, WMFS, wmii, Xfwm4, XMonad and i3."

displayHelp () {
	echo "${underline}Usage${c0}:"
	echo "  ${0} [OPTIONAL FLAGS]"
	echo
	echo "screenFetch - a CLI Bash script to show system/theme info in screenshots."
	echo
	echo "${underline}Supported GNU/Linux Distributions${c0}:"
	echo "${supported_distros}" | fold -s | sed 's/^/\t/g'
	echo
	echo "${underline}Other Supported Systems${c0}:"
	echo "${supported_other}" | fold -s | sed 's/^/\t/g'
	echo
	echo "${underline}Supported Desktop Managers${c0}:"
	echo "${supported_dms}" | fold -s | sed 's/^/\t/g'
	echo
	echo "${underline}Supported Window Managers${c0}:"
	echo "${supported_wms}" | fold -s | sed 's/^/\t/g'
	echo
	echo "${underline}Supported Information Displays${c0}:"
	echo "${valid_display[@]}" | fold -s | sed 's/^/\t/g'
	echo
	echo "${underline}Options${c0}:"
	echo "   ${bold}-v${c0}                 Verbose output."
	echo "   ${bold}-o 'OPTIONS'${c0}       Allows for setting script variables on the"
	echo "                      command line. Must be in the following format..."
	echo "                      'OPTION1=\"OPTIONARG1\";OPTION2=\"OPTIONARG2\"'"
	echo "   ${bold}-d '+var;-var;var'${c0} Allows for setting what information is displayed"
	echo "                      on the command line. You can add displays with +var,var. You"
	echo "                      can delete displays with -var,var. Setting without + or - will"
	echo "                      set display to that explicit combination. Add and delete statements"
	echo "                      may be used in conjunction by placing a ; between them as so:"
	echo "                      +var,var,var;-var,var. See above to find supported display names."
	echo "   ${bold}-n${c0}                 Do not display ASCII distribution logo."
	echo "   ${bold}-L${c0}                 Display ASCII distribution logo only."
	echo "   ${bold}-N${c0}                 Strip all color from output."
	echo "   ${bold}-w${c0}                 Wrap long lines."
	echo "   ${bold}-t${c0}                 Truncate output based on terminal width (Experimental!)."
	echo "   ${bold}-p${c0}                 Portrait output."
	echo "   ${bold}-s [-u IMGHOST]${c0}    Using this flag tells the script that you want it"
	echo "                      to take a screenshot. Use the -u flag if you would like"
	echo "                      to upload the screenshots to one of the pre-configured"
	echo "                      locations. These include: teknik, imgur, mediacrush and hmp."
	echo "   ${bold}-c string${c0}          You may change the outputted colors with -c. The format is"
	echo "                      as follows: [0-9][0-9],[0-9][0-9]. The first argument controls the"
	echo "                      ASCII logo colors and the label colors. The second argument"
	echo "                      controls the colors of the information found. One argument may be"
	echo "                      used without the other. For terminals supporting 256 colors argument"
	echo "                      may also contain other terminal control codes for bold, underline etc."
	echo "                      separated by semicolon. For example -c \"4;1,1;2\" will produce bold"
	echo "                      blue and dim red."
	echo "   ${bold}-a 'PATH'${c0}          You can specify a custom ASCII art by passing the path"
	echo "                      to a Bash script, defining \`startline\` and \`fulloutput\`"
	echo "                      variables, and optionally \`labelcolor\` and \`textcolor\`."
	echo "                      See the \`asciiText\` function in the source code for more"
	echo "                      information on the variables format."
	echo "   ${bold}-S 'COMMAND'${c0}       Here you can specify a custom screenshot command for"
	echo "                      the script to execute. Surrounding quotes are required."
	echo "   ${bold}-D 'DISTRO'${c0}        Here you can specify your distribution for the script"
	echo "                      to use. Surrounding quotes are required."
	echo "   ${bold}-A 'DISTRO'${c0}        Here you can specify the distribution art that you want"
	echo "                      displayed. This is for when you want your distro"
	echo "                      detected but want to display a different logo."
	echo "   ${bold}-E${c0}                 Suppress output of errors."
	echo "   ${bold}-V, --version${c0}      Display current script version."
	echo "   ${bold}-h, --help${c0}         Display this help."
}


displayVersion () {
	echo "${underline}screenFetch${c0} - Version ${scriptVersion}"
	echo "Created by and licensed to Brett Bohnenkamper <kittykatt@kittykatt.us>"
	echo "OS X porting done almost solely by shrx (https://github.com/shrx) and John D. Duncan, III (https://github.com/JohnDDuncanIII)."
	echo
	echo "This is free software; see the source for copying conditions.  There is NO warranty; not even MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE."
}


#####################
# Begin Flags Phase
#####################

case $1 in
	--help) displayHelp; exit 0;;
	--version) displayVersion; exit 0;;
esac


while getopts ":hsu:evVEnLNtlS:A:D:o:c:d:pa:w" flags; do
	case $flags in
		h) displayHelp; exit 0 ;;
		s) screenshot='1' ;;
		S) screenCommand="${OPTARG}" ;;
		u) upload='1'; uploadLoc="${OPTARG}" ;;
		v) verbosity=1 ;;
		V) displayVersion; exit 0 ;;
		E) errorSuppress='1' ;;
		D) distro="${OPTARG}" ;;
		A) asc_distro="${OPTARG}" ;;
		t) truncateSet='Yes' ;;
		n) display_type='Text' ;;
		L) display_type='ASCII'; display_logo='Yes' ;;
		o) overrideOpts="${OPTARG}" ;;
		c) detectColors "${OPTARGS}" ;;
		d) overrideDisplay="${OPTARG}" ;;
		N) no_color='1' ;;
		p) portraitSet='Yes' ;;
		a) art="${OPTARG}" ;;
		w) lineWrap='Yes' ;;
		:) errorOut "Error: You're missing an argument somewhere. Exiting."; exit 1 ;;
		?) errorOut "Error: Invalid flag somewhere. Exiting."; exit 1 ;;
		*) errorOut "Error"; exit 1 ;;
	esac
done

###################
# End Flags Phase
###################


############################
# Override Options/Display
############################

if [[ "$overrideOpts" ]]; then
	verboseOut "Found 'o' flag in syntax. Overriding some script variables..."
	eval "${overrideOpts}"
fi


#########################
# Begin Detection Phase
#########################

# Distro Detection - Begin
detectdistro () {
	local distro_detect=""
	if [[ -z "${distro}" ]]; then
		distro="Unknown"
		# LSB Release or MCST Version Check
		if [[ -e "/etc/mcst_version" ]]; then
			distro="OS Elbrus"
			distro_release="$(tail -n 1 /etc/mcst_version)"
			if [[ -n ${distro_release} ]]; then
				distro_more="$distro_release"
			fi
		elif type -p lsb_release >/dev/null 2>&1; then
			# read distro_detect distro_release distro_codename <<< $(lsb_release -sirc)
			#OLD_IFS=$IFS
			#IFS=" "
			#read -r -a distro_detect <<< "$(lsb_release -sirc)"
			#IFS=$OLD_IFS
			#if [[ ${#distro_detect[@]} -eq 3 ]]; then
			#	distro_codename=${distro_detect[2]}
			#	distro_release=${distro_detect[1]}
			#	distro_detect=${distro_detect[0]}
			#else
			#	for i in "${!distro_detect[@]}"; do
			#		if [[ ${distro_detect[$i]} =~ ^[[:digit:]]+((.[[:digit:]]+|[[:digit:]]+|)+)$ ]]; then
			#			distro_release=${distro_detect[$i]}
			#			distro_codename=${distro_detect[*]:$((i+1))}
			#			distro_detect=${distro_detect[*]:0:${i}}
			#			break 1
			#		elif [[ ${distro_detect[$i]} =~ [Nn]/[Aa] || ${distro_detect[$i]} == "rolling" ]]; then
			#			distro_release=${distro_detect[$i]}
			#			distro_codename=${distro_detect[*]:$((i+1))}
			#			distro_detect=${distro_detect[*]:0:${i}}
			#			break 1
			#		fi
			#	done
			#fi
			distro_detect="$(lsb_release -si)"
			distro_release="$(lsb_release -sr)"
			distro_codename="$(lsb_release -sc)"
			case "${distro_detect}" in
				"archlinux"|"Arch Linux"|"arch"|"Arch"|"archarm")
					distro="Arch Linux"
					distro_release="n/a"
					if [ -f /etc/os-release ]; then
						os_release="/etc/os-release";
					elif [ -f /usr/lib/os-release ]; then
						os_release="/usr/lib/os-release";
					fi
					if [[ -n ${os_release} ]]; then
						if grep -q 'antergos' /etc/os-release; then
							distro="Antergos"
							distro_release="n/a"
						fi
						if grep -q -i 'logos' /etc/os-release; then
							distro="Logos"
							distro_release="n/a"
						fi
						if grep -q -i 'swagarch' /etc/os-release; then
							distro="SwagArch"
							distro_release="n/a"
						fi
						if grep -q -i 'obrevenge' /etc/os-release; then
							distro="OBRevenge"
							distro_release="n/a"
						fi
					fi
					;;
				"ALDOS"|"Aldos")
					distro="ALDOS"
					;;
				"ArcoLinux")
					distro="ArcoLinux"
					distro_release="n/a"
					;;
				"artixlinux"|"Artix Linux"|"artix"|"Artix"|"Artix release")
					distro="Artix"
					;;
				"blackPantherOS"|"blackPanther"|"blackpanther"|"blackpantheros")
					distro=$(source /etc/lsb-release; echo "$DISTRIB_ID")
					distro_release=$(source /etc/lsb-release; echo "$DISTRIB_RELEASE")
					distro_codename=$(source /etc/lsb-release; echo "$DISTRIB_CODENAME")
					;;
				"BLAG")
					distro="BLAG"
					distro_more="$(head -n1 /etc/fedora-release)"
					;;
				"Chakra")
					distro="Chakra"
					distro_release=""
					;;
				"BunsenLabs")
					distro=$(source /etc/lsb-release; echo "$DISTRIB_ID")
					distro_release=$(source /etc/lsb-release; echo "$DISTRIB_RELEASE")
					distro_codename=$(source /etc/lsb-release; echo "$DISTRIB_CODENAME")
					;;
				"Debian")
					if [[ -f /etc/crunchbang-lsb-release || -f /etc/lsb-release-crunchbang ]]; then
						distro="CrunchBang"
						distro_release=$(awk -F'=' '/^DISTRIB_RELEASE=/ {print $2}' /etc/lsb-release-crunchbang)
						distro_codename=$(awk -F'=' '/^DISTRIB_DESCRIPTION=/ {print $2}' /etc/lsb-release-crunchbang)
					elif [[ -f /etc/siduction-version ]]; then
						distro="Siduction"
						distro_release="(Debian Sid)"
						distro_codename=""
					elif [[ -f /usr/bin/pveversion ]]; then
						distro="Proxmox VE"
						distro_codename="n/a"
						distro_release="$(/usr/bin/pveversion | grep -oP 'pve-manager\/\K\d+\.\d+')"
					elif [[ -f /etc/os-release ]]; then
						if grep -q -i 'Raspbian' /etc/os-release ; then
							distro="Raspbian"
							distro_release=$(awk -F'=' '/^PRETTY_NAME=/ {print $2}' /etc/os-release)
						elif grep -q -i 'BlankOn' /etc/os-release ; then
							distro='BlankOn'
							distro_release=$(awk -F'=' '/^PRETTY_NAME=/ {print $2}' /etc/os-release)
						else
							distro="Debian"
						fi
					else
						distro="Debian"
					fi
					;;
			  "DraugerOS")
			    distro = "DraugerOS"
			    fake_distro="${distro}"
			    ;;
				"elementary"|"elementary OS")
					distro="elementary OS"
					;;
				"EvolveOS")
					distro="Evolve OS"
					;;
				"Sulin")
					distro="Sulin"
					distro_release=$(awk -F'=' '/^ID_LIKE=/ {print $2}' /etc/os-release)
					distro_codename="Roolling donkey" # this is not wrong :D
					;;
				"KaOS"|"kaos")
					distro="KaOS"
					;;
				"frugalware")
					distro="Frugalware"
					distro_codename=null
					distro_release=null
					;;
				"Fuduntu")
					distro="Fuduntu"
					distro_codename=null
					;;
				"Fux")
					distro="Fux"
					distro_codename=null
					;;
				"Gentoo")
					if [[ "$(lsb_release -sd)" =~ "Funtoo" ]]; then
						distro="Funtoo"
					else
						distro="Gentoo"
					fi

					#detecting release stable/testing/experimental
					if [[ -f /etc/portage/make.conf ]]; then
						source /etc/portage/make.conf
					elif [[ -d /etc/portage/make.conf ]]; then
						source /etc/portage/make.conf/*
					fi

					case $ACCEPT_KEYWORDS in
						[a-z]*) distro_release=stable       ;;
						~*)     distro_release=testing      ;;
						'**')   distro_release=experimental ;; #experimental usually includes git-versions.
					esac
					;;
				"Hyperbola GNU/Linux-libre"|"Hyperbola")
					distro="Hyperbola GNU/Linux-libre"
					distro_codename="n/a"
					distro_release="n/a"
					;;
				"januslinux"|"janus")
					distro="januslinux"
					;;
				"LinuxDeepin")
					distro="LinuxDeepin"
					distro_codename=null
					;;
				"Kali"|"Debian Kali Linux")
					distro="Kali Linux"
					if [[ "${distro_codename}" =~ "kali-rolling" ]]; then
						distro_codename="n/a"
						distro_release="n/a"
					fi
					;;
				"Lunar Linux"|"lunar")
					distro="Lunar Linux"
					;;
				"MandrivaLinux")
					distro="Mandriva"
					case "${distro_codename}" in
						"turtle"|"Henry_Farman"|"Farman"|"Adelie"|"pauillac")
							distro="Mandriva-${distro_release}"
							distro_codename=null
							;;
					esac
					;;
				"ManjaroLinux")
					distro="Manjaro"
					;;
				"Mer")
					distro="Mer"
					if [[ -f /etc/os-release ]]; then
						if grep -q 'SailfishOS' /etc/os-release; then
							distro="SailfishOS"
							distro_codename="$(grep 'VERSION=' /etc/os-release | cut -d '(' -f2 | cut -d ')' -f1)"
							distro_release="$(awk -F'=' '/^VERSION=/ {print $2}' /etc/os-release)"
						fi
					fi
					;;
				"neon"|"KDE neon")
					distro="KDE neon"
					distro_codename="n/a"
					distro_release="n/a"
					if [[ -f /etc/issue ]]; then
						if grep -q '^KDE neon' /etc/issue ; then
							distro_release="$(grep '^KDE neon' /etc/issue | cut -d ' ' -f3)"
						fi
					fi
					;;
				"Ol"|"ol"|"Oracle Linux")
					distro="Oracle Linux"
					[ -f /etc/oracle-release ] && distro_release="$(sed 's/Oracle Linux //' /etc/oracle-release)"
					;;
				"LinuxMint")
					distro="Mint"
					if [[ "${distro_codename}" == "debian" ]]; then
						distro="LMDE"
						distro_codename="n/a"
						distro_release="n/a"
					#adding support for LMDE 3	
					elif [[ "$(lsb_release -sd)" =~ "LMDE" ]]; then
						distro="LMDE"	
					fi
					;;
				"openSUSE"|"openSUSE project"|"SUSE LINUX" | "SUSE")
					distro="openSUSE"
					if [ -f /etc/os-release ]; then
						if grep -q -i 'SUSE Linux Enterprise' /etc/os-release ; then
							distro="SUSE Linux Enterprise"
							distro_codename="n/a"
							distro_release=$(awk -F'=' '/^VERSION_ID=/ {print $2}' /etc/os-release | tr -d '"')
						fi
					fi
					if [[ "${distro_codename}" == "Tumbleweed" ]]; then
						distro_release="n/a"
					fi
					;;
				"Parabola GNU/Linux-libre"|"Parabola")
					distro="Parabola GNU/Linux-libre"
					distro_codename="n/a"
					distro_release="n/a"
					;;
				"Parrot"|"Parrot Security")
					distro="Parrot Security"
					;;
				"PCLinuxOS")
					distro="PCLinuxOS"
					distro_codename="n/a"
					distro_release="n/a"
					;;
				"Peppermint")
					distro="Peppermint"
					distro_codename=null
					;;
				"rhel")
					distro="Red Hat Enterprise Linux"
					;;
				"RosaDesktopFresh")
					distro="ROSA"
					distro_release=$(grep 'VERSION=' /etc/os-release | cut -d ' ' -f3 | cut -d "\"" -f1)
					distro_codename=$(grep 'PRETTY_NAME=' /etc/os-release | cut -d ' ' -f4,4)
					;;
				"SailfishOS")
					distro="SailfishOS"
					if [[ -f /etc/os-release ]]; then
						distro_codename="$(grep 'VERSION=' /etc/os-release | cut -d '(' -f2 | cut -d ')' -f1)"
						distro_release="$(awk -F'=' '/^VERSION=/ {print $2}' /etc/os-release)"
					fi
					;;
				"Sparky"|"SparkyLinux")
					distro="SparkyLinux"
					;;
				"Ubuntu")
					for each in "${ubuntu_codenames[@]}"; do
						if [[ "${each,,}" =~ "${distro_codename,,}" ]]; then
							distro_codename="$each"
						fi
					done
					;;
				"Viperr")
					distro="Viperr"
					distro_codename=null
					;;
				"Void"|"VoidLinux")
					distro="Void Linux"
					distro_codename=""
					distro_release=""
					;;
				"Zorin")
					distro="Zorin OS"
					distro_codename=""
					;;
				*)
					if [ "x$(printf "${distro_detect}" | od -t x1 | sed -e 's/^\w*\ *//' | tr '\n' ' ' | grep 'eb b6 89 ec 9d 80 eb b3 84 ')" != "x" ]; then
						distro="Red Star OS"
						distro_codename="n/a"
						distro_release=$(printf "${distro_release}" | grep -o '[0-9.]' | tr -d '\n')
					else
						distro="${distro_detect}"
					fi
					;;
			esac
			if [[ "${distro_detect}" =~ "RedHatEnterprise" ]]; then
				distro="Red Hat Enterprise Linux"
			fi
			if [[ "${distro_detect}" =~ "SUSELinuxEnterprise" ]]; then
				distro="SUSE Linux Enterprise"
			fi
			if [[ -n ${distro_release} && ${distro_release} != "n/a" ]]; then
				distro_more="$distro_release"
			fi
			if [[ -n ${distro_codename} && ${distro_codename} != "n/a" ]]; then
				distro_more="$distro_more $distro_codename"
			fi
		fi

		# Existing File Check
		if [ "$distro" == "Unknown" ]; then
			if [ "$(uname -o 2>/dev/null)" ]; then
				os="$(uname -o)"
				case "$os" in
					"Cygwin"|"FreeBSD"|"OpenBSD"|"NetBSD")
						distro="$os"
						fake_distro="${distro}"
					;;
					"DragonFly")
						distro="DragonFlyBSD"
						fake_distro="${distro}"
					;;
					"EndeavourOS")
						distro="EndeavourOS"
						fake_distro="${distro}"
					;;
					"Msys")
						distro="Msys"
						fake_distro="${distro}"
						distro_more="${distro} $(uname -r | head -c 1)"
					;;
					"Haiku")
						distro="Haiku"
						distro_more="$(uname -v | awk '/^hrev/ {print $1}')"
					;;
					"GNU/Linux")
						if type -p crux >/dev/null 2>&1; then
							distro="CRUX"
							distro_more="$(crux | awk '{print $3}')"
						fi
						if type -p nixos-version >/dev/null 2>&1; then
							distro="NixOS"
							distro_more="$(nixos-version)"
						fi
						if type -p sorcery >/dev/null 2>&1; then
							distro="SMGL"
						fi
						if (type -p guix && type -p herd) >/dev/null 2>&1; then
							distro="Guix System"
						fi
					;;
				esac
			fi
			if [[ "${distro}" == "Cygwin" || "${distro}" == "Msys" ]]; then
				# https://msdn.microsoft.com/en-us/library/ms724832%28VS.85%29.aspx
				if wmic os get version | grep -q '^\(6\.[23]\|10\)'; then
					fake_distro="Windows - Modern"
				fi
			fi
			if [[ "${distro}" == "Unknown" ]]; then
				if [ -f /etc/os-release ]; then
					os_release="/etc/os-release";
				elif [ -f /usr/lib/os-release ]; then
					os_release="/usr/lib/os-release";
				fi
				if [[ -n ${os_release} ]]; then
					distrib_id=$(<${os_release});
					for l in $distrib_id; do
						if [[ ${l} =~ ^ID= ]]; then
							distrib_id=${l//*=}
							distrib_id=${distrib_id//\"/}
							break 1
						fi
					done
					if [[ -n ${distrib_id} ]]; then
						if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
							distrib_id=$(for i in ${distrib_id}; do echo -n "${i^} "; done)
							distro=${distrib_id% }
							unset distrib_id
						else
							distrib_id=$(for i in ${distrib_id}; do FIRST_LETTER=$(echo -n "${i:0:1}" | tr "[:lower:]" "[:upper:]"); echo -n "${FIRST_LETTER}${i:1} "; done)
							distro=${distrib_id% }
							unset distrib_id
						fi
					fi

					# Hotfixes
                    [[ "${distro}" == "Opensuse-tumbleweed" ]] && distro="openSUSE" && distro_more="Tumbleweed"
					[[ "${distro}" == "Opensuse-leap" ]] && distro="openSUSE"
					[[ "${distro}" == "void" ]] && distro="Void Linux"
					[[ "${distro}" == "evolveos" ]] && distro="Evolve OS"
					[[ "${distro}" == "Sulin" ]] && distro="Sulin"
					[[ "${distro}" == "antergos" ]] && distro="Antergos"
					[[ "${distro}" == "logos" ]] && distro="Logos"
					[[ "${distro}" == "Arch" || "${distro}" == "Archarm" || "${distro}" == "archarm" ]] && distro="Arch Linux"
					[[ "${distro}" == "elementary" ]] && distro="elementary OS"
					[[ "${distro}" == "Fedora" && -d /etc/qubes-rpc ]] && distro="qubes" # Inner VM
					[[ "${distro}" == "Ol" || "${distro}" == "ol" ]] && distro="Oracle Linux"
					if [[ "${distro}" == "Oracle Linux" && -f /etc/oracle-release ]]; then
						distro_more="$(sed 's/Oracle Linux //' /etc/oracle-release)"
					fi
					# Upstream problem, SL and so EL is using rhel ID in os-release
					if [[ "${distro}" == "rhel" ]] || [[ "${distro}" == "Rhel" ]]; then
						distro="Red Hat Enterprise Linux"
						if grep -q 'Scientific' /etc/os-release; then
							distro="Scientific Linux"
						elif grep -q 'EuroLinux' /etc/os-release; then
							distro="EuroLinux"
						fi
					fi	

					[[ "${distro}" == "Neon" ]] && distro="KDE neon"
					[[ "${distro}" == "SLED" || "${distro}" == "sled" || "${distro}" == "SLES" || "${distro}" == "sles" ]] && distro="SUSE Linux Enterprise"
					if [[ "${distro}" == "SUSE Linux Enterprise" && -f /etc/os-release ]]; then
						distro_more="$(awk -F'=' '/^VERSION_ID=/ {print $2}' /etc/os-release | tr -d '"')"
					fi
					if [[ "${distro}" == "Debian" && -f /usr/bin/pveversion ]]; then
						distro="Proxmox VE"
						distro_codename="n/a"
						distro_release="$(/usr/bin/pveversion | grep -oP 'pve-manager\/\K\d+\.\d+')"
					fi
				fi
			fi

			if [[ "${distro}" == "Unknown" && "${OSTYPE}" =~ "linux" && -f /etc/lsb-release ]]; then
				LSB_RELEASE=$(</etc/lsb-release)
				distro=$(echo "${LSB_RELEASE}" | awk 'BEGIN {
					distro = "Unknown"
				}
				{
					if ($0 ~ /[Uu][Bb][Uu][Nn][Tt][Uu]/) {
						distro = "Ubuntu"
						exit
					}
					else if ($0 ~ /[Mm][Ii][Nn][Tt]/ && $0 ~ /[Dd][Ee][Bb][Ii][Aa][Nn]/) {
						distro = "LMDE"
						exit
					}
					else if ($0 ~ /[Mm][Ii][Nn][Tt]/) {
						distro = "Mint"
						exit
					}
				} END {
					print distro
				}')
			fi

			if [[ "${distro}" == "Unknown" ]] && [[ "${OSTYPE}" =~ "linux" || "${OSTYPE}" == "gnu" ]]; then
				for di in arch chakra crunchbang-lsb evolveos exherbo fedora \
							frugalware fux gentoo kogaion mageia obarun oracle \
							pardus pclinuxos redhat redstar rosa SuSe; do
					if [ -f /etc/$di-release ]; then
						distro=$di
						break
					fi
				done
				if [[ "${distro}" == "crunchbang-lsb" ]]; then
					distro="Crunchbang"
				elif [[ "${distro}" == "gentoo" ]]; then
					grep -q -i 'Funtoo' /etc/gentoo-release && distro="Funtoo"
				elif [[ "${distro}" == "mandrake" ]] || [[ "${distro}" == "mandriva" ]]; then
					grep -q -i 'PCLinuxOS' /etc/${distro}-release && distro="PCLinuxOS"
				elif [[ "${distro}" == "fedora" ]]; then
					grep -q -i 'Korora' /etc/fedora-release && distro="Korora"
					grep -q -i 'BLAG' /etc/fedora-release && distro="BLAG" && distro_more="$(head -n1 /etc/fedora-release)"
				elif [[ "${distro}" == "oracle" ]]; then
					distro_more="$(sed 's/Oracle Linux //' /etc/oracle-release)"
				elif [[ "${distro}" == "SuSe" ]]; then
					distro="openSUSE"
					if [ -f /etc/os-release ]; then
						if grep -q -i 'SUSE Linux Enterprise' /etc/os-release ; then
							distro="SUSE Linux Enterprise"
							distro_more=$(awk -F'=' '/^VERSION_ID=/ {print $2}' /etc/os-release | tr -d '"')
						fi
					fi
					if [[ "${distro_more}" =~ "Tumbleweed" ]]; then
						distro_more="Tumbleweed"
					fi
				elif [[ "${distro}" == "redstar" ]]; then
					distro_more=$(grep -o '[0-9.]' /etc/redstar-release | tr -d '\n')
				elif [[ "${distro}" == "redhat" ]]; then
					grep -q -i 'CentOS' /etc/redhat-release && distro="CentOS"
					grep -q -i 'Scientific' /etc/redhat-release && distro="Scientific Linux"
					grep -q -i 'EuroLinux' /etc/redhat-release && distro="EuroLinux"
					grep -q -i 'PCLinuxOS' /etc/redhat-release && distro="PCLinuxOS"
					if [ "x$(od -t x1 /etc/redhat-release | sed -e 's/^\w*\ *//' | tr '\n' ' ' | grep 'eb b6 89 ec 9d 80 eb b3 84 ')" != "x" ]; then
						distro="Red Star OS"
						distro_more=$(grep -o '[0-9.]' /etc/redhat-release | tr -d '\n')
					fi
				fi
			fi

			if [[ "${distro}" == "Unknown" ]]; then
				if [[ "${OSTYPE}" =~ "linux" || "${OSTYPE}" == "gnu" ]]; then
					if [ -f /etc/debian_version ]; then
						if [ -f /etc/issue ]; then
							if grep -q -i 'gNewSense' /etc/issue ; then
								distro="gNewSense"
							elif grep -q -i 'KDE neon' /etc/issue ; then
								distro="KDE neon"
								distro_more="$(cut -d ' ' -f3 /etc/issue)"
							else
								distro="Debian"
							fi
						fi
						if grep -q -i 'Kali' /etc/debian_version ; then
							distro="Kali Linux"
						fi
					elif [ -f /etc/NIXOS ]; then distro="NixOS"
					elif [ -f /etc/dragora-version ]; then
						distro="Dragora"
						distro_more="$(cut -d, -f1 /etc/dragora-version)"
					elif [ -f /etc/slackware-version ]; then distro="Slackware"
					elif [ -f /usr/share/doc/tc/release.txt ]; then
						distro="TinyCore"
						distro_more="$(cat /usr/share/doc/tc/release.txt)"
					elif [ -f /etc/sabayon-edition ]; then distro="Sabayon"
					fi
				else
					if [[ -x /usr/bin/sw_vers ]] && /usr/bin/sw_vers | grep -i 'Mac OS X' >/dev/null; then
						distro="Mac OS X"
					elif [[ -x /usr/bin/sw_vers ]] && /usr/bin/sw_vers | grep -i 'macOS' >/dev/null; then
						distro="macOS"
					elif [[ -f /var/run/dmesg.boot ]]; then
						distro=$(awk 'BEGIN {
							distro = "Unknown"
						}
						{
							if ($0 ~ /DragonFly/) {
								distro = "DragonFlyBSD"
								exit
							}
							else if ($0 ~ /FreeBSD/) {
								distro = "FreeBSD"
								exit
							}
							else if ($0 ~ /NetBSD/) {
								distro = "NetBSD"
								exit
							}
							else if ($0 ~ /OpenBSD/) {
								distro = "OpenBSD"
								exit
							}
						} END {
							print distro
						}' /var/run/dmesg.boot)
					fi
				fi
			fi

			if [[ "${distro}" == "Unknown" ]] && [[ "${OSTYPE}" =~ "linux" || "${OSTYPE}" == "gnu" ]]; then
				if [[ -f /etc/issue ]]; then
					distro=$(awk 'BEGIN {
						distro = "Unknown"
					}
					{
						if ($0 ~ /"Hyperbola GNU\/Linux-libre"/) {
							distro = "Hyperbola GNU/Linux-libre"
							exit
						}
						else if ($0 ~ /"LinuxDeepin"/) {
							distro = "LinuxDeepin"
							exit
						}
						else if ($0 ~ /"Obarun"/) {
							distro = "Obarun"
							exit
						}
						else if ($0 ~ /"Parabola GNU\/Linux-libre"/) {
							distro = "Parabola GNU/Linux-libre"
							exit
						}
						else if ($0 ~ /"Solus"/) {
							distro = "Solus"
							exit
						}
						else if ($0 ~ /"ALDOS"/) {
							distro = "ALDOS"
							exit
						}
					} END {
						print distro
					}' /etc/issue)
				fi
			fi

			if [[ "${distro}" == "Unknown" ]] && [[ "${OSTYPE}" =~ "linux" || "${OSTYPE}" == "gnu" ]]; then
				if [[ -f /etc/system-release ]]; then
					if grep -q -i 'Scientific Linux' /etc/system-release; then
						distro="Scientific Linux"
					elif grep -q -i 'Oracle Linux' /etc/system-release; then
						distro="Oracle Linux"
					fi
				elif [[ -f /etc/lsb-release ]]; then
					if grep -q -i 'CHROMEOS_RELEASE_NAME' /etc/lsb-release; then
						distro="$(awk -F'=' '/^CHROMEOS_RELEASE_NAME=/ {print $2}' /etc/lsb-release)"
						distro_more="$(awk -F'=' '/^CHROMEOS_RELEASE_VERSION=/ {print $2}' /etc/lsb-release)"
					fi
				fi
			fi
		fi
	fi

	if [[ -n ${distro_more} ]]; then
		distro_more="${distro} ${distro_more}"
	fi

	if [[ "${distro}" != "Haiku" ]]; then
		if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
			if [[ ${BASH_VERSINFO[0]} -eq 4 && ${BASH_VERSINFO[1]} -gt 1 ]] || [[ ${BASH_VERSINFO[0]} -gt 4 ]]; then
				distro=${distro,,}
			else
				distro="$(tr '[:upper:]' '[:lower:]' <<< "${distro}")"
			fi
		else
			distro="$(tr '[:upper:]' '[:lower:]' <<< "${distro}")"
		fi
	fi

	case $distro in
		aldos) distro="ALDOS";;
		alpine) distro="Alpine Linux" ;;
		amzn|amazon|amazon*linux) distro="Amazon Linux" ;;
		antergos) distro="Antergos" ;;
		arch*linux*old) distro="Arch Linux - Old" ;;
		arch|arch*linux) distro="Arch Linux" ;;
		arcolinux|arcolinux*) distro="ArcoLinux" ;;
		artix|artix*linux) distro="Artix Linux" ;;
		blackpantheros|black*panther*) distro="blackPanther OS" ;;
		blag) distro="BLAG" ;;
		bunsenlabs) distro="BunsenLabs" ;;
		centos) distro="CentOS" ;;
		chakra) distro="Chakra" ;;
		chapeau) distro="Chapeau" ;;
		chrome*|chromium*) distro="Chrome OS" ;;
		crunchbang) distro="CrunchBang" ;;
		crux) distro="CRUX" ;;
		cygwin) distro="Cygwin" ;;
		debian) distro="Debian" ;;
		devuan) distro="Devuan" ;;
		deepin) distro="Deepin" ;;
		desaos) distro="DesaOS" ;;
		dragonflybsd) distro="DragonFlyBSD" ;;
		dragora) distro="Dragora" ;;
		drauger*) distro="DraugerOS" ;;
		elementary|'elementary os') distro="elementary OS";;
		eurolinux) distro="EuroLinux" ;;
		evolveos) distro="Evolve OS" ;;
		sulin) distro="Sulin" ;;
		exherbo|exherbo*linux) distro="Exherbo" ;;
		fedora) distro="Fedora" ;;
		freebsd) distro="FreeBSD" ;;
		freebsd*old) distro="FreeBSD - Old" ;;
		frugalware) distro="Frugalware" ;;
		fuduntu) distro="Fuduntu" ;;
		funtoo) distro="Funtoo" ;;
		fux) distro="Fux" ;;
		gentoo) distro="Gentoo" ;;
		gnewsense) distro="gNewSense" ;;
		guix*system) distro="Guix System" ;;
		haiku) distro="Haiku" ;;
		hyperbolagnu|hyperbolagnu/linux-libre|'hyperbola gnu/linux-libre'|hyperbola) distro="Hyperbola GNU/Linux-libre" ;;
		januslinux) distro="januslinux" ;;
		kali*linux) distro="Kali Linux" ;;
		kaos) distro="KaOS";;
		kde*neon|neon) distro="KDE neon" ;;
		kogaion) distro="Kogaion" ;;
		korora) distro="Korora" ;;
		linuxdeepin) distro="LinuxDeepin" ;;
		lmde) distro="LMDE" ;;
		logos) distro="Logos" ;;
		lunar|lunar*linux) distro="Lunar Linux";;
		mac*os*x|os*x) distro="Mac OS X" ;;
                macos) distro="macOS" ;;
		manjaro) distro="Manjaro" ;;
		mageia) distro="Mageia" ;;
		mandrake) distro="Mandrake" ;;
		mandriva) distro="Mandriva" ;;
		mer) distro="Mer" ;;
		mint|linux*mint) distro="Mint" ;;
		msys|msys2) distro="Msys" ;;
		netbsd) distro="NetBSD" ;;
		netrunner) distro="Netrunner" ;;
		nix|nix*os) distro="NixOS" ;;
		obarun) distro="Obarun" ;;
		obrevenge) distro="OBRevenge" ;;
		ol|oracle*linux) distro="Oracle Linux" ;;
		openbsd) distro="OpenBSD" ;;
		opensuse) distro="openSUSE" ;;
		os*elbrus) distro="OS Elbrus" ;;
		parabolagnu|parabolagnu/linux-libre|'parabola gnu/linux-libre'|parabola) distro="Parabola GNU/Linux-libre" ;;
		pardus) distro="Pardus" ;;
		parrot|parrot*security) distro="Parrot Security" ;;
		pclinuxos|pclos) distro="PCLinuxOS" ;;
		peppermint) distro="Peppermint" ;;
		proxmox|proxmox*ve) distro="Proxmox VE" ;;
		pureos) distro="PureOS" ;;
		qubes) distro="Qubes OS" ;;
		raspbian) distro="Raspbian" ;;
		red*hat*|rhel) distro="Red Hat Enterprise Linux" ;;
		rosa) distro="ROSA" ;;
		red*star|red*star*os) distro="Red Star OS" ;;
		sabayon) distro="Sabayon" ;;
		sailfish|sailfish*os) distro="SailfishOS" ;;
		scientific*) distro="Scientific Linux" ;;
		siduction) distro="Siduction" ;;
		slackware) distro="Slackware" ;;
		smgl|source*mage|source*mage*gnu*linux) distro="Source Mage GNU/Linux" ;;
		solus) distro="Solus" ;;
		sparky|sparky*linux) distro="SparkyLinux" ;;
		steam|steam*os) distro="SteamOS" ;;
		suse*linux*enterprise) distro="SUSE Linux Enterprise" ;;
		swagarch) distro="SwagArch" ;;
		tinycore|tinycore*linux) distro="TinyCore" ;;
		trisquel) distro="Trisquel";;
		grombyangos) distro="GrombyangOS" ;;
		ubuntu) distro="Ubuntu";;
		viperr) distro="Viperr" ;;
		void*linux) distro="Void Linux" ;;
		zorin*) distro="Zorin OS" ;;
		endeavour*) distro="EndeavourOS" ;;
	esac
	if grep -q -i 'Microsoft' /proc/version 2>/dev/null || \
		grep -q -i 'Microsoft' /proc/sys/kernel/osrelease 2>/dev/null
	then
		wsl="(on the Windows Subsystem for Linux)"
	fi
	verboseOut "Finding distro...found as '${distro} ${distro_release}'"
}
# Distro Detection - End

# Host and User detection - Begin
detecthost () {
	myUser=${USER}
	myHost=${HOSTNAME}
	if [[ -z "$USER" ]]; then
		myUser=$(whoami)
	fi
	if [[ "${distro}" == "Mac OS X" || "${distro}" == "macOS" ]]; then
		myHost=${myHost/.local}
	fi
	verboseOut "Finding hostname and user...found as '${myUser}@${myHost}'"
}

# Find Number of Running Processes
# processnum="$(( $( ps aux | wc -l ) - 1 ))"

# Kernel Version Detection - Begin
detectkernel () {
	if [[ "$distro" == "OpenBSD" ]]; then
		kernel=$(uname -a | cut -f 3- -d ' ')
	else
		# compatibility for older versions of OS X:
		kernel=$(uname -m && uname -sr)
		kernel=${kernel//$'\n'/ }
		#kernel=( $(uname -srm) )
		#kernel="${kernel[${#kernel[@]}-1]} ${kernel[@]:0:${#kernel[@]}-1}"
		verboseOut "Finding kernel version...found as '${kernel}'"
	fi
}
# Kernel Version Detection - End


# Uptime Detection - Begin
detectuptime () {
	unset uptime
	if [[ "${distro}" == "Mac OS X" || "${distro}" == "macOS" || "${distro}" == "FreeBSD" || "${distro}" == "DragonFlyBSD" ]]; then
		boot=$(sysctl -n kern.boottime | cut -d "=" -f 2 | cut -d "," -f 1)
		now=$(date +%s)
		uptime=$((now-boot))
	elif [[ "${distro}" == "OpenBSD" ]]; then
		boot=$(sysctl -n kern.boottime)
		now=$(date +%s)
		uptime=$((now - boot))
	elif [[ "${distro}" == "Haiku" ]]; then
		uptime=$(uptime | awk -F', up ' '{gsub(/ *hours?,/, "h"); gsub(/ *minutes?/, "m"); print $2;}')
	else
		if [[ -f /proc/uptime ]]; then
			uptime=$(</proc/uptime)
			uptime=${uptime//.*}
		fi
	fi

	if [[ -n ${uptime} ]] && [[ "${distro}" != "Haiku" ]]; then
		mins=$((uptime/60%60))
		hours=$((uptime/3600%24))
		days=$((uptime/86400))
		uptime="${mins}m"
		if [ "${hours}" -ne "0" ]; then
			uptime="${hours}h ${uptime}"
		fi
		if [ "${days}" -ne "0" ]; then
			uptime="${days}d ${uptime}"
		fi
	else
		if [[ "$distro" =~ "NetBSD" ]]; then
			uptime=$(awk -F. '{print $1}' /proc/uptime)
		elif [[ "$distro" =~ "BSD" ]]; then
			uptime=$(uptime | awk '{$1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; sub(" days","d");sub(",","");sub(":","h ");sub(",","m"); print}')
		fi
	fi
	verboseOut "Finding current uptime...found as '${uptime}'"
}
# Uptime Detection - End


# Package Count - Begin
detectpkgs () {
	pkgs="Unknown"
	local offset=0
	case "${distro}" in
		'Alpine Linux') pkgs=$(apk info | wc -l) ;;
		'Arch Linux'|'ArcoLinux'|'Parabola GNU/Linux-libre'|'Hyperbola GNU/Linux-libre'|'Chakra'|'Manjaro'|'Antergos'| \
		'Netrunner'|'KaOS'|'Obarun'|'SwagArch'|'OBRevenge'|'Artix Linux'|'EndeavourOS')
			pkgs=$(pacman -Qq | wc -l) ;;
		'Chrome OS')
			if [ -d "/usr/local/lib/crew/packages" ]; then
				pkgs=$(ls -l /usr/local/etc/crew/meta/*.filelist | wc -l)
			else
				pkgs=$(ls -d /var/db/pkg/*/* | wc -l)
			fi
		;;
		'Dragora')
			pkgs=$(ls -1 /var/db/pkg | wc -l) ;;
		'Frugalware')
			pkgs=$(pacman-g2 -Q | wc -l) ;;
		'Debian'|'Ubuntu'|'Mint'|'Fuduntu'|'KDE neon'|'Devuan'|'OS Elbrus'|'Raspbian'|'LMDE'|'CrunchBang'|'Peppermint'| \
		'LinuxDeepin'|'Deepin'|'Kali Linux'|'Trisquel'|'elementary OS'|'gNewSense'|'BunsenLabs'|'SteamOS'|'Parrot Security'| \
		'GrombyangOS'|'DesaOS'|'Zorin OS'|'Proxmox VE'|'PureOS'|'DraugerOS')
			pkgs=$(dpkg -l | grep -c '^i') ;;
		'Slackware')
			pkgs=$(ls -1 /var/log/packages | wc -l) ;;
		'Gentoo'|'Sabayon'|'Funtoo'|'Kogaion')
			pkgs=$(ls -d /var/db/pkg/*/* | wc -l) ;;
		'NixOS')
			pkgs=$(nix path-info -r /run/current-system | wc -l) ;;
		'Guix System')
			pkgs=$(guix package --list-installed | wc -l) ;;
		'ALDOS'|'Fedora'|'Fux'|'Korora'|'BLAG'|'Chapeau'|'openSUSE'|'SUSE Linux Enterprise'|'Red Hat Enterprise Linux'| \
		'ROSA'|'Oracle Linux'|'Scientific Linux'|'EuroLinux'|'CentOS'|'Mandriva'|'Mandrake'|'Mageia'|'Mer'|'SailfishOS'|'PCLinuxOS'|'Viperr'|'Qubes OS'| \
		'Red Star OS'|'blackPanther OS'|'Amazon Linux')
			pkgs=$(rpm -qa | wc -l) ;;
		'Void Linux')
			pkgs=$(xbps-query -l | wc -l) ;;
		'Evolve OS')
			pkgs=$(pisi list-installed | wc -l) ;;
		'Sulin')
			pkgs=$(inary li | wc -l) ;;
		'Solus')
			pkgs=$(eopkg list-installed | wc -l) ;;
		'Source Mage GNU/Linux')
			pkgs=$(gaze installed | wc -l) ;;
		'CRUX'|'januslinux')
			pkgs=$(pkginfo -i | wc -l) ;;
		'Lunar Linux')
			pkgs=$(lvu installed | wc -l) ;;
		'TinyCore')
			pkgs=$(tce-status -i | wc -l) ;;
		'Exherbo')
			xpkgs=$(ls -d -1 /var/db/paludis/repositories/cross-installed/*/data/* | wc -l)
			pkgs=$(ls -d -1 /var/db/paludis/repositories/installed/data/* | wc -l)
			pkgs=$((pkgs + xpkgs))
		;;
		'Mac OS X'|'macOS')
			offset=1
			if [ -d "/usr/local/bin" ]; then
				loc_pkgs=$(ls -l /usr/local/bin/ | grep -cv "\(../Cellar/\|brew\)")
				pkgs=$((loc_pkgs - offset));
			fi
			if type -p port >/dev/null 2>&1; then
				port_pkgs=$(port installed 2>/dev/null | wc -l)
				pkgs=$((pkgs + (port_pkgs - offset)))
			fi
			if type -p brew >/dev/null 2>&1; then
				brew_pkgs=$(ls -1 /usr/local/Cellar/ | wc -l)
				pkgs=$((pkgs + brew_pkgs))
			fi
			if type -p pkgin >/dev/null 2>&1; then
				pkgsrc_pkgs=$(pkgin list 2>/dev/null | wc -l)
				pkgs=$((pkgs + pkgsrc_pkgs))
			fi
		;;
		'DragonFlyBSD')
			if TMPDIR=/dev/null ASSUME_ALWAYS_YES=1 PACKAGESITE=file:///nonexistent pkg info pkg >/dev/null 2>&1; then
				pkgs=$(pkg info | grep -c .)
			else
				pkgs=$(pkg_info | grep -c .)
			fi
		;;
		'OpenBSD'|'NetBSD')
			pkgs=$(pkg_info | grep -c .)
		;;
		'FreeBSD')
			pkgs=$(pkg info | grep -c .)
		;;
		'Cygwin')
			offset=2
			pkgs=$(($(cygcheck -cd | wc -l) - offset))
			if [ -d "/cygdrive/c/ProgramData/chocolatey/lib" ]; then
				chocopkgs=$(ls -1 /cygdrive/c/ProgramData/chocolatey/lib | wc -l)
				pkgs=$((pkgs + chocopkgs))
			fi
		;;
		'Msys')
			pkgs=$(pacman -Qq | wc -l)
			if [ -d "/c/ProgramData/chocolatey/lib" ]; then
				chocopkgs=$(ls -1 /c/ProgramData/chocolatey/lib | wc -l)
				pkgs=$((pkgs + chocopkgs))
			fi
		;;
		'Haiku')
			haikualpharelease="no"
			if [ -d /boot/system/package-links ]; then
				pkgs=$(ls /boot/system/package-links | wc -l)
			elif type -p installoptionalpackage >/dev/null 2>&1; then
				haikualpharelease="yes"
				pkgs=$(installoptionalpackage -l | sed -n '3p' | wc -w)
			fi
		;;	
	esac
	if [[ "${OSTYPE}" =~ "linux" && -z "${wsl}" ]] && snap list >/dev/null 2>&1; then
		offset=1
		snappkgs=$(($(snap list 2>/dev/null | wc -l) - offset))
		if [ $snappkgs -lt 0 ]; then
			snappkgs=0
		fi
		pkgs=$((pkgs + snappkgs))
	fi
	verboseOut "Finding current package count...found as '$pkgs'"
}




# CPU Detection - Begin
detectcpu () {
	local REGEXP="-r"
	if [[ "$distro" == "Mac OS X" || "$distro" == "macOS" ]]; then
		cpu=$(machine)
		if [[ $cpu == "ppc750" ]]; then
			cpu="IBM PowerPC G3"
		elif [[ $cpu == "ppc7400" || $cpu == "ppc7450" ]]; then
			cpu="IBM PowerPC G4"
		elif [[ $cpu == "ppc970" ]]; then
			cpu="IBM PowerPC G5"
		else
			cpu=$(sysctl -n machdep.cpu.brand_string)
		fi
		REGEXP="-E"
	elif [ "$OSTYPE" == "gnu" ]; then
		# no /proc/cpuinfo on GNU/Hurd
		if uname -m | grep -q 'i.86'; then
			cpu="Unknown x86"
		else
			cpu="Unknown"
		fi
	elif [ "$distro" == "FreeBSD" ]; then
		cpu=$(dmesg | awk -F': ' '/^CPU/ {gsub(/ +/," "); gsub(/\([^\(\)]*\)|CPU /,"", $2); print $2; exit}')
	elif [ "$distro" == "DragonFlyBSD" ]; then
		cpu=$(sysctl -n hw.model)
	elif [ "$distro" == "OpenBSD" ]; then
		cpu=$(sysctl -n hw.model | sed 's/@.*//')
	elif [ "$distro" == "Haiku" ]; then
		cpu=$(sysinfo -cpu | awk -F': ' '/^CPU #0/ {gsub(/ +/," "); gsub(/\([^\(\)]*\)|CPU /,"", $2); print $2; exit}')
	else
		cpu=$(awk -F':' '/^model name/ {split($2, A, " @"); print A[1]; exit}' /proc/cpuinfo)
		cpun=$(grep -c '^processor' /proc/cpuinfo)
		if [ -z "$cpu" ]; then
			cpu=$(awk 'BEGIN{FS=":"} /Hardware/ { print $2; exit }' /proc/cpuinfo)
		fi
		if [ -z "$cpu" ]; then
			cpu=$(awk 'BEGIN{FS=":"} /^cpu/ { gsub(/  +/," ",$2); print $2; exit}' /proc/cpuinfo | sed 's/, altivec supported//;s/^ //')
			if [[ $cpu =~ ^(PPC)*9.+ ]]; then
				model="IBM PowerPC G5 "
			elif [[ $cpu =~ 740/750 ]]; then
				model="IBM PowerPC G3 "
			elif [[ $cpu =~ ^74.+ ]]; then
				model="Motorola PowerPC G4 "
			elif [[ $cpu =~ ^POWER.* ]]; then
				model="IBM POWER "
			elif grep -q -i 'BCM2708' /proc/cpuinfo ; then
				model="Broadcom BCM2835 ARM1176JZF-S"
			else
				arch=$(uname -m)
				if [[ "$arch" == "s390x" || "$arch" == "s390" ]]; then
					cpu=""
					args=$(grep 'machine' /proc/cpuinfo | sed 's/^.*://g; s/ //g; s/,/\n/g' | grep '^machine=.*')
					eval "$args"
					case "$machine" in
						# information taken from https://github.com/SUSE/s390-tools/blob/master/cputype
						2064) model="IBM eServer zSeries 900" ;;
						2066) model="IBM eServer zSeries 800" ;;
						2084) model="IBM eServer zSeries 990" ;;
						2086) model="IBM eServer zSeries 890" ;;
						2094) model="IBM System z9 Enterprise Class" ;;
						2096) model="IBM System z9 Business Class" ;;
						2097) model="IBM System z10 Enterprise Class" ;;
						2098) model="IBM System z10 Business Class" ;;
						2817) model="IBM zEnterprise 196" ;;
						2818) model="IBM zEnterprise 114" ;;
						2827) model="IBM zEnterprise EC12" ;;
						2828) model="IBM zEnterprise BC12" ;;
						2964) model="IBM z13" ;;
						   *) model="IBM S/390 machine type $machine" ;;
					esac
				elif [[ "$arch" == "aarch64" ]]; then
					cpu_vendor=$(lscpu | grep ^Vendor | sed 's/^.*://g; s/ //g; s/,/\n/g')
					cpu=$(lscpu | grep ^Model\ name: | sed 's/^.*://g; s/ //g; s/,/\n/g')
					cpu="${cpu_vendor} ${cpu}"
				else
					model="Unknown"
				fi
			fi
			cpu="${model}${cpu}"
		fi
		loc="/sys/devices/system/cpu/cpu0/cpufreq"
		bl="${loc}/bios_limit"
		smf="${loc}/scaling_max_freq"
		if [ -f "$bl" ] && [ -r "$bl" ]; then
			cpu_mhz=$(awk '{print $1/1000}' "$bl")
		elif [ -f "$smf" ] && [ -r "$smf" ]; then
			cpu_mhz=$(awk '{print $1/1000}' "$smf")
		else
			cpu_mhz=$(awk -F':' '/cpu MHz/{ print int($2+.5) }' /proc/cpuinfo | head -n 1)
		fi
		if [ -n "$cpu_mhz" ]; then
			if [ "${cpu_mhz%.*}" -ge 1000 ]; then
				cpu_ghz=$(awk '{print $1/1000}' <<< "${cpu_mhz}")
				cpufreq="${cpu_ghz}GHz"
			else
				cpufreq="${cpu_mhz}MHz"
			fi
		fi
	fi
	if [[ "${cpun}" -gt "1" ]]; then
		cpun="${cpun}x "
	else
		cpun=""
	fi
	if [ -z "$cpufreq" ]; then
		cpu="${cpun}${cpu}"
	else
		cpu="$cpu @ ${cpun}${cpufreq}"
	fi
	if [ -d '/sys/class/hwmon/' ]; then
		for dir in /sys/class/hwmon/* ; do
			hwmonfile=""
			[ -e "$dir/name" ] && hwmonfile=$dir/name
			[ -e "$dir/device/name" ] && hwmonfile=$dir/device/name
			[ -n "$hwmonfile" ] && if grep -q 'coretemp' "$hwmonfile"; then
				thermal="$dir/temp1_input"
				break
			fi
		done
		if [ -e "$thermal" ] && [ "${thermal:+isSetToNonNull}" = 'isSetToNonNull' ]; then
			temperature=$(bc <<< "scale=1; $(cat "$thermal")/1000")
		fi
	fi
	if [ -n "$temperature" ]; then
		cpu="$cpu [${temperature}°C]"
	fi
	cpu=$(sed $REGEXP 's/\([tT][mM]\)|\([Rr]\)|[pP]rocessor|CPU//g' <<< "${cpu}" | xargs)
	verboseOut "Finding current CPU...found as '$cpu'"
}
# CPU Detection - End


# GPU Detection - Begin (EXPERIMENTAL!)
detectgpu () {
	if [[ "${distro}" == "FreeBSD" || "${distro}" == "DragonFlyBSD" ]]; then
		nvisettexist=$(which nvidia-settings)
		if [ -x "$nvisettexist" ]; then
			gpu="$(nvidia-settings -t -q gpus | grep \( | sed 's/.*(\(.*\))/\1/')"
		else
			gpu_info=$(pciconf -lv 2> /dev/null | grep -B 4 VGA)
			gpu_info=$(grep -E 'device.*=.*' <<< "${gpu_info}")
			gpu="${gpu_info##*device*= }"
			gpu="${gpu//\'}"
			# gpu=$(sed 's/.*device.*= //' <<< "${gpu_info}" | sed "s/'//g")
		fi
	elif [[ "${distro}" == "OpenBSD" ]]; then
		gpu=$(glxinfo 2> /dev/null | awk '/OpenGL renderer string/ { sub(/OpenGL renderer string: /,""); print }')
	elif [[ "${distro}" == "Mac OS X" || "${distro}" == "macOS" ]]; then
		gpu=$(system_profiler SPDisplaysDataType | awk -F': ' '/^ *Chipset Model:/ {print $2}' | awk '{ printf "%s / ", $0 }' | sed -e 's/\/ $//g')
	elif [[ "${distro}" == "Cygwin" || "${distro}" == "Msys" ]]; then
		gpu=$(wmic path Win32_VideoController get caption | sed -n '2p')
	elif [[ "${distro}" == "Haiku" ]]; then
		gpu="$(listdev | grep -A2 -e 'device Display controller' | awk -F': ' '/^ +device/ {print $2}')"
	else
		if [[ -n "$(PATH="/opt/bin:$PATH" type -p nvidia-smi)" ]]; then
			gpu=$($(PATH="/opt/bin:$PATH" type -p nvidia-smi | cut -f1) -q | awk -F':' '/Product Name/ {gsub(/: /,":"); print $2}' | sed ':a;N;$!ba;s/\n/, /g')
		elif [[ -n "$(PATH="/usr/sbin:$PATH" type -p glxinfo)" && -z "${gpu}" ]]; then
			gpu_info=$($(PATH="/usr/sbin:$PATH" type -p glxinfo | cut -f1) 2>/dev/null)
			gpu=$(grep "OpenGL renderer string" <<< "${gpu_info}" | cut -d ':' -f2 | sed -n -e '1h;2,$H;${g;s/\n/, /g' -e 'p' -e '}')
			gpu="${gpu:1}"
			gpu_info=$(grep "OpenGL vendor string" <<< "${gpu_info}")
		elif [[ -n "$(PATH="/usr/sbin:$PATH" type -p lspci)" && -z "$gpu" ]]; then
			gpu_info=$($(PATH="/usr/bin:$PATH" type -p lspci | cut -f1) 2> /dev/null | grep VGA)
			gpu=$(grep -oE '\[.*\]' <<< "${gpu_info}" | sed 's/\[//;s/\]//' | sed -n -e '1h;2,$H;${g;s/\n/, /g' -e 'p' -e '}')
		fi
	fi

	if [ -n "$gpu" ];then
		if grep -q -i 'nvidia' <<< "${gpu_info}"; then
			gpu_info="NVidia "
		elif grep -q -i 'intel' <<< "${gpu_info}"; then
			gpu_info="Intel "
		elif grep -q -i 'amd' <<< "${gpu_info}"; then
			gpu_info="AMD "
		elif grep -q -i 'ati' <<< "${gpu_info}" || grep -q -i 'radeon' <<< "${gpu_info}"; then
			gpu_info="ATI "
		else
			gpu_info=$(cut -d ':' -f2 <<< "${gpu_info}")
			gpu_info="${gpu_info:1} "
		fi
		gpu="${gpu}"
	else
		gpu="Not Found"
	fi

	verboseOut "Finding current GPU...found as '$gpu'"
}
# GPU Detection - End

# Detect Intel GPU  #works in dash
# Run it only on Intel Processors if GPU is unknown
DetectIntelGPU() {
	if [ -r /proc/fb ]; then
		gpu=$(awk 'BEGIN {ORS = " &"} {$1="";print}' /proc/fb | sed  -r s/'^\s+|\s*&$'//g)
	fi

	case $gpu in
		*mfb)
			gpu=$(lspci | grep -i vga | awk -F ": " '{print $2}') 
			;;
		*intel*)
			gpu="intel"
			;;
		*)
			gpu="Not Found"
			;;
	esac

	if [[ "$gpu" = "intel" ]]; then
		#Detect CPU
		local CPU=$(uname -p | awk '{print $3}')
		CPU=${CPU#*'-'}; #Detect CPU number

		#Detect Intel GPU
		case $CPU in
			[3-6][3-9][0-5]|[3-6][3-9][0-5][K-Y])
				gpu='Intel HD Graphics'
				;; #1st
			2[1-5][0-3][0-2]*|2390T|2600S)
				gpu='Intel HD Graphics 2000'
				;; #2nd
			2[1-5][1-7][0-8]*|2105|2500K)
				gpu='Intel HD Graphics 3000'
				;; #2nd
			32[1-5]0*|3[4-5][5-7]0*|33[3-4]0*)
				gpu='Intel HD Graphics 2500'
				;; #3rd
			3570K|3427U)
				gpu='Intel HD Graphics 4000'
				;; #3rd
			4[3-7][0-9][0-5]*)
				gpu='Intel HD Graphics 4600'
				;; #4th Haswell
			5[5-6]75[C-R]|5350H)
				gpu='Intel Iris Pro Graphics 6200'
				;; #5th Broadwell
				#6th Skylake
				#7th Kabylake
				#8th Cannonlake
			*)
				gpu='Unknown'
				;; #Unknown GPU model
		esac
	fi
}

# Disk Usage Detection - Begin
detectdisk () {
	diskusage="Unknown"
	if type -p df >/dev/null 2>&1; then
		if [[ "${distro}" =~ (Free|Net|DragonFly)BSD ]]; then
			totaldisk=$(df -h -c 2>/dev/null | tail -1)
		elif [[ "${distro}" == "OpenBSD" ]]; then
			totaldisk=$(df -Pk 2> /dev/null | awk '
				/^\// {total+=$2; used+=$3; avail+=$4}
				END{printf("total %.1fG %.1fG %.1fG %d%%\n", total/1048576, used/1048576, avail/1048576, used*100/total)}')
		elif [[ "${distro}" == "Mac OS X" || "${distro}" == "macOS" ]]; then
                        majorVers=$(sw_vers | grep "ProductVersion" | cut -d ':' -f 2 | awk -F "." '{print $1}') # Major version
			minorVers=$(sw_vers | grep "ProductVersion" | cut -d ':' -f 2 | awk -F "." '{print $2}') # Minor version
			if [[ "${minorVers}" -ge "15" || "${majorVers}" -ge "11" ]]; then # Catalina or newer
				totaldisk=$(df -H /System/Volumes/Data 2>/dev/null | tail -1)
			else
				totaldisk=$(df -H / 2>/dev/null | tail -1)
			fi
		else
			totaldisk=$(df -h -x aufs -x tmpfs -x overlay -x drvfs --total 2>/dev/null | tail -1)
		fi
		disktotal=$(awk '{print $2}' <<< "${totaldisk}")
		diskused=$(awk '{print $3}' <<< "${totaldisk}")
		diskusedper=$(awk '{print $5}' <<< "${totaldisk}")
		diskusage="${diskused} / ${disktotal} (${diskusedper})"
		diskusage_verbose=$(sed 's/%/%%/' <<< "$diskusage")
	fi
	verboseOut "Finding current disk usage...found as '$diskusage_verbose'"
}
# Disk Usage Detection - End


# Memory Detection - Begin
detectmem () {
	if [[ "$distro" == "Mac OS X" || "$distro" == "macOS" ]]; then
		totalmem=$(echo "$(sysctl -n hw.memsize)" / 1024^2 | bc)
		wiredmem=$(vm_stat | grep wired | awk '{ print $4 }' | sed 's/\.//')
		activemem=$(vm_stat | grep ' active' | awk '{ print $3 }' | sed 's/\.//')
		compressedmem=$(vm_stat | grep occupied | awk '{ print $5 }' | sed 's/\.//')
		if [[ ! -z "$compressedmem | tr -d" ]]; then  # FIXME: is this line correct?
			compressedmem=0
		fi
		usedmem=$(((wiredmem + activemem + compressedmem) * 4 / 1024))
	elif [[ "${distro}" == "Cygwin" || "${distro}" == "Msys" ]]; then
		total_mem=$(awk '/MemTotal/ { print $2 }' /proc/meminfo)
		totalmem=$((total_mem / 1024))
		free_mem=$(awk '/MemFree/ { print $2 }' /proc/meminfo)
		used_mem=$((total_mem - free_mem))
		usedmem=$((used_mem / 1024))
	elif [[ "$distro" == "FreeBSD"  || "$distro" == "DragonFlyBSD" ]]; then
		phys_mem=$(sysctl -n hw.physmem)
		size_mem=$phys_mem
		size_chip=1
		guess_chip=$(echo "$size_mem / 8 - 1" | bc)
		while [ "$guess_chip" != 0 ]; do
			guess_chip=$(echo "$guess_chip / 2" | bc)
			size_chip=$(echo "$size_chip * 2" | bc)
		done
		round_mem=$(echo "( $size_mem / $size_chip + 1 ) * $size_chip " | bc)
		totalmem=$((round_mem / 1024 / 1024))
		pagesize=$(sysctl -n hw.pagesize)
		inactive_count=$(sysctl -n vm.stats.vm.v_inactive_count)
		inactive_mem=$((inactive_count * pagesize))
		cache_count=$(sysctl -n vm.stats.vm.v_cache_count)
		cache_mem=$((cache_count * pagesize))
		free_count=$(sysctl -n vm.stats.vm.v_free_count)
		free_mem=$((free_count * pagesize))
		avail_mem=$((inactive_mem + cache_mem + free_mem))
		used_mem=$((round_mem - avail_mem))
		usedmem=$((used_mem / 1024 / 1024))
	elif [ "$distro" == "OpenBSD" ]; then
		totalmem=$(($(sysctl -n hw.physmem) / 1024 / 1024))
		usedmem=$(vmstat | awk '!/[a-z]/{gsub("M",""); print $3}')
	elif [ "$distro" == "NetBSD" ]; then
		phys_mem=$(awk '/MemTotal/ { print $2 }' /proc/meminfo)
		totalmem=$((phys_mem / 1024))
		if grep -q 'Cached' /proc/meminfo; then
			cache=$(awk '/Cached/ {print $2}' /proc/meminfo)
			usedmem=$((cache / 1024))
		else
			free_mem=$(awk '/MemFree/ { print $2 }' /proc/meminfo)
			used_mem=$((phys_mem - free_mem))
			usedmem=$((used_mem / 1024))
		fi
	elif [ "$distro" == "Haiku" ]; then
		totalmem=$(sysinfo -mem | awk 'NR == 1 {gsub(/[\(\)\/]/, ""); printf("%d", $6/1024**2)}')
		usedmem=$(sysinfo -mem | awk 'NR == 1 {gsub(/[\(\)\/]/, ""); printf("%d", $5/1024**2)}')
	else
		# MemUsed = Memtotal + Shmem - MemFree - Buffers - Cached - SReclaimable
		# Source: https://github.com/dylanaraps/neofetch/pull/391/files#diff-e863270127ca6116fd30e708cdc582fc
		#mem_info=$(</proc/meminfo)
		#mem_info=$(echo $(echo $(mem_info=${mem_info// /}; echo ${mem_info//kB/})))
		#for m in $mem_info; do
		#	case ${m//:*} in
		#		"MemTotal") usedmem=$((usedmem+=${m//*:})); totalmem=${m//*:} ;;
		#		"Shmem") usedmem=$((usedmem+=${m//*:})) ;;
		#		"MemFree"|"Buffers"|"Cached"|"SReclaimable") usedmem=$((usedmem-=${m//*:})) ;;
		#	esac
		#done
		#usedmem=$((usedmem / 1024))
		#totalmem=$((totalmem / 1024))
		mem=$(free -b | awk 'NR==2{print $2"-"$7}')
		usedmem=$((mem / 1024 / 1024))
		totalmem=$((${mem//-*} / 1024 / 1024))
	fi
	mem="${usedmem}MiB / ${totalmem}MiB"
	verboseOut "Finding current RAM usage...found as '$mem'"
}
# Memory Detection - End


# Shell Detection - Begin
detectshell_ver () {
	local version_data='' version='' get_version='--version'

	case $1 in
		# ksh sends version to stderr. Weeeeeeird.
		ksh)
			version_data="$( $1 $get_version 2>&1 )"
			;;
		*)
			version_data="$( $1 $get_version 2>/dev/null )"
			;;
	esac

	if [[ -n $version_data ]];then
		version=$(awk '
		BEGIN {
			IGNORECASE=1
		}
		/'$2'/ {
			gsub(/(,|v|V)/, "",$'$3')
			if ($2 ~ /[Bb][Aa][Ss][Hh]/) {
				gsub(/\(.*|-release|-version\)/,"",$4)
			}
			print $'$3'
			exit # quit after first match prints
		}' <<< "$version_data")
	fi
	echo "$version"
}
detectshell () {
	if [[ ! "${shell_type}" ]]; then
		if [[ "${distro}" == "Cygwin" || "${distro}" == "Msys" || "${distro}" == "Haiku" || "${distro}" == "Alpine Linux" ||
			"${distro}" == "Mac OS X" || "${distro}" == "macOS" || "${distro}" == "TinyCore" || "${distro}" == "Raspbian" || "${OSTYPE}" == "gnu" ]]; then
			shell_type=$(echo "$SHELL" | awk -F'/' '{print $NF}')
		elif readlink -f "$SHELL" 2>&1 | grep -q -i 'busybox'; then
			shell_type="BusyBox"
		else
			if [[ "${OSTYPE}" =~ "linux" ]]; then
				shell_type=$(realpath /proc/$PPID/exe | awk -F'/' '{print $NF}')
			elif [[ "${distro}" =~ "BSD" ]]; then
				shell_type=$(ps -p $PPID -o command | tail -1)
			else
				shell_type=$(ps -p "$(ps -p $PPID | awk '$1 !~ /PID/ {print $1}')" | awk 'FNR>1 {print $1}')
			fi
			shell_type=${shell_type/-}
			shell_type=${shell_type//*\/}
		fi
	fi

	case $shell_type in
		bash)
			shell_version_data=$( detectshell_ver "$shell_type" "^GNU.bash,.version" "4" )
			;;
		BusyBox)
			shell_version_data=$( busybox | head -n1 | cut -d ' ' -f2 )
			;;
		csh)
			shell_version_data=$( detectshell_ver "$shell_type" "$shell_type" "3" )
			;;
		dash)
			shell_version_data=$( detectshell_ver "$shell_type" "$shell_type" "3" )
			;;
		ksh)
			shell_version_data=$( detectshell_ver "$shell_type" "version" "5" )
			;;
		tcsh)
			shell_version_data=$( detectshell_ver "$shell_type" "^tcsh" "2" )
			;;
		zsh)
			shell_version_data=$( detectshell_ver "$shell_type" "^zsh" "2" )
			;;
		fish)
			shell_version_data=$( fish --version | awk '{print $3}' )
			;;
	esac

	if [[ -n $shell_version_data ]];then
		shell_type="$shell_type $shell_version_data"
	fi

	myShell=${shell_type}
	verboseOut "Finding current shell...found as '$myShell'"
}
# Shell Detection - End


# Resolution Detection - Begin
detectres () {
	xResolution="No X Server"
	if [[ ${distro} == "Mac OS X" || $distro == "macOS" ]]; then
		xResolution=$(system_profiler SPDisplaysDataType | awk '/Resolution:/ {print $2"x"$4" "}')
		if [[ "$(echo "$xResolution" | wc -l)" -ge 1 ]]; then
			xResolution=$(echo "$xResolution" | tr " \\n" ", " | sed 's/\(.*\),/\1/')
		fi
	elif [[ "${distro}" == "Cygwin" || "${distro}" == "Msys" ]]; then
		xResolution=$(wmic path Win32_VideoController get CurrentHorizontalResolution,CurrentVerticalResolution | awk 'NR==2 {print $1"x"$2}')
	elif [[ "${distro}" == "Haiku" ]]; then
		xResolution="$(screenmode | grep Resolution | awk '{gsub(/,/,""); print $2"x"$3}')"
	elif [[ -n ${DISPLAY} ]]; then
		if type -p xdpyinfo >/dev/null 2>&1; then
			xResolution=$(xdpyinfo | awk '/^ +dimensions/ {print $2}')
		fi
	fi
	verboseOut "Finding current resolution(s)...found as '$xResolution'"
}
# Resolution Detection - End


# DE Detection - Begin
detectde () {
	DE="Not Present"
	if [[ "${distro}" == "Mac OS X" || "${distro}" == "macOS" ]]; then
		if ps -U "${USER}" | grep -q -i 'finder'; then
			DE="Aqua"
		fi
	elif [[ "${distro}" == "Cygwin" || "${distro}" == "Msys" ]]; then
		# https://msdn.microsoft.com/en-us/library/ms724832%28VS.85%29.aspx
		if wmic os get version | grep -q '^\(6\.[01]\)'; then
			DE="Aero"
		elif wmic os get version | grep -q '^\(6\.[23]\|10\)'; then
			DE="Modern UI/Metro"
		else
			DE="Luna"
		fi
	elif [[ -n ${DISPLAY} ]]; then
		if type -p xprop >/dev/null 2>&1;then
			xprop_root="$(xprop -root 2>/dev/null)"
			if [[ -n ${xprop_root} ]]; then
				DE=$(echo "${xprop_root}" | awk 'BEGIN {
					de = "Not Present"
				}
				{
					if ($1 ~ /^_DT_SAVE_MODE/) {
						de = $NF
						gsub(/"/,"",de)
						de = toupper(de)
						exit
					}
					else if ($1 ~/^KDE_SESSION_VERSION/) {
						de = "KDE"$NF
						exit
					}
					else if ($1 ~ /^_MUFFIN/) {
						de = "Cinnamon"
						exit
					}
					else if ($1 ~ /^TDE_FULL_SESSION/) {
						de = "Trinity"
						exit
					}
					else if ($0 ~ /"xfce4"/) {
						de = "Xfce4"
						exit
					}
					else if ($0 ~ /"xfce5"/) {
						de = "Xfce5"
						exit
					}
				} END {
					print de
				}')
			fi
		fi

		if [[ ${DE} == "Not Present" ]]; then
			# Let's use xdg-open code for GNOME/Enlightment/KDE/LXDE/MATE/Xfce detection
			# http://bazaar.launchpad.net/~vcs-imports/xdg-utils/master/view/head:/scripts/xdg-utils-common.in#L251
			if [ -n "${XDG_CURRENT_DESKTOP}" ]; then
				case "${XDG_CURRENT_DESKTOP,,}" in
					'enlightenment')
						DE="Enlightenment"
						;;
					'gnome')
						DE="GNOME"
						;;
					'kde')
						DE="KDE"
						;;
					'lumina')
						DE="Lumina"
						;;
					'lxde')
						DE="LXDE"
						;;
					'mate')
						DE="MATE"
						;;
					'xfce')
						DE="Xfce"
						;;
					'x-cinnamon')
						DE="Cinnamon"
						;;
					'unity')
						DE="Unity"
						;;
					'lxqt')
						DE="LXQt"
						;;
				esac
			fi

			if [ -n "$DE" ]; then
				# classic fallbacks
				if [ -n "$KDE_FULL_SESSION" ]; then
					DE="KDE"
				elif [ -n "$TDE_FULL_SESSION" ]; then
					DE="Trinity"
				elif [ -n "$GNOME_DESKTOP_SESSION_ID" ]; then
					DE="GNOME"
				elif [ -n "$MATE_DESKTOP_SESSION_ID" ]; then
					DE="MATE"
				elif dbus-send --print-reply --dest=org.freedesktop.DBus /org/freedesktop/DBus \
					org.freedesktop.DBus.GetNameOwner string:org.gnome.SessionManager >/dev/null 2>&1 ; then
					DE="GNOME"
				elif xprop -root _DT_SAVE_MODE 2> /dev/null | grep -q -i ' = \"xfce4\"$'; then
					DE="Xfce"
				elif xprop -root 2> /dev/null | grep -q -i '^xfce_desktop_window'; then
					DE="Xfce"
				elif echo "$DESKTOP" | grep -q -i '^Enlightenment'; then
					DE="Enlightenment"
				fi
			fi

			if [[ -z "$DE" || "$DE" = "Not Present" ]]; then
				# fallback to checking $DESKTOP_SESSION
				case "${DESKTOP_SESSION,,}" in
					'gnome'*)
						DE="GNOME"
						;;
					'deepin')
						DE="Deepin"
						;;
					'lumina')
						DE="Lumina"
						;;
					'lxde'|'lubuntu')
						DE="LXDE"
						;;
					'mate')
						DE="MATE"
						;;
					'xfce'*)
						DE="Xfce"
						;;
					'budgie-desktop')
						DE="Budgie"
						;;
					'cinnamon')
						DE="Cinnamon"
						;;
					'trinity')
						DE="Trinity"
						;;
				esac
			fi

			if [ -n "$DE" ]; then
				# fallback to checking $GDMSESSION
				case "${GDMSESSION,,}" in
					'lumina'*)
						DE="Lumina"
						;;
					'mate')
						DE="MATE"
						;;
				esac
			fi

			if [[ ${DE} == "GNOME" ]]; then
				if type -p xprop >/dev/null 2>&1; then
					if xprop -name "unity-launcher" >/dev/null 2>&1; then
						DE="Unity"
					elif xprop -name "launcher" >/dev/null 2>&1 &&
						xprop -name "panel" >/dev/null 2>&1; then
						DE="Unity"
					fi
				fi
			fi

			if [[ ${DE} == "KDE" ]]; then
				if [[ -n ${KDE_SESSION_VERSION} ]]; then
					if [[ ${KDE_SESSION_VERSION} == '5' ]]; then
						DE="KDE5"
					elif [[ ${KDE_SESSION_VERSION} == '4' ]]; then
						DE="KDE4"
					fi
				elif [[ ${KDE_FULL_SESSION} == 'true' ]]; then
					DE="KDE"
					DEver_data=$(kded --version 2>/dev/null)
					DEver=$(grep -si '^KDE:' <<< "$DEver_data" | awk '{print $2}')
				fi
			fi
		fi

		if [[ ${DE} != "Not Present" ]]; then
			if [[ ${DE} == "Cinnamon" ]]; then
				if type -p >/dev/null 2>&1; then
					DEver=$(cinnamon --version)
					DE="${DE} ${DEver//* }"
				fi
			elif [[ ${DE} == "GNOME" ]]; then
				if type -p gnome-control-center>/dev/null 2>&1; then
					DEver=$(gnome-control-center --version 2> /dev/null)
					DE="${DE} ${DEver//* }"
				elif type -p gnome-session-properties >/dev/null 2>&1; then
					DEver=$(gnome-session-properties --version 2> /dev/null)
					DE="${DE} ${DEver//* }"
				elif type -p gnome-session >/dev/null 2>&1; then
					DEver=$(gnome-session --version 2> /dev/null)
					DE="${DE} ${DEver//* }"
				fi
			elif [[ ${DE} == "KDE4" || ${DE} == "KDE5" ]]; then
				if type -p kded${DE#KDE} >/dev/null 2>&1; then
					DEver=$(kded${DE#KDE} --version)
					if [[ $(( $(echo "$DEver" | wc -w) )) -eq 2 ]] && [[ "$(echo "$DEver" | cut -d ' ' -f1)" == "kded${DE#KDE}" ]]; then
						DEver=$(echo "$DEver" | cut -d ' ' -f2)
						DE="KDE ${DEver}"
					else
						for l in $(echo "${DEver// /_}"); do
							if [[ ${l//:*} == "KDE_Development_Platform" ]]; then
								DEver=${l//*:_}
								DE="KDE ${DEver//_*}"
							fi
						done
					fi
					if pgrep -U ${UID} plasmashell >/dev/null 2>&1; then
						DEver=$(plasmashell --version | cut -d ' ' -f2)
						DE="$DE / Plasma $DEver"
					fi
				fi
			elif [[ ${DE} == "Lumina" ]]; then
				if type -p Lumina-DE.real >/dev/null 2>&1; then
					lumina="$(type -p Lumina-DE.real)"
				elif type -p Lumina-DE >/dev/null 2>&1; then
					lumina="$(type -p Lumina-DE)"
				fi
				if [ -n "$lumina" ]; then
					if grep -q '--version' "$lumina"; then
						DEver=$("$lumina" --version 2>&1 | tr -d \")
						DE="${DE} ${DEver}"
					fi
				fi
			elif [[ ${DE} == "LXQt" ]]; then
				if type -p lxqt-about >/dev/null 2>&1; then
					DEver=$(lxqt-about --version | awk '/^liblxqt/ {print $2}')
					DE="${DE} ${DEver}"
				fi
			elif [[ ${DE} == "MATE" ]]; then
				if type -p mate-session >/dev/null 2>&1; then
					DEver=$(mate-session --version)
					DE="${DE} ${DEver//* }"
				fi
			elif [[ ${DE} == "Unity" ]]; then
				if type -p unity >/dev/null 2>&1; then
					DEver=$(unity --version)
					DE="${DE} ${DEver//* }"
				fi
			elif [[ ${DE} == "Deepin" ]]; then
				if [[ -f /etc/deepin-version ]]; then
					DEver="$(awk -F '=' '/Version/ {print $2}' /etc/deepin-version)"
					DE="${DE} ${DEver//* }"
				fi
			elif [[ ${DE} == "Trinity" ]]; then
				if type -p tde-config >/dev/null 2>&1; then
					DEver="$(tde-config --version | awk -F ' ' '/TDE:/ {print $2}')"
					DE="${DE} ${DEver//* }"
				fi
			fi
		fi

		if [[ "${DE}" == "Not Present" ]]; then
			if pgrep -U ${UID} lxsession >/dev/null 2>&1; then
				DE="LXDE"
				if type -p lxpanel >/dev/null 2>&1; then
					DEver=$(lxpanel -v)
					DE="${DE} $DEver"
				fi
			elif pgrep -U ${UID} lxqt-session >/dev/null 2>&1; then
				DE="LXQt"
			elif pgrep -U ${UID} razor-session >/dev/null 2>&1; then
				DE="RazorQt"
			elif pgrep -U ${UID} dtsession >/dev/null 2>&1; then
				DE="CDE"
			fi
		fi
	fi
	verboseOut "Finding desktop environment...found as '$DE'"
}
### DE Detection - End


# WM Detection - Begin
detectwm () {
	WM="Not Found"
	if [[ ${distro} == "Mac OS X" || ${distro} == "macOS" ]]; then
		if ps -U "${USER}" | grep -q -i 'finder'; then
			WM="Quartz Compositor"
		fi
	elif [[ "${distro}" == "Cygwin" || "${distro}" == "Msys" ]]; then
		if [ "$(tasklist | grep -o 'bugn' | tr -d '\r \n')" = "bugn" ]; then
			WM="bug.n"
		elif [ "$(tasklist | grep -o 'Windawesome' | tr -d '\r \n')" = "Windawesome" ]; then
			WM="Windawesome"
		elif [ "$(tasklist | grep -o 'blackbox' | tr -d '\r \n')" = "blackbox" ]; then
			WM="Blackbox"
		else
			WM="DWM/Explorer"
		fi
	elif [[ -n ${DISPLAY} ]]; then
		if [[ "${distro}" == "FreeBSD" ]]; then
			pgrep_flags="-aU"
		else
			pgrep_flags="-U"
		fi
		for each in "${wmnames[@]}"; do
			PID="$(pgrep ${pgrep_flags} ${UID} "^$each$")"
			if [ "$PID" ]; then
				case $each in
					'2bwm') WM="2bwm";;
					'9wm') WM="9wm";;
					'awesome') WM="Awesome";;
					'beryl') WM="Beryl";;
					'blackbox') WM="BlackBox";;
					'bspwm') WM="bspwm";;
					'budgie-wm') WM="BudgieWM";;
					'chromeos-wm') WM="chromeos-wm";;
					'cinnamon') WM="Muffin";;
					'compiz') WM="Compiz";;
					'deepin-wm') WM="deepin-wm";;
					'dminiwm') WM="dminiwm";;
					'dtwm') WM="dtwm";;
					'dwm') WM="dwm";;
					'e16') WM="E16";;
					'emerald') WM="Emerald";;
					'enlightenment') WM="E17";;
					'fluxbox') WM="FluxBox";;
					'flwm'|'flwm_topside') WM="FLWM";;
					'fvwm') WM="FVWM";;
					'herbstluftwm') WM="herbstluftwm";;
					'howm') WM="howm";;
					'i3') WM="i3";;
					'icewm') WM="IceWM";;
					'kwin') WM="KWin";;
					'metacity') WM="Metacity";;
					'monsterwm') WM="monsterwm";;
					'musca') WM="Musca";;
					'mwm') WM="MWM";;
					'notion') WM="Notion";;
					'openbox') WM="OpenBox";;
					'pekwm') WM="PekWM";;
					'ratpoison') WM="Ratpoison";;
					'sawfish') WM="Sawfish";;
					'scrotwm') WM="ScrotWM";;
					'spectrwm') WM="SpectrWM";;
					'stumpwm') WM="StumpWM";;
					'subtle') WM="subtle";;
					'sway') WM="sway";;
					'swm') WM="swm";;
					'twin') WM="TWin";;
					'wmaker') WM="WindowMaker";;
					'wmfs') WM="WMFS";;
					'wmii') WM="wmii";;
					'xfwm4') WM="Xfwm4";;
					'xmonad.*') WM="XMonad";;
				esac
			fi
			if [[ ${WM} != "Not Found" ]]; then
				break 1
			fi
		done

		if [[ ${WM} == "Not Found" ]]; then
			if type -p xprop >/dev/null 2>&1; then
				WM=$(xprop -root _NET_SUPPORTING_WM_CHECK)
				if [[ "$WM" =~ 'not found' ]]; then
					WM="Not Found"
				elif [[ "$WM" =~ 'Not found' ]]; then
					WM="Not Found"
				elif [[ "$WM" =~ '[Ii]nvalid window id format' ]]; then
					WM="Not Found"
				elif [[ "$WM" =~ "no such" ]]; then
					WM="Not Found"
				else
					WM=${WM//* }
					WM=$(xprop -id "${WM}" 8s _NET_WM_NAME)
					WM=$(echo "$(WM=${WM//*= }; echo "${WM//\"}")")
				fi
			fi
		fi

		# Proper format WM names that need it.
		if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
			if [[ ${BASH_VERSINFO[0]} -eq 4 && ${BASH_VERSINFO[1]} -gt 1 ]] || [[ ${BASH_VERSINFO[0]} -gt 4 ]]; then
				WM_lower=${WM,,}
			else
				WM_lower="$(tr '[:upper:]' '[:lower:]' <<< "${WM}")"
			fi
		else
			WM_lower="$(tr '[:upper:]' '[:lower:]' <<< "${WM}")"
		fi
		case ${WM_lower} in
			*'gala'*) WM="Gala";;
			'2bwm') WM="2bwm";;
			'awesome') WM="Awesome";;
			'beryl') WM="Beryl";;
			'blackbox') WM="BlackBox";;
			'budgiewm') WM="BudgieWM";;
			'chromeos-wm') WM="chromeos-wm";;
			'cinnamon') WM="Cinnamon";;
			'compiz') WM="Compiz";;
			'deepin-wm') WM="Deepin WM";;
			'dminiwm') WM="dminiwm";;
			'dwm') WM="dwm";;
			'e16') WM="E16";;
			'echinus') WM="echinus";;
			'emerald') WM="Emerald";;
			'enlightenment') WM="E17";;
			'fluxbox') WM="FluxBox";;
			'flwm'|'flwm_topside') WM="FLWM";;
			'fvwm') WM="FVWM";;
			'gnome shell'*) WM="Mutter";;
			'herbstluftwm') WM="herbstluftwm";;
			'howm') WM="howm";;
			'i3') WM="i3";;
			'icewm') WM="IceWM";;
			'kwin') WM="KWin";;
			'metacity') WM="Metacity";;
			'monsterwm') WM="monsterwm";;
			'muffin') WM="Muffin";;
			'musca') WM="Musca";;
			'mutter'*) WM="Mutter";;
			'mwm') WM="MWM";;
			'notion') WM="Notion";;
			'openbox') WM="OpenBox";;
			'pekwm') WM="PekWM";;
			'ratpoison') WM="Ratpoison";;
			'sawfish') WM="Sawfish";;
			'scrotwm') WM="ScrotWM";;
			'spectrwm') WM="SpectrWM";;
			'stumpwm') WM="StumpWM";;
			'subtle') WM="subtle";;
			'sway') WM="sway";;
			'swm') WM="swm";;
			'twin') WM="TWin";;
			'wmaker') WM="WindowMaker";;
			'wmfs') WM="WMFS";;
			'wmii') WM="wmii";;
			'xfwm4') WM="Xfwm4";;
			'xmonad') WM="XMonad";;
		esac
	fi
	verboseOut "Finding window manager...found as '$WM'"
}
# WM Detection - End


# WM Theme Detection - BEGIN
detectwmtheme () {
	Win_theme="Not Found"
	if [[ "${distro}" == "Mac OS X" || "${distro}" == "macOS" ]]; then
		themeNumber="$(defaults read NSGlobalDomain AppleAquaColorVariant 2>/dev/null)"
		accentColorNumber="$(defaults read NSGlobalDomain AppleAccentColor 2>/dev/null)"
		interfaceStyle="$(defaults read NSGlobalDomain AppleInterfaceStyle 2>/dev/null)"
		if [ "${themeNumber}" == "1" ] || [ "${themeNumber}x" == "x" ]; then
			case "${accentColorNumber}" in
			"5")
				Win_theme="Purple"
				;;
			"6")
				Win_theme="Pink"
				;;
			"0")
				Win_theme="Red"
				;;
			"1")
				Win_theme="Orange"
				;;
			"2")
				Win_theme="Yellow"
				;;
			"3")
				Win_theme="Green"
				;;
			*)
				Win_theme="Blue"
				;;
			esac
		else
			Win_theme="Graphite"
		fi
		if [ "${interfaceStyle}" == "Dark" ]; then
			Win_theme="${Win_theme} (Dark)"
		fi
	elif [[ "${distro}" == "Cygwin" || "${distro}" == "Msys" ]]; then
		if [ "${WM}" == "Blackbox" ]; then
			if [ "${distro}" == "Msys" ]; then
				Blackbox_loc=$(reg query 'HKLM\Software\Microsoft\Windows NT\CurrentVersion\WinLogon' //v 'Shell')
			else
				Blackbox_loc=$(reg query 'HKLM\Software\Microsoft\Windows NT\CurrentVersion\WinLogon' /v 'Shell')
			fi
			Blackbox_loc="$(echo "${Blackbox_loc}" | sed 's/.*REG_SZ//' | sed -e 's/^[ \t]*//' | sed 's/.\{4\}$//')"
			Win_theme=$(grep 'session.styleFile' "${Blackbox_loc}.rc" | sed 's/ //g' | sed 's/session\.styleFile://g' | sed 's/.*\\//g')
		else
			if [[ "${distro}" == "Msys" ]]; then
				themeFile="$(reg query 'HKCU\Software\Microsoft\Windows\CurrentVersion\Themes' //v 'CurrentTheme')"
			else
				themeFile="$(reg query 'HKCU\Software\Microsoft\Windows\CurrentVersion\Themes' /v 'CurrentTheme')"
			fi
			Win_theme=$(echo "$themeFile" | awk -F"\\" '{print $NF}' | sed 's|\.theme$||')
		fi
	else
		case $WM in
			'2bwm'|'9wm'|'Beryl'|'bspwm'|'dminiwm'|'dwm'|'echinus'|'FVWM'|'howm'|'i3'|'monsterwm'|'Musca'|\
			'Notion'|'Ratpoison'|'ScrotWM'|'SpectrWM'|'swm'|'subtle'|'WindowMaker'|'WMFS'|'wmii'|'XMonad')
				Win_theme="Not Applicable"
			;;
			'Awesome')
				if [ -f "${XDG_CONFIG_HOME:-${HOME}/.config}/awesome/rc.lua" ]; then
					Win_theme="$(grep '^[^-].*\(theme\|beautiful\).*lua' "${XDG_CONFIG_HOME:-${HOME}/.config}/awesome/rc.lua" | grep '[^/]\+/[^/]\+.lua' -o | cut -d'/' -f1 | head -1)"
				fi
			;;
			'BlackBox')
				if [ -f "$HOME/.blackboxrc" ]; then
					Win_theme="$(awk -F"/" '/styleFile/ {print $NF}' "$HOME/.blackboxrc")"
				fi
			;;
			'BudgieWM')
				Win_theme="$(gsettings get org.gnome.desktop.wm.preferences theme)"
				Win_theme="${Win_theme//\'}"
			;;
			'Cinnamon'|'Muffin')
				de_theme="$(gsettings get org.cinnamon.theme name)"
				de_theme=${de_theme//"'"}
				win_theme="$(gsettings get org.cinnamon.desktop.wm.preferences theme)"
				win_theme=${win_theme//"'"}
				Win_theme="${de_theme} (${win_theme})"
			;;
			'Compiz'|'Mutter'*|'GNOME Shell'|'Gala')
				if type -p gsettings >/dev/null 2>&1; then
					Win_theme="$(gsettings get org.gnome.shell.extensions.user-theme name 2>/dev/null)"
					if [[ -z "$Win_theme" ]]; then
						Win_theme="$(gsettings get org.gnome.desktop.wm.preferences theme)"
					fi
					Win_theme=${Win_theme//"'"}
				elif type -p gconftool-2 >/dev/null 2>&1; then
					Win_theme=$(gconftool-2 -g /apps/metacity/general/theme)
				fi
			;;
			'Deepin WM')
				if type -p gsettings >/dev/null 2>&1; then
					Win_theme="$(gsettings get com.deepin.wrap.gnome.desktop.wm.preferences theme)"
					Win_theme=${Win_theme//"'"}
				fi
			;;
			'E16')
				Win_theme="$(awk -F"= " '/theme.name/ {print $2}' $HOME/.e16/e_config--*.cfg)"
			;;
			'E17'|'Enlightenment')
				if [ "$(which eet 2>/dev/null)" ]; then
					econfig="$(eet -d "$HOME/.e/e/config/standard/e.cfg" config | awk '/value \"file\" string.*.edj/{ print $4 }')"
					econfigend="${econfig##*/}"
					Win_theme=${econfigend%.*}
				elif [ -n "${E_CONF_PROFILE}" ]; then
					#E17 doesn't store cfg files in text format so for now get the profile as opposed to theme. atyoung
					#TODO: Find a way to extract and read E17 .cfg files ( google seems to have nothing ). atyoung
					Win_theme="${E_CONF_PROFILE}"
				fi
			;;
			'Emerald')
				if [ -f "$HOME/.emerald/theme/theme.ini" ]; then
					Win_theme="$(for a in /usr/share/emerald/themes/* $HOME/.emerald/themes/*; do cmp "$HOME/.emerald/theme/theme.ini" "$a/theme.ini" &>/dev/null && basename "$a"; done)"
				fi
			;;
			'FluxBox'|'Fluxbox')
				if [ -f "$HOME/.fluxbox/init" ]; then
					Win_theme="$(awk -F"/" '/styleFile/ {print $NF}' "$HOME/.fluxbox/init")"
				fi
			;;
			'IceWM')
				if [ -f "$HOME/.icewm/theme" ]; then
					Win_theme="$(awk -F"[\",/]" '!/#/ {print $2}' "$HOME/.icewm/theme")"
				fi
			;;
			'KWin'*)
				if [[ -z $KDE_CONFIG_DIR ]]; then
					if type -p kde5-config >/dev/null 2>&1; then
						KDE_CONFIG_DIR=$(kde5-config --localprefix)
					elif type -p kde4-config >/dev/null 2>&1; then
						KDE_CONFIG_DIR=$(kde4-config --localprefix)
					elif type -p kde-config >/dev/null 2>&1; then
						KDE_CONFIG_DIR=$(kde-config --localprefix)
					fi
				fi
				if [[ -n $KDE_CONFIG_DIR ]]; then
					Win_theme="Not Applicable"
					KDE_CONFIG_DIR=${KDE_CONFIG_DIR%/}
					if [[ -f $KDE_CONFIG_DIR/share/config/kwinrc ]]; then
						Win_theme="$(awk '/PluginLib=kwin3_/{gsub(/PluginLib=kwin3_/,"",$0); print $0; exit}' "$KDE_CONFIG_DIR/share/config/kwinrc")"
						if [[ -z "$Win_theme" ]]; then
							Win_theme="Not Applicable"
						fi
					fi
					if [[ "$Win_theme" == "Not Applicable" ]]; then
						if [[ -f $KDE_CONFIG_DIR/share/config/kdebugrc ]]; then
							Win_theme="$(awk '/(decoration)/ {gsub(/\[/,"",$1); print $1; exit}' "$KDE_CONFIG_DIR/share/config/kdebugrc")"
							if [[ -z "$Win_theme" ]]; then
								Win_theme="Not Applicable"
							fi
						fi
					fi
					if [[ "$Win_theme" == "Not Applicable" ]]; then
						if [[ -f $KDE_CONFIG_DIR/share/config/kdeglobals ]]; then
							Win_theme="$(awk '/\[General\]/ {flag=1;next} /^$/{flag=0} flag {print}' "$KDE_CONFIG_DIR/share/config/kdeglobals" | grep -oP 'Name=\K.*')"
							if [[ -z "$Win_theme" ]]; then
								Win_theme="Not Applicable"
							fi
						fi
					fi
					if [[ "$Win_theme" != "Not Applicable" ]]; then
						if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
							if [[ ${BASH_VERSINFO[0]} -eq 4 && ${BASH_VERSINFO[1]} -gt 1 ]] || [[ ${BASH_VERSINFO[0]} -gt 4 ]]; then
								Win_theme="${Win_theme^}"
							else
								Win_theme="$(tr '[:lower:]' '[:upper:]' <<< "${Win_theme:0:1}")${Win_theme:1}"
							fi
						else
							Win_theme="$(tr '[:lower:]' '[:upper:]' <<< "${Win_theme:0:1}")${Win_theme:1}"
						fi
					fi
				fi
			;;
			'Marco'|'Metacity (Marco)')
				Win_theme="$(gsettings get org.mate.Marco.general theme)"
				Win_theme=${Win_theme//"'"}
			;;
			'Metacity')
				if [ "$(gconftool-2 -g /apps/metacity/general/theme)" ]; then
					Win_theme="$(gconftool-2 -g /apps/metacity/general/theme)"
				fi
			;;
			'OpenBox'|'Openbox')
				if [ -f "${XDG_CONFIG_HOME:-${HOME}/.config}/openbox/rc.xml" ]; then
					Win_theme="$(awk -F"[<,>]" '/<theme/ { getline; print $3 }' "${XDG_CONFIG_HOME:-${HOME}/.config}/openbox/rc.xml")";
				elif [[ -f ${XDG_CONFIG_HOME:-${HOME}/.config}/openbox/lxde-rc.xml && "${DE}" == "LXDE" ]]; then
					Win_theme="$(awk -F"[<,>]" '/<theme/ { getline; print $3 }' "${XDG_CONFIG_HOME:-${HOME}/.config}/openbox/lxde-rc.xml")";
				elif [[ -f ${XDG_CONFIG_HOME:-${HOME}/.config}/openbox/lxqt-rc.xml && "${DE}" =~ "LXQt" ]]; then
					Win_theme="$(awk -F'=' '/^theme/ {print $2}' ${HOME}/.config/lxqt/lxqt.conf)"
				fi
			;;
			'PekWM')
				if [ -f "$HOME/.pekwm/config" ]; then
					Win_theme="$(awk -F"/" '/Theme/ {gsub(/\"/,""); print $NF}' "$HOME/.pekwm/config")"
				fi
			;;
			'Sawfish')
				Win_theme="$(awk -F")" '/\(quote default-frame-style/{print $2}' "$HOME/.sawfish/custom" | sed 's/ (quote //')"
			;;
			'TWin')
				if [[ -z $TDE_CONFIG_DIR ]]; then
					if type -p tde-config >/dev/null 2>&1; then
						TDE_CONFIG_DIR=$(tde-config --localprefix)
					fi
				fi
				if [[ -n $TDE_CONFIG_DIR ]]; then
					TDE_CONFIG_DIR=${TDE_CONFIG_DIR%/}
					if [[ -f $TDE_CONFIG_DIR/share/config/kcmthememanagerrc ]]; then
						Win_theme=$(awk '/CurrentTheme=/ {gsub(/CurrentTheme=/,"",$0); print $0; exit}' "$TDE_CONFIG_DIR/share/config/kcmthememanagerrc")
					fi
					if [[ -z $Win_theme ]]; then
						Win_theme="Not Applicable"
					fi
				fi
			;;
			'Xfwm4')
				if [ -f "${XDG_CONFIG_HOME:-${HOME}/.config}/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml" ]; then
					Win_theme="$(xfconf-query -c xfwm4 -p /general/theme)"
				fi
			;;
		esac
	fi
	verboseOut "Finding window manager theme...found as '$Win_theme'"
}
# WM Theme Detection - END

# GTK Theme\Icon\Font Detection - BEGIN
detectgtk () {
	gtk2Theme="Not Found"
	gtk3Theme="Not Found"
	gtkIcons="Not Found"
	gtkFont="Not Found"
	# Font detection (OS X)
	if [[ ${distro} == "Mac OS X" || ${distro} == "macOS" ]]; then
		gtk2Theme="Not Applicable"
		gtk3Theme="Not Applicable"
		gtkIcons="Not Applicable"
		if ps -U "${USER}" | grep -q -i 'finder'; then
			if [[ ${TERM_PROGRAM} == "iTerm.app" ]] && [ -f ~/Library/Preferences/com.googlecode.iterm2.plist ]; then
				# iTerm2

				iterm2_theme_uuid=$(defaults read com.googlecode.iTerm2 "Default Bookmark Guid")

				OLD_IFS=$IFS
				IFS=$'\n'
				iterm2_theme_info=($(defaults read com.googlecode.iTerm2 "New Bookmarks" | grep -e 'Guid\s*=\s*\w+' -e 'Normal Font'))
				IFS=$OLD_IFS

				for i in $(seq 0 $((${#iterm2_theme_info[*]}/2-1))); do
					found_uuid=$(str1=${iterm2_theme_info[$i*2]};echo "${str1}")
					if [[ $found_uuid == $iterm2_theme_info ]]; then
						gtkFont=$(str2=${iterm2_theme_info[$i*2+1]};echo ${str2:25:${#str2}-25-2} | sed 's/ [0-9]*$//')
						break
					fi
				done
			else
				# Terminal.app

				termapp_theme_name=$(defaults read com.apple.Terminal "Default Window Settings")

				OLD_IFS=$IFS
				IFS=$'\n'
				termapp_theme_info=$(/usr/libexec/PlistBuddy -c \
					"print ':Window Settings:${termapp_theme_name}:Font'" \
					~/Library/Preferences/com.apple.Terminal.plist \
					| xxd -p |tr -d '\n\t\s')
				IFS=$OLD_IFS

				gtkFont=$(echo "${termapp_theme_info:288:60}" | xxd -r -p | perl -pe 'binmode(STDIN, ":bytes"); tr/A-Za-z0-9_\!\@\#\$\%\&\^\*\(\)-+=//dc;')
				gtkFont=$(echo "${gtkFont:1}" | sed 's/Z\$.*//')
			fi
		fi
	else
		case $DE in
			'KDE'*) # Desktop Environment found as "KDE"
				if type - p kde4-config >/dev/null 2>&1; then
					KDE_CONFIG_DIR=$(kde4-config --localprefix)
					if [[ -d ${KDE_CONFIG_DIR} ]]; then
						if [[ -f "${KDE_CONFIG_DIR}/share/config/kdeglobals" ]]; then
							KDE_CONFIG_FILE="${KDE_CONFIG_DIR}/share/config/kdeglobals"
						fi
					fi
				elif type -p kde5-config >/dev/null 2>&1; then
					KDE_CONFIG_DIR=$(kde5-config --localprefix)
					if [[ -d ${KDE_CONFIG_DIR} ]]; then
						if [[ -f "${KDE_CONFIG_DIR}/share/config/kdeglobals" ]]; then
							KDE_CONFIG_FILE="${KDE_CONFIG_DIR}/share/config/kdeglobals"
						fi
					fi
				elif type -p kde-config >/dev/null 2>&1; then
					KDE_CONFIG_DIR=$(kde-config --localprefix)
					if [[ -d ${KDE_CONFIG_DIR} ]]; then
						if [[ -f "${KDE_CONFIG_DIR}/share/config/kdeglobals" ]]; then
							KDE_CONFIG_FILE="${KDE_CONFIG_DIR}/share/config/kdeglobals"
						fi
					fi
				fi

				if [[ -n ${KDE_CONFIG_FILE} ]]; then
					if grep -q 'widgetStyle=' "${KDE_CONFIG_FILE}"; then
						gtk2Theme=$(awk -F"=" '/widgetStyle=/ {print $2}' "${KDE_CONFIG_FILE}")
					elif grep -q 'colorScheme=' "${KDE_CONFIG_FILE}"; then
						gtk2Theme=$(awk -F"=" '/colorScheme=/ {print $2}' "${KDE_CONFIG_FILE}")
					fi

					if grep -q 'Theme=' "${KDE_CONFIG_FILE}"; then
						gtkIcons=$(awk -F"=" '/Theme=/ {print $2}' "${KDE_CONFIG_FILE}")
					fi

					if grep -q 'Font=' "${KDE_CONFIG_FILE}"; then
						gtkFont=$(awk -F"=" '/font=/ {print $2}' "${KDE_CONFIG_FILE}")
					fi
				fi

				if [[ -f $HOME/.gtkrc-2.0 ]]; then
					gtk2Theme=$(grep '^gtk-theme-name' "$HOME"/.gtkrc-2.0 | awk -F'=' '{print $2}')
					gtk2Theme=${gtk2Theme//\"/}
					gtkIcons=$(grep '^gtk-icon-theme-name' "$HOME"/.gtkrc-2.0 | awk -F'=' '{print $2}')
					gtkIcons=${gtkIcons//\"/}
					gtkFont=$(grep 'font_name' "$HOME"/.gtkrc-2.0 | awk -F'=' '{print $2}')
					gtkFont=${gtkFont//\"/}
				fi

				if [[ -f $HOME/.config/gtk-3.0/settings.ini ]]; then
					gtk3Theme=$(grep '^gtk-theme-name=' "$HOME"/.config/gtk-3.0/settings.ini | awk -F'=' '{print $2}')
				fi
			;;
			'Cinnamon'*) # Desktop Environment found as "Cinnamon"
				if type -p gsettings >/dev/null 2>&1; then
					gtk3Theme=$(gsettings get org.cinnamon.desktop.interface gtk-theme)
					gtk3Theme=${gtk3Theme//"'"}
					gtk2Theme=${gtk3Theme}

					gtkIcons=$(gsettings get org.cinnamon.desktop.interface icon-theme)
					gtkIcons=${gtkIcons//"'"}
					gtkFont=$(gsettings get org.cinnamon.desktop.interface font-name)
					gtkFont=${gtkFont//"'"}
					if [ "$background_detect" == "1" ]; then gtkBackground=$(gsettings get org.gnome.desktop.background picture-uri); fi
				fi
			;;
			'GNOME'*|'Unity'*|'Budgie') # Desktop Environment found as "GNOME"
				if type -p gsettings >/dev/null 2>&1; then
					gtk3Theme=$(gsettings get org.gnome.desktop.interface gtk-theme)
					gtk3Theme=${gtk3Theme//"'"}
					gtk2Theme=${gtk3Theme}
					gtkIcons=$(gsettings get org.gnome.desktop.interface icon-theme)
					gtkIcons=${gtkIcons//"'"}
					gtkFont=$(gsettings get org.gnome.desktop.interface font-name)
					gtkFont=${gtkFont//"'"}
					if [ "$background_detect" == "1" ]; then gtkBackground=$(gsettings get org.gnome.desktop.background picture-uri); fi
				elif type -p gconftool-2 >/dev/null 2>&1; then
					gtk2Theme=$(gconftool-2 -g /desktop/gnome/interface/gtk_theme)
					gtkIcons=$(gconftool-2 -g /desktop/gnome/interface/icon_theme)
					gtkFont=$(gconftool-2 -g /desktop/gnome/interface/font_name)
					if [ "$background_detect" == "1" ]; then
						gtkBackgroundFull=$(gconftool-2 -g /desktop/gnome/background/picture_filename)
						gtkBackground=$(echo "$gtkBackgroundFull" | awk -F"/" '{print $NF}')
					fi
				fi
			;;
			'MATE'*) # MATE desktop environment
				if type -p gsettings >/dev/null 2>&1; then
					gtk3Theme=$(gsettings get org.mate.interface gtk-theme)
					gtk3Theme=${gtk3Theme//"'"}
					gtk2Theme=${gtk3Theme}
					gtkIcons=$(gsettings get org.mate.interface icon-theme)
					gtkIcons=${gtkIcons//"'"}
					gtkFont=$(gsettings get org.mate.interface font-name)
					gtkFont=${gtkFont//"'"}
				fi
			;;
			'Xfce'*) # Desktop Environment found as "Xfce"
				if [ "$distro" == "BunsenLabs" ] ; then
					gtk2Theme=$(awk -F'"' '/^gtk-theme/ {print $2}' "$HOME"/.gtkrc-2.0)
					gtk3Theme=$(awk -F'=' '/^gtk-theme-name/ {print $2}' "$HOME"/.config/gtk-3.0/settings.ini)
					gtkIcons=$(awk -F'"' '/^gtk-icon-theme/ {print $2}' "$HOME"/.gtkrc-2.0)
					gtkFont=$(awk -F'"' '/^gtk-font-name/ {print $2}' "$HOME"/.gtkrc-2.0)
				else
					if type -p xfconf-query >/dev/null 2>&1; then
						gtk2Theme=$(xfconf-query -c xsettings -p /Net/ThemeName 2>/dev/null)
						[ -z "$gtk2Theme" ] && gtk2Theme="Not Found"
					fi

					if type -p xfconf-query >/dev/null 2>&1; then
						gtkIcons=$(xfconf-query -c xsettings -p /Net/IconThemeName 2>/dev/null)
						[ -z "$gtkIcons" ] && gtkIcons="Not Found"
					fi

					if type -p xfconf-query >/dev/null 2>&1; then
						gtkFont=$(xfconf-query -c xsettings -p /Gtk/FontName 2>/dev/null)
						[ -z "$gtkFont" ] && gtkFont="Not Identified"
					fi
				fi
			;;
			'LXDE'*)
				config_home="${XDG_CONFIG_HOME:-${HOME}/.config}"
				if [ -f "$config_home/lxde/config" ]; then
					lxdeconf="/lxde/config"
				elif [ "$distro" == "Trisquel" ] || [ "$distro" == "FreeBSD" ]; then
					lxdeconf=""
				elif [ -f "$config_home/lxsession/Lubuntu/desktop.conf" ]; then
					lxdeconf="/lxsession/Lubuntu/desktop.conf"
				else
					lxdeconf="/lxsession/LXDE/desktop.conf"
				fi

				if grep -q 'sNet\/ThemeName' "${config_home}${lxdeconf}" 2>/dev/null; then
					gtk2Theme=$(awk -F'=' '/sNet\/ThemeName/ {print $2}' "${config_home}${lxdeconf}")
				fi

				if grep -q 'IconThemeName' "${config_home}${lxdeconf}" 2>/dev/null; then
					gtkIcons=$(awk -F'=' '/sNet\/IconThemeName/ {print $2}' "${config_home}${lxdeconf}")
				fi

				if grep -q 'FontName' "${config_home}${lxdeconf}" 2>/dev/null; then
					gtkFont=$(awk -F'=' '/sGtk\/FontName/ {print $2}' "${config_home}${lxdeconf}")
 				fi
			;;

			# /home/me/.config/rox.sourceforge.net/ROX-Session/Settings.xml

			*)	# Lightweight or No DE Found
				if [ -f "$HOME/.gtkrc-2.0" ]; then
					if grep -q 'gtk-theme' "$HOME/.gtkrc-2.0"; then
						gtk2Theme=$(awk -F'"' '/^gtk-theme/ {print $2}' "$HOME/.gtkrc-2.0")
					fi

					if grep -q 'icon-theme' "$HOME/.gtkrc-2.0"; then
						gtkIcons=$(awk -F'"' '/^gtk-icon-theme/ {print $2}' "$HOME/.gtkrc-2.0")
					fi

					if grep -q 'font' "$HOME/.gtkrc-2.0"; then
						gtkFont=$(awk -F'"' '/^gtk-font-name/ {print $2}' "$HOME/.gtkrc-2.0")
					fi
				fi
				# $HOME/.gtkrc.mine theme detect only
				if [[ -f "$HOME/.gtkrc.mine" ]]; then
					minegtkrc="$HOME/.gtkrc.mine"
				elif [[ -f "$HOME/.gtkrc-2.0.mine" ]]; then
					minegtkrc="$HOME/.gtkrc-2.0.mine"
				fi
				if [ -f "$minegtkrc" ]; then
					if grep -q '^include' "$minegtkrc"; then
						gtk2Theme=$(grep '^include.*gtkrc' "$minegtkrc" | awk -F "/" '{ print $5 }')
					fi
					if grep -q '^gtk-icon-theme-name' "$minegtkrc"; then
						gtkIcons=$(grep '^gtk-icon-theme-name' "$minegtkrc" | awk -F '"' '{print $2}')
					fi
				fi
				# /etc/gtk-2.0/gtkrc compatibility
				if [[ -f /etc/gtk-2.0/gtkrc && ! -f "$HOME/.gtkrc-2.0" && ! -f "$HOME/.gtkrc.mine" && ! -f "$HOME/.gtkrc-2.0.mine" ]]; then
					if grep -q 'gtk-theme-name' /etc/gtk-2.0/gtkrc; then
						gtk2Theme=$(awk -F'"' '/^gtk-theme-name/ {print $2}' /etc/gtk-2.0/gtkrc)
					fi
					if grep -q 'gtk-fallback-theme-name' /etc/gtk-2.0/gtkrc  && ! [ "x$gtk2Theme" = "x" ]; then
						gtk2Theme=$(awk -F'"' '/^gtk-fallback-theme-name/ {print $2}' /etc/gtk-2.0/gtkrc)
					fi

					if grep -q 'icon-theme' /etc/gtk-2.0/gtkrc; then
						gtkIcons=$(awk -F'"' '/^icon-theme/ {print $2}' /etc/gtk-2.0/gtkrc)
					fi
					if  grep -q 'gtk-fallback-icon-theme' /etc/gtk-2.0/gtkrc  && ! [ "x$gtkIcons" = "x" ]; then
						gtkIcons=$(awk -F'"' '/^gtk-fallback-icon-theme/ {print $2}' /etc/gtk-2.0/gtkrc)
					fi

					if grep -q 'font' /etc/gtk-2.0/gtkrc; then
						gtkFont=$(awk -F'"' '/^gtk-font-name/ {print $2}' /etc/gtk-2.0/gtkrc)
					fi
				fi

				# EXPERIMENTAL gtk3 Theme detection
				if [[ "$gtk3Theme" = "Not Found" && -f "$HOME/.config/gtk-3.0/settings.ini" ]]; then
					if grep -q 'gtk-theme-name' "$HOME/.config/gtk-3.0/settings.ini"; then
						gtk3Theme=$(awk -F'=' '/^gtk-theme-name/ {print $2}' "$HOME/.config/gtk-3.0/settings.ini")
					fi
				fi

				# Proper gtk3 Theme detection
				if type -p gsettings >/dev/null 2>&1; then
					if [[ -z "$gtk3Theme"  || "$gtk3Theme" = "Not Found" ]]; then
						gtk3Theme=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null)
						gtk3Theme=${gtk3Theme//"'"}
					fi
				fi

				# ROX-Filer icon detect only
				if [ -a "${XDG_CONFIG_HOME:-${HOME}/.config}/rox.sourceforge.net/ROX-Filer/Options" ]; then
					gtkIcons=$(awk -F'[>,<]' '/icon_theme/ {print $3}' "${XDG_CONFIG_HOME:-${HOME}/.config}/rox.sourceforge.net/ROX-Filer/Options")
				fi

				# E17 detection
				if [ "$E_ICON_THEME" ]; then
					gtkIcons=${E_ICON_THEME}
					gtk2Theme="Not available."
					gtkFont="Not available."
				fi

				# Background Detection (feh, nitrogen)
				if [ "$background_detect" == "1" ]; then
					if [ -a "$HOME/.fehbg" ]; then
						gtkBackgroundFull=$(awk -F"'" '/feh --bg/{print $2}' "$HOME/.fehbg" 2>/dev/null)
						gtkBackground=$(echo "$gtkBackgroundFull" | awk -F"/" '{print $NF}')
					elif [ -a "${XDG_CONFIG_HOME:-${HOME}/.config}/nitrogen/bg-saved.cfg" ]; then
						gtkBackground=$(awk -F"/" '/file=/ {print $NF}' "${XDG_CONFIG_HOME:-${HOME}/.config}/nitrogen/bg-saved.cfg")
					fi
				fi

				if [[ "$distro" == "Cygwin" || "$distro" == "Msys" ]]; then
					if [ "$gtkFont" == "Not Found" ]; then
						if [ -f "$HOME/.minttyrc" ]; then
							gtkFont="$(grep '^Font=.*' "$HOME/.minttyrc" | grep -o '[0-9A-z ]*$')"
						fi
					fi
				fi
			;;
		esac
	fi
	verboseOut "Finding GTK2 theme...found as '$gtk2Theme'"
	verboseOut "Finding GTK3 theme...found as '$gtk3Theme'"
	verboseOut "Finding icon theme...found as '$gtkIcons'"
	verboseOut "Finding user font...found as '$gtkFont'"
	if [[ -n "$gtkBackground" ]]; then
		verboseOut "Finding background...found as '$gtkBackground'"
	fi
}
# GTK Theme\Icon\Font Detection - END

# Android-specific detections
detectdroid () {
	distro_ver=$(getprop ro.build.version.release)
	hostname=$(getprop net.hostname)
	device="$(getprop ro.product.model) ($(getprop ro.product.device))"
	if [[ $(getprop ro.build.host) == "cyanogenmod" ]]; then
		rom=$(getprop ro.cm.version)
	else
		rom=$(getprop ro.build.display.id)
	fi
	baseband=$(getprop ro.baseband)
	cpu=$(awk -F': ' '/^Processor/ {P=$2} /^Hardware/ {H=$2} END {print H != "" ? H : P}' /proc/cpuinfo)
}


#######################
# End Detection Phase
#######################

takeShot () {
	if [[ -n "$screenCommand" ]]; then
		$screenCommand
	else
		shotfiles[1]=${shotfile}
		if [ "$distro" == "Mac OS X" || "$distro" == "macOS" ]; then
			displays="$(system_profiler SPDisplaysDataType | grep -c 'Resolution:' | tr -d ' ')"
			for (( i=2; i<=displays; i++))
			do
				shotfiles[$i]="$(echo ${shotfile} | sed "s/\(.*\)\./\1_${i}./")"
			done
			printf "Taking shot in 3.. "; sleep 1
			printf "2.. "; sleep 1
			printf "1.. "; sleep 1
			printf "0.\n"
			screencapture -x ${shotfiles[@]} &> /dev/null
		else
			if type -p scrot >/dev/null 2>&1; then
				scrot -cd3 "${shotfile}"
			else
				errorOut "Cannot take screenshot! \`scrot' not in \$PATH"
			fi
		fi
		if [ -f "${shotfile}" ]; then
			verboseOut "Screenshot saved at '${shotfiles[*]}'"
			if [[ "${upload}" == "1" ]]; then
				if type -p curl >/dev/null 2>&1; then
					printf "${bold}==>${c0}  Uploading your screenshot now..."
					case "${uploadLoc}" in
						'teknik')
							baseurl='https://u.teknik.io'
							uploadurl='https://api.teknik.io/upload/post'
							ret=$(curl -sf -F file="@${shotfiles[*]}" ${uploadurl})
							desturl="${ret##*url\":\"}"
							desturl="${desturl%%\"*}"
							desturl="${desturl//\\}"
						;;
						'mediacrush')
							baseurl='https://mediacru.sh'
							uploadurl='https://mediacru.sh/api/upload/file'
							ret=$(curl -sf -F file="@${shotfiles[*]};type=image/png" ${uploadurl})
							filehash=$(echo "${ret}" | grep 'hash' | cut -d '"' -f4)
							desturl="${baseurl}/${filehash}"
						;;
						'imgur')
							baseurl='http://imgur.com'
							uploadurl='http://imgur.com/upload'
							ret=$(curl -sf -F file="@${shotfiles[*]}" ${uploadurl})
							filehash="${ret##*hash\":\"}"
							filehash="${filehash%%\"*}"
							desturl="${baseurl}/${filehash}"
						;;
						'hmp')
							baseurl='http://i.hmp.me/m'
							uploadurl='http://hmp.me/ap/?uf=1'
							ret=$(curl -sf -F a="@${shotfiles[*]};type=image/png" ${uploadurl})
							desturl="${ret##*img_path\":\"}"
							desturl="${desturl%%\"*}"
							desturl="${desturl//\\}"
						;;
						'local-example')
							baseurl="http://www.example.com"
							serveraddr="www.example.com"
							scptimeout="20"
							serverdir="/path/to/directory"
							scp -qo ConnectTimeout="${scptimeout}" "${shotfiles[*]}" "${serveraddr}:${serverdir}"
							desturl="${baseurl}/${shotfile}"
						;;
					esac
					printf "your screenshot can be viewed at ${desturl}\n"
				else
					errorOut "Cannot upload screenshot! \`curl' not in \$PATH"
				fi
			fi
		else
			if type -p scrot >/dev/null 2>&1; then
				errorOut "ERROR: Problem saving screenshot to ${shotfiles[*]}"
			fi
		fi
	fi
}


asciiText () {
# Distro logos and ASCII outputs
	if [[ "$asc_distro" ]]; then
		myascii="${asc_distro}"
	elif [[ "$art" ]]; then
		myascii="custom"
	elif [[ "$fake_distro" ]]; then
		myascii="${fake_distro}"
	else
		myascii="${distro}"
	fi
	case ${myascii} in
		"custom")
			source "$art"
		;;

		"ALDOS")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light grey') # light grey
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="27"
			fulloutput=(
"${c1}                           %s"
"${c1}           # ## #          %s"
"${c1}        # ######## #       %s"
"${c1}      # ### ######## #     %s"
"${c1}     # #### ######### #    %s"
"${c1}   # #### # # # # #### #   %s"
"${c1}  # ##### #       ##### #  %s"
"${c1}   # ###### ##### #### #   %s"
"${c1}    # ############### #    %s"
"${c1}                           %s"
"${c2}        _ ___   ___  ___   %s"
"${c2}   __ _| |   \ / _ \/ __|  %s"
"${c2}  / _' | | |) | (_) \__ \  %s"
"${c2}  \__,_|_|___/ \___/|___/  %s"
"${c1}                           %s"
"${c1}                           %s")
		;;

		"Alpine Linux")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light blue') # Light
				c2=$(getColor 'blue') # Dark
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="34"
			fulloutput=(
"${c1}        ................          %s"
"${c1}       ∴::::::::::::::::∴         %s"
"${c1}      ∴::::::::::::::::::∴        %s"
"${c1}     ∴::::::::::::::::::::∴       %s"
"${c1}    ∴:::::::. :::::':::::::∴      %s"
"${c1}   ∴:::::::.   ;::; ::::::::∴     %s"
"${c1}  ∴::::::;      ∵     :::::::∴    %s"
"${c1} ∴:::::.     .         .::::::∴   %s"
"${c1} ::::::     :::.    .    ::::::   %s"
"${c1} ∵::::     ::::::.  ::.   ::::∵   %s"
"${c1}  ∵:..   .:;::::::: :::.  :::∵    %s"
"${c1}   ∵::::::::::::::::::::::::∵     %s"
"${c1}    ∵::::::::::::::::::::::∵      %s"
"${c1}     ∵::::::::::::::::::::∵       %s"
"${c1}      ::::::::::::::::::::        %s"
"${c1}       ∵::::::::::::::::∵         %s")
		;;

		"Arch Linux - Old")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'white') # White
				c2=$(getColor 'light blue') # Light Blue
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="37"
			fulloutput=(
"${c1}              __                     %s"
"${c1}          _=(SDGJT=_                 %s"
"${c1}        _GTDJHGGFCVS)                %s"
"${c1}       ,GTDJGGDTDFBGX0               %s"
"${c1}      JDJDIJHRORVFSBSVL${c2}-=+=,_        %s"
"${c1}     IJFDUFHJNXIXCDXDSV,${c2}  \"DEBL      %s"
"${c1}    [LKDSDJTDU=OUSCSBFLD.${c2}   '?ZWX,   %s"
"${c1}   ,LMDSDSWH'     \`DCBOSI${c2}     DRDS], %s"
"${c1}   SDDFDFH'         !YEWD,${c2}   )HDROD  %s"
"${c1}  !KMDOCG            &GSU|${c2}\_GFHRGO\'  %s"
"${c1}  HKLSGP'${c2}           __${c1}\TKM0${c2}\GHRBV)'  %s"
"${c1} JSNRVW'${c2}       __+MNAEC${c1}\IOI,${c2}\BN'     %s"
"${c1} HELK['${c2}    __,=OFFXCBGHC${c1}\FD)         %s"
"${c1} ?KGHE ${c2}\_-#DASDFLSV='${c1}    'EF         %s"
"${c1} 'EHTI                    !H         %s"
"${c1}  \`0F'                    '!         %s"
"${c1}                                     %s"
"${c1}                                     %s")
		;;

		"Arch Linux")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light cyan') # Light
				c2=$(getColor 'cyan') # Dark
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="1"
			logowidth="38"
			fulloutput=(
"${c1}                   -\`                 "
"${c1}                  .o+\`                %s"
"${c1}                 \`ooo/                %s"
"${c1}                \`+oooo:               %s"
"${c1}               \`+oooooo:              %s"
"${c1}               -+oooooo+:             %s"
"${c1}             \`/:-:++oooo+:            %s"
"${c1}            \`/++++/+++++++:           %s"
"${c1}           \`/++++++++++++++:          %s"
"${c1}          \`/+++o${c2}oooooooo${c1}oooo/\`        %s"
"${c2}         ${c1}./${c2}ooosssso++osssssso${c1}+\`       %s"
"${c2}        .oossssso-\`\`\`\`/ossssss+\`      %s"
"${c2}       -osssssso.      :ssssssso.     %s"
"${c2}      :osssssss/        osssso+++.    %s"
"${c2}     /ossssssss/        +ssssooo/-    %s"
"${c2}   \`/ossssso+/:-        -:/+osssso+-  %s"
"${c2}  \`+sso+:-\`                 \`.-/+oso: %s"
"${c2} \`++:.                           \`-/+/%s"
"${c2} .\`                                 \`/%s")
		;;

		"Artix Linux")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'cyan')
				c2=$(getColor 'blue')
				c3=$(getColor 'green')
				c4=$(getColor 'dark gray')
			fi
			if [ -n "${my_lcolor}" ]; then
				c1="${my_lcolor}"
				c2="${my_lcolor}"
				c3="${my_lcolor}"
				c4="${my_lcolor}"
			fi
			startline="1"
			logowidth="38"
			fulloutput=(""
"${c1}                        d${c2}c.           %s"
"${c1}                       x${c2}dc.           %s"
"${c1}                  '.${c4}.${c1} d${c2}dlc.           %s"
"${c1}                 c${c2}0d:${c1}o${c2}xllc;           %s"
"${c1}                :${c2}0ddlolc,lc,          %s"
"${c1}           :${c1}ko${c4}.${c1}:${c2}0ddollc..dlc.         %s"
"${c1}          ;${c1}K${c2}kxoOddollc'  cllc.        %s"
"${c1}         ,${c1}K${c2}kkkxdddllc,   ${c4}.${c2}lll:        %s"
"${c1}        ,${c1}X${c2}kkkddddlll;${c3}...';${c1}d${c2}llll${c3}dxk:   %s"
"${c1}       ,${c1}X${c2}kkkddddllll${c3}oxxxddo${c2}lll${c3}oooo,   %s"
"${c3}    xxk${c1}0${c2}kkkdddd${c1}o${c2}lll${c1}o${c3}ooooooolooooc;${c1}.   %s"
"${c3}    ddd${c2}kkk${c1}d${c2}ddd${c1}ol${c2}lc:${c3}:;,'.${c3}... .${c2}lll;     %s"
"${c1}   .${c3}xd${c1}x${c2}kk${c1}xd${c2}dl${c1}'cl:${c4}.           ${c2}.llc,    %s"
"${c1}   .${c1}0${c2}kkkxddl${c4}. ${c2};'${c4}.             ${c2};llc.   %s"
"${c1}  .${c1}K${c2}Okdcddl${c4}.                   ${c2}cllc${c4}.  %s"
"${c1}  0${c2}Okd''dc.                    .cll;  %s"
"${c1} k${c2}Okd'                          .llc, %s"
"${c1} d${c2}Od,                            'lc. %s"
"${c1} :,${c4}.                              ${c2}... %s"
"                                                   %s")
		;;

		"blackPanther OS")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'yellow') # Light Yellow
				c2=$(getColor 'white') # Bold Red
				c3=$(getColor 'light red') # Light Red
				c4=$(getColor 'dark grey')
			fi
			if [ -n "${my_lcolor}" ]; then
				c1="${my_lcolor}"
				c2="${my_lcolor}"
				c3="${my_lcolor}"
				c4="${my_lcolor}"
			fi
			startline="0"
			logowidth="38"
			fulloutput=(
"${c4}                oxoo              %s"
"${c4}           ooooooxxxxxxxx         %s"
"${c4}      oooooxxxxxxxxxx${c3}O${c1}o.${c4}xx        %s"
"${c4}    oo# ###xxxxxxxxxxx###xxx      %s"
"${c4}  oo .oooooxxxxxxxxx##   #oxx     %s"
"${c4} o  ##xxxxxxxxx###x##   .o###     %s"
"${c4}  .oxxxxxxxx###   ox  .           %s"
"${c4} ooxxxx#xxxxxx     o##            %s"
"${c4}.oxx# #oxxxxx#                    %s"
"${c4}ox#  ooxxxxxx#                  o %s"
"${c4}x#  ooxxxxxxxx           ox     ox%s"
"${c4}x# .oxxxxxxxxxxx        o#     oox%s"
"${c4}#  oxxxxx##xxxxxxooooooo#      o# %s"
"${c4}  .oxxxxxooxxxxxx######       ox# %s"
"${c4}  oxxxxxo oxxxxxxxx         oox## %s"
"${c4}  oxxxxxx  oxxxxxxxxxo   oooox##  %s"
"${c4}   o#xxxxx  oxxxxxxxxxxxxxxxx##   %s"
"${c4}    ##xxxxx  o#xxxxxxxxxxxxx##    %s"
"${c4}      ##xxxx   o#xxxxxxxxx##      %s"
"${c4}         ###xo.  o##xxx###        %s"
"${c4}                                  %s")
			;;

		"ArcoLinux")
			if [[ "$no_color" != "0" ]]; then
				c1=$(getColor 'arco_blue') # dark
				c2=$(getColor 'white') # light
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="1"
			logowidth="41"
			fulloutput=(

"${c1}                    /-                   "
"${c1}                   ooo:                  %s"     
"${c1}                  yoooo/                 %s"
"${c1}                 yooooooo                %s"
"${c1}                yooooooooo               %s" 
"${c1}               yooooooooooo              %s"
"${c1}             .yooooooooooooo             %s"
"${c1}            .oooooooooooooooo            %s"
"${c1}           .oooooooarcoooooooo           %s"
"${c1}          .ooooooooo-oooooooooo          %s"   
"${c1}         .ooooooooo-  oooooooooo         %s"
"${c1}        :ooooooooo.    :ooooooooo        %s"
"${c1}       :ooooooooo.      :ooooooooo       %s"
"${c1}      :oooarcooo         .oooarcooo      %s"  
"${c1}     :ooooooooy           .ooooooooo     %s" 
"${c1}    :ooooooooo   ${c2}/ooooooooooooooooooo${c1}    %s"
"${c1}   :ooooooooo      ${c2}.-ooooooooooooooooo.${c1}  %s"   
"${c1}  ooooooooo-             ${c2}-ooooooooooooo.${c1} %s"    
"${c1} ooooooooo-                 ${c2}.-oooooooooo.${c1}%s"   
"${c1}ooooooooo.                     ${c2}-ooooooooo${c1}%s")
		;;
		
		"Mint")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'white') # White
				c2=$(getColor 'light green') # Bold Green
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="38"
			fulloutput=(
"${c2}                                      %s"
"${c2} MMMMMMMMMMMMMMMMMMMMMMMMMmds+.       %s"
"${c2} MMm----::-://////////////oymNMd+\`    %s"
"${c2} MMd      ${c1}/++                ${c2}-sNMd:   %s"
"${c2} MMNso/\`  ${c1}dMM    \`.::-. .-::.\` ${c2}.hMN:  %s"
"${c2} ddddMMh  ${c1}dMM   :hNMNMNhNMNMNh: ${c2}\`NMm  %s"
"${c2}     NMm  ${c1}dMM  .NMN/-+MMM+-/NMN\` ${c2}dMM  %s"
"${c2}     NMm  ${c1}dMM  -MMm  \`MMM   dMM. ${c2}dMM  %s"
"${c2}     NMm  ${c1}dMM  -MMm  \`MMM   dMM. ${c2}dMM  %s"
"${c2}     NMm  ${c1}dMM  .mmd  \`mmm   yMM. ${c2}dMM  %s"
"${c2}     NMm  ${c1}dMM\`  ..\`   ...   ydm. ${c2}dMM  %s"
"${c2}     hMM- ${c1}+MMd/-------...-:sdds  ${c2}dMM  %s"
"${c2}     -NMm- ${c1}:hNMNNNmdddddddddy/\`  ${c2}dMM  %s"
"${c2}      -dMNs-${c1}\`\`-::::-------.\`\`    ${c2}dMM  %s"
"${c2}       \`/dMNmy+/:-------------:/yMMM  %s"
"${c2}          ./ydNMMMMMMMMMMMMMMMMMMMMM  %s"
"${c2}             \.MMMMMMMMMMMMMMMMMMM    %s"
"${c2}                                      %s")
		;;

		"LMDE")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'white') # White
				c2=$(getColor 'light green') # Bold Green
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="31"
			fulloutput=(
"${c1}          \`.-::---..           %s"
"${c2}       .:++++ooooosssoo:.      %s"
"${c2}     .+o++::.      \`.:oos+.    %s"
"${c2}    :oo:.\`             -+oo${c1}:   %s"
"${c2}  ${c1}\`${c2}+o/\`    .${c1}::::::${c2}-.    .++-${c1}\`  %s"
"${c2} ${c1}\`${c2}/s/    .yyyyyyyyyyo:   +o-${c1}\`  %s"
"${c2} ${c1}\`${c2}so     .ss       ohyo\` :s-${c1}:  %s"
"${c2} ${c1}\`${c2}s/     .ss  h  m  myy/ /s\`${c1}\`  %s"
"${c2} \`s:     \`oo  s  m  Myy+-o:\`   %s"
"${c2} \`oo      :+sdoohyoydyso/.     %s"
"${c2}  :o.      .:////////++:       %s"
"${c2}  \`/++        ${c1}-:::::-          %s"
"${c2}   ${c1}\`${c2}++-                        %s"
"${c2}    ${c1}\`${c2}/+-                       %s"
"${c2}      ${c1}.${c2}+/.                     %s"
"${c2}        ${c1}.${c2}:+-.                  %s"
"${c2}           \`--.\`\`              %s"
"${c2}                               %s")
		;;

		"Ubuntu")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'white') # White
				c2=$(getColor 'light red') # Light Red
				c3=$(getColor 'yellow') # Bold Yellow
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; c3="${my_lcolor}"; fi
			startline="0"
			logowidth="38"
			fulloutput=(
"${c2}                          ./+o+-      %s"
"${c1}                  yyyyy- ${c2}-yyyyyy+     %s"
"${c1}               ${c1}://+//////${c2}-yyyyyyo     %s"
"${c3}           .++ ${c1}.:/++++++/-${c2}.+sss/\`     %s"
"${c3}         .:++o:  ${c1}/++++++++/:--:/-     %s"
"${c3}        o:+o+:++.${c1}\`..\`\`\`.-/oo+++++/    %s"
"${c3}       .:+o:+o/.${c1}          \`+sssoo+/   %s"
"${c1}  .++/+:${c3}+oo+o:\`${c1}             /sssooo.  %s"
"${c1} /+++//+:${c3}\`oo+o${c1}               /::--:.  %s"
"${c1} \+/+o+++${c3}\`o++o${c2}               ++////.  %s"
"${c1}  .++.o+${c3}++oo+:\`${c2}             /dddhhh.  %s"
"${c3}       .+.o+oo:.${c2}          \`oddhhhh+   %s"
"${c3}        \+.++o+o\`${c2}\`-\`\`\`\`.:ohdhhhhh+    %s"
"${c3}         \`:o+++ ${c2}\`ohhhhhhhhyo++os:     %s"
"${c3}           .o:${c2}\`.syhhhhhhh/${c3}.oo++o\`     %s"
"${c2}               /osyyyyyyo${c3}++ooo+++/    %s"
"${c2}                   \`\`\`\`\` ${c3}+oo+++o\:    %s"
"${c3}                          \`oo++.      %s")
		;;

		"KDE neon")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light green') # Bold Green
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			logowidth="43"
			fulloutput=(
"${c1}              \`..---+/---..\`               %s"
"${c1}          \`---.\`\`   \`\`   \`.---.\`           %s"
"${c1}       .--.\`        \`\`        \`-:-.        %s"
"${c1}     \`:/:     \`.----//----.\`     :/-       %s"
"${c1}    .:.    \`---\`          \`--.\`    .:\`     %s"
"${c1}   .:\`   \`--\`                .:-    \`:.    %s"
"${c1}  \`/    \`:.      \`.-::-.\`      -:\`   \`/\`   %s"
"${c1}  /.    /.     \`:++++++++:\`     .:    .:   %s"
"${c1} \`/    .:     \`+++++++++++/      /\`   \`+\`  %s"
"${c1} /+\`   --     .++++++++++++\`     :.   .+:  %s"
"${c1} \`/    .:     \`+++++++++++/      /\`   \`+\`  %s"
"${c1}  /\`    /.     \`:++++++++:\`     .:    .:   %s"
"${c1}  ./    \`:.      \`.:::-.\`      -:\`   \`/\`   %s"
"${c1}   .:\`   \`--\`                .:-    \`:.    %s"
"${c1}    .:.    \`---\`          \`--.\`    .:\`     %s"
"${c1}     \`:/:     \`.----//----.\`     :/-       %s"
"${c1}       .-:.\`        \`\`        \`-:-.        %s"
"${c1}          \`---.\`\`   \`\`   \`.---.\`           %s"
"${c1}              \`..---+/---..\`               %s")
		;;

		"Debian")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'white') # White
				c2=$(getColor 'light red') # Light Red
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="32"
			fulloutput=(
"${c1}         _,met\$\$\$\$\$gg.          %s"
"${c1}      ,g\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$P.       %s"
"${c1}    ,g\$\$P\"\"       \"\"\"Y\$\$.\".     %s"
"${c1}   ,\$\$P'              \`\$\$\$.     %s"
"${c1}  ',\$\$P       ,ggs.     \`\$\$b:   %s"
"${c1}  \`d\$\$'     ,\$P\"\'   ${c2}.${c1}    \$\$\$    %s"
"${c1}   \$\$P      d\$\'     ${c2},${c1}    \$\$P    %s"
"${c1}   \$\$:      \$\$.   ${c2}-${c1}    ,d\$\$'    %s"
"${c1}   \$\$\;      Y\$b._   _,d\$P'     %s"
"${c1}   Y\$\$.    ${c2}\`.${c1}\`\"Y\$\$\$\$P\"'         %s"
"${c1}   \`\$\$b      ${c2}\"-.__              %s"
"${c1}    \`Y\$\$                        %s"
"${c1}     \`Y\$\$.                      %s"
"${c1}       \`\$\$b.                    %s"
"${c1}         \`Y\$\$b.                 %s"
"${c1}            \`\"Y\$b._             %s"
"${c1}                \`\"\"\"\"           %s"
"${c1}                                %s")
		;;

		"Proxmox VE")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'white')
				c2=$(getColor 'orange')
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="48"
			fulloutput=(
"${c1}           .://:\`              \`://:.           %s"
"${c1}         \`hMMMMMMd/          /dMMMMMMh\`         %s"
"${c1}          \`sMMMMMMMd:      :mMMMMMMMs\`          %s"
"${c2}  \`-/+oo+/:${c1}\`.yMMMMMMMh-  -hMMMMMMMy.\`${c2}:/+oo+/-\`  %s"
"${c2}  \`:oooooooo/${c1}\`-hMMMMMMMyyMMMMMMMh-\`${c2}/oooooooo:\`  %s"
"${c2}    \`/oooooooo:${c1}\`:mMMMMMMMMMMMMm:\`${c2}:oooooooo/\`    %s"
"${c2}      ./ooooooo+-${c1} +NMMMMMMMMN+ ${c2}-+ooooooo/.      %s"
"${c2}        .+ooooooo+-${c1}\`oNMMMMNo\`${c2}-+ooooooo+.        %s"
"${c2}          -+ooooooo/.${c1}\`sMMs\`${c2}./ooooooo+-          %s"
"${c2}            :oooooooo/${c1}\`..\`${c2}/oooooooo:            %s"
"${c2}            :oooooooo/\`${c1}..${c2}\`/oooooooo:            %s"
"${c2}          -+ooooooo/.${c1}\`sMMs${c2}\`./ooooooo+-          %s"
"${c2}        .+ooooooo+-\`${c1}oNMMMMNo${c2}\`-+ooooooo+.        %s"
"${c2}      ./ooooooo+-${c1} +NMMMMMMMMN+ ${c2}-+ooooooo/.      %s"
"${c2}    \`/oooooooo:\`${c1}:mMMMMMMMMMMMMm:${c2}\`:oooooooo/\`    %s"
"${c2}  \`:oooooooo/\`${c1}-hMMMMMMMyyMMMMMMMh-${c2}\`/oooooooo:\`  %s"
"${c2}  \`-/+oo+/:\`${c1}.yMMMMMMMh-  -hMMMMMMMy.${c2}\`:/+oo+/-\`  %s"
"${c1}          \`sMMMMMMMm:      :dMMMMMMMs          %s"
"${c1}         \`hMMMMMMd/          /dMMMMMMh         %s"
"${c1}           \`://:\`              \`://:\`           %s")
		;;

		"Siduction")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light blue') # Light Blue
				c2=$(getColor 'light blue') # Light Blue
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="35"
			fulloutput=(
"${c1}               _ass,,                %s"
"${c1}              jmk  dm.               %s"
"${c1}              3##qwm#\`               %s"
"${c1}          .    \"9XZ?\` _aas,          %s"
"${c1}        ap!!n,      _dW(--\$a         %s"
"${c1}       )#hc_m#      ]mmwaam#\`        %s"
"${c1}        ?##WZ^      -4#####! _as,.   %s"
"${c1}  _ais,   -   _au11a. -\"\"\" <m#\"\"\"Wc  %s"
"${c1} )m6_]m,      m#c__m6     :m#m,_<m#> %s"
"${c1} -Y#m#!       4###m#r     -\$##mBm#Z\` %s"
"${c1}    -    _as,. \"???~ _aawa,.!S##Z?\`  %s"
"${c1}        ym= 3h.     <##' -Wo         %s"
"${c1}        \$#mm#D\`     ]B#qww##         %s"
"${c1}         \"?!\"\`  _s,.-?#m##T'         %s"
"${c1}              _dZ\"\"4a  --            %s"
"${c1}              3Wmaam#;               %s"
"${c1}              -9###Z!                %s")

		;;

		"Devuan")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light purple') # Light purple
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			logowidth="36"
			fulloutput=(
"${c1}                                    %s"
"${c1}     ..,,;;;::;,..                  %s"
"${c1}             \`':ddd;:,.             %s"
"${c1}                   \`'dPPd:,.        %s"
"${c1}                       \`:b\$\$b\`.     %s"
"${c1}                          'P\$\$\$d\`   %s"
"${c1}                           .\$\$\$\$\$\`  %s"
"${c1}                           ;\$\$\$\$\$P  %s"
"${c1}                        .:P\$\$\$\$\$\$\`  %s"
"${c1}                    .,:b\$\$\$\$\$\$\$;'   %s"
"${c1}               .,:dP\$\$\$\$\$\$\$\$b:'     %s"
"${c1}        .,:;db\$\$\$\$\$\$\$\$\$\$Pd'\`        %s"
"${c1}   ,db\$\$\$\$\$\$\$\$\$\$\$\$\$\$b:'\`            %s"
"${c1}  :\$\$\$\$\$\$\$\$\$\$\$\$b:'\`                 %s"
"${c1}   \`\$\$\$\$\$bd:''\`                     %s"
"${c1}     \`'''\`                          %s"
"${c1}                                    %s")
		;;

		"Raspbian")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light green') # Light Green
				c2=$(getColor 'light red') # Light Red
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="32"
			fulloutput=(
"${c1}    .',;:cc;,'.    .,;::c:,,.   %s"
"${c1}   ,ooolcloooo:  'oooooccloo:   %s"
"${c1}   .looooc;;:ol  :oc;;:ooooo'   %s"
"${c1}     ;oooooo:      ,ooooooc.    %s"
"${c1}       .,:;'.       .;:;'.      %s"
"${c2}       .dQ. .d0Q0Q0. '0Q.       %s"
"${c2}     .0Q0'   'Q0Q0Q'  'Q0Q.     %s"
"${c2}     ''  .odo.    .odo.  ''     %s"
"${c2}    .  .0Q0Q0Q'  .0Q0Q0Q.  .    %s"
"${c2}  ,0Q .0Q0Q0Q0Q  'Q0Q0Q0b. 0Q.  %s"
"${c2}  :Q0  Q0Q0Q0Q    'Q0Q0Q0  Q0'  %s"
"${c2}  '0    '0Q0' .0Q0. '0'    'Q'  %s"
"${c2}    .oo.     .0Q0Q0.    .oo.    %s"
"${c2}    'Q0Q0.  '0Q0Q0Q0. .Q0Q0b    %s"
"${c2}     'Q0Q0.  '0Q0Q0' .d0Q0Q'    %s"
"${c2}      'Q0Q'    ..    '0Q.'      %s"
"${c2}            .0Q0Q0Q.            %s"
"${c2}             '0Q0Q'             %s")
		;;

		"CrunchBang")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'white') # White
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			logowidth="38"
			fulloutput=(
"${c1}                                      %s"
"${c1}         ███        ███          ███  %s"
"${c1}         ███        ███          ███  %s"
"${c1}         ███        ███          ███  %s"
"${c1}         ███        ███          ███  %s"
"${c1}  ████████████████████████████   ███  %s"
"${c1}  ████████████████████████████   ███  %s"
"${c1}         ███        ███          ███  %s"
"${c1}         ███        ███          ███  %s"
"${c1}         ███        ███          ███  %s"
"${c1}         ███        ███          ███  %s"
"${c1}  ████████████████████████████   ███  %s"
"${c1}  ████████████████████████████   ███  %s"
"${c1}         ███        ███               %s"
"${c1}         ███        ███               %s"
"${c1}         ███        ███          ███  %s"
"${c1}         ███        ███          ███  %s"
"${c1}                                      %s")
		;;

		"CRUX")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light cyan')
				c2=$(getColor 'yellow')
				c3=$(getColor 'white')
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; c3="${my_lcolor}"; fi
			startline="1"
			logowidth="27"
			fulloutput=(""
"${c1}          odddd            "
"${c1}       oddxkkkxxdoo        %s"
"${c1}      ddcoddxxxdoool       %s"
"${c1}      xdclodod  olol       %s"
"${c1}      xoc  xdd  olol       %s"
"${c1}      xdc  ${c2}k00${c1}Okdlol       %s"
"${c1}      xxd${c2}kOKKKOkd${c1}ldd       %s"
"${c1}      xdco${c2}xOkdlo${c1}dldd       %s"
"${c1}      ddc:cl${c2}lll${c1}oooodo      %s"
"${c1}    odxxdd${c3}xkO000kx${c1}ooxdo    %s"
"${c1}   oxdd${c3}x0NMMMMMMWW0od${c1}kkxo  %s"
"${c1}  oooxd${c3}0WMMMMMMMMMW0o${c1}dxkx  %s"
"${c1} docldkXW${c3}MMMMMMMWWN${c1}Odolco  %s"
"${c1} xx${c2}dx${c1}kxxOKN${c3}WMMWN${c1}0xdoxo::c  %s"
"${c2} xOkkO${c1}0oo${c3}odOW${c2}WW${c1}XkdodOxc:l  %s"
"${c2} dkkkxkkk${c3}OKX${c2}NNNX0Oxx${c1}xc:cd  %s"
"${c2}  odxxdx${c3}xllod${c2}ddooxx${c1}dc:ldo  %s"
"${c2}    lodd${c1}dolccc${c2}ccox${c1}xoloo    %s"
"${c1}                           %s")
		;;

		"Chrome OS")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'green') # Green
				c2=$(getColor 'light red') # Light Red
				c3=$(getColor 'yellow') # Bold Yellow
				c4=$(getColor 'light blue') # Light Blue
				c5=$(getColor 'white') # White
			fi
			if [ -n "${my_lcolor}" ]; then
				c1="${my_lcolor}"
				c2="${my_lcolor}"
				c3="${my_lcolor}"
				c4="${my_lcolor}"
				c5="${my_lcolor}"
			fi
			startline="0"
			logowidth="38"
			fulloutput=(
"${c2}             .,:loool:,.              %s"
"${c2}         .,coooooooooooooc,.          %s"
"${c2}      .,lllllllllllllllllllll,.       %s"
"${c2}     ;ccccccccccccccccccccccccc;      %s"
"${c1}   '${c2}ccccccccccccccccccccccccccccc.    %s"
"${c1}  ,oo${c2}c::::::::okO${c5}000${c3}0OOkkkkkkkkkkk:   %s"
"${c1} .ooool${c2};;;;:x${c5}K0${c4}kxxxxxk${c5}0X${c3}K0000000000.  %s"
"${c1} :oooool${c2};,;O${c5}K${c4}ddddddddddd${c5}KX${c3}000000000d  %s"
"${c1} lllllool${c2};l${c5}N${c4}dllllllllllld${c5}N${c3}K000000000  %s"
"${c1} lllllllll${c2}o${c5}M${c4}dccccccccccco${c5}W${c3}K000000000  %s"
"${c1} ;cllllllllX${c5}X${c4}c:::::::::c${c5}0X${c3}000000000d  %s"
"${c1} .ccccllllllO${c5}Nk${c4}c;,,,;cx${c5}KK${c3}0000000000.  %s"
"${c1}  .cccccclllllxOO${c5}OOO${c1}Okx${c3}O0000000000;   %s"
"${c1}   .:ccccccccllllllllo${c3}O0000000OOO,    %s"
"${c1}     ,:ccccccccclllcd${c3}0000OOOOOOl.     %s"
"${c1}       '::ccccccccc${c3}dOOOOOOOkx:.       %s"
"${c1}         ..,::cccc${c3}xOOOkkko;.          %s"
"${c1}             ..,:${c3}dOkxl:.              %s")
		;;

		"DesaOS")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light green') #Hijau
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			logowidth="33"
			fulloutput=(
"${c1} ███████████████████████         %s"
"${c1} ███████████████████████         %s"
"${c1} ███████████████████████         %s"
"${c1} ███████████████████████         %s"
"${c1} ████████               ███████  %s"
"${c1} ████████               ███████  %s"
"${c1} ████████               ███████  %s"
"${c1} ████████               ███████  %s"
"${c1} ████████               ███████  %s"
"${c1} ████████               ███████  %s"
"${c1} ████████               ███████  %s"
"${c1} ██████████████████████████████  %s"
"${c1} ██████████████████████████████  %s"
"${c1} ████████████████████████        %s"
"${c1} ████████████████████████        %s"
"${c1} ████████████████████████        %s"
"                                      %s")
		;;

		"Gentoo")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'white') # White
				c2=$(getColor 'light purple') # Light Purple
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="37"
			fulloutput=(
"${c2}         -/oyddmdhs+:.               %s"
"${c2}     -o${c1}dNMMMMMMMMNNmhy+${c2}-\`            %s"
"${c2}   -y${c1}NMMMMMMMMMMMNNNmmdhy${c2}+-          %s"
"${c2} \`o${c1}mMMMMMMMMMMMMNmdmmmmddhhy${c2}/\`       %s"
"${c2} om${c1}MMMMMMMMMMMN${c2}hhyyyo${c1}hmdddhhhd${c2}o\`     %s"
"${c2}.y${c1}dMMMMMMMMMMd${c2}hs++so/s${c1}mdddhhhhdm${c2}+\`   %s"
"${c2} oy${c1}hdmNMMMMMMMN${c2}dyooy${c1}dmddddhhhhyhN${c2}d.  %s"
"${c2}  :o${c1}yhhdNNMMMMMMMNNNmmdddhhhhhyym${c2}Mh  %s"
"${c2}    .:${c1}+sydNMMMMMNNNmmmdddhhhhhhmM${c2}my  %s"
"${c2}       /m${c1}MMMMMMNNNmmmdddhhhhhmMNh${c2}s:  %s"
"${c2}    \`o${c1}NMMMMMMMNNNmmmddddhhdmMNhs${c2}+\`   %s"
"${c2}  \`s${c1}NMMMMMMMMNNNmmmdddddmNMmhs${c2}/.     %s"
"${c2} /N${c1}MMMMMMMMNNNNmmmdddmNMNdso${c2}:\`       %s"
"${c2}+M${c1}MMMMMMNNNNNmmmmdmNMNdso${c2}/-          %s"
"${c2}yM${c1}MNNNNNNNmmmmmNNMmhs+/${c2}-\`            %s"
"${c2}/h${c1}MMNNNNNNNNMNdhs++/${c2}-\`               %s"
"${c2}\`/${c1}ohdmmddhys+++/:${c2}.\`                  %s"
"${c2}  \`-//////:--.                       %s")
		;;

		"Funtoo")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'white') # White
				c2=$(getColor 'light purple') # Light Purple
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="52"
			fulloutput=(
"${c1}                                                    %s"
"${c1}                                                    %s"
"${c1}                                                    %s"
"${c1}                                                    %s"
"${c1}     _______               ____                     %s"
"${c1}    /MMMMMMM/             /MMMM| _____  _____       %s"
"${c1} __/M${c2}.MMM.${c1}M/_____________|M${c2}.M${c1}MM|/MMMMM\/MMMMM\      %s"
"${c1}|MMMM${c2}MM'${c1}MMMMMMMMMMMMMMMMMMM${c2}MM${c1}MMMM${c2}.MMMM..MMMM.${c1}MM\    %s"
"${c1}|MM${c2}MMMMMMM${c1}/m${c2}MMMMMMMMMMMMMMMMMMMMMM${c1}MMMM${c2}MM${c1}MMMM${c2}MM${c1}MM|   %s"
"${c1}|MMMM${c2}MM${c1}MMM${c2}MM${c1}MM${c2}MM${c1}MM${c2}MM${c1}MMMMM${c2}\MMM${c1}MMM${c2}MM${c1}MMMM${c2}MM${c1}MMMM${c2}MM${c1}MM|   %s"
"${c1}  |MM${c2}MM${c1}MMM${c2}MM${c1}MM${c2}MM${c1}MM${c2}MM${c1}MM${c2}MM${c1}MM${c2}MMM${c1}MMMM${c2}'MMMM''MMMM'${c1}MM/    %s"
"${c1}  |MM${c2}MM${c1}MMM${c2}MM${c1}MM${c2}MM${c1}MM${c2}MM${c1}MM${c2}MM${c1}MM${c2}MMM${c1}MMM\MMMMM/\MMMMM/      %s"
"${c1}  |MM${c2}MM${c1}MMM${c2}MM${c1}MMMMMM${c2}MM${c1}MM${c2}MM${c1}MM${c2}MMMMM'${c1}M|                  %s"
"${c1}  |MM${c2}MM${c1}MMM${c2}MMMMMMMMMMMMMMMMM MM'${c1}M/                   %s"
"${c1}  |MMMMMMMMMMMMMMMMMMMMMMMMMMMM/                    %s"
"${c1}                                                    %s"
"${c1}                                                    %s"
"${c1}                                                    %s")
		;;

		"Kogaion")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light blue') # Light Blue
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			logowidth="41"
			fulloutput=(
"${c1}                  ;;      ,;             %s"
"${c1}                 ;;;     ,;;             %s"
"${c1}               ,;;;;     ;;;;            %s"
"${c1}            ,;;;;;;;;    ;;;;            %s"
"${c1}           ;;;;;;;;;;;   ;;;;;           %s"
"${c1}          ,;;;;;;;;;;;;  ';;;;;,         %s"
"${c1}          ;;;;;;;;;;;;;;, ';;;;;;;       %s"
"${c1}          ;;;;;;;;;;;;;;;;;, ';;;;;      %s"
"${c1}      ;    ';;;;;;;;;;;;;;;;;;, ;;;      %s"
"${c1}      ;;;,  ';;;;;;;;;;;;;;;;;;;,;;      %s"
"${c1}      ;;;;;,  ';;;;;;;;;;;;;;;;;;,       %s"
"${c1}      ;;;;;;;;,  ';;;;;;;;;;;;;;;;,      %s"
"${c1}      ;;;;;;;;;;;;, ';;;;;;;;;;;;;;      %s"
"${c1}      ';;;;;;;;;;;;; ';;;;;;;;;;;;;      %s"
"${c1}       ';;;;;;;;;;;;;, ';;;;;;;;;;;      %s"
"${c1}        ';;;;;;;;;;;;;  ;;;;;;;;;;       %s"
"${c1}          ';;;;;;;;;;;; ;;;;;;;;         %s"
"${c1}              ';;;;;;;; ;;;;;;           %s"
"${c1}                 ';;;;; ;;;;             %s"
"${c1}                   ';;; ;;               %s")
		;;

		"Fedora")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'white') # White
				c2=$(getColor 'light blue') # Light Blue
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="37"
			fulloutput=(
"${c2}           /:-------------:\         %s"
"${c2}        :-------------------::       %s"
"${c2}      :-----------${c1}/shhOHbmp${c2}---:\\     %s"
"${c2}    /-----------${c1}omMMMNNNMMD  ${c2}---:    %s"
"${c2}   :-----------${c1}sMMMMNMNMP${c2}.    ---:   %s"
"${c2}  :-----------${c1}:MMMdP${c2}-------    ---\  %s"
"${c2} ,------------${c1}:MMMd${c2}--------    ---:  %s"
"${c2} :------------${c1}:MMMd${c2}-------    .---:  %s"
"${c2} :----    ${c1}oNMMMMMMMMMNho${c2}     .----:  %s"
"${c2} :--     .${c1}+shhhMMMmhhy++${c2}   .------/  %s"
"${c2} :-    -------${c1}:MMMd${c2}--------------:   %s"
"${c2} :-   --------${c1}/MMMd${c2}-------------;    %s"
"${c2} :-    ------${c1}/hMMMy${c2}------------:     %s"
"${c2} :--${c1} :dMNdhhdNMMNo${c2}------------;      %s"
"${c2} :---${c1}:sdNMMMMNds:${c2}------------:       %s"
"${c2} :------${c1}:://:${c2}-------------::         %s"
"${c2} :---------------------://           %s"
"${c2}                                     %s")
		;;

		"Fux")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'white') # White
				c2=$(getColor 'light blue') # Light Blue
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			fulloutput=(
"${c2}           --/+osssso+/--           %s"
"${c2}        -/oshhhhhhhhhhhhso/-        %s"
"${c2}      :oyhhhhhso+//+oshhhhhso:      %s"
"${c2}    -+yhhhh+.   ss+/   .+hhhhs+-    %s"
"${c2}   :/hhhh/     shhhy/     /hhhh/:   %s"
"${c2}  ./hhhh- .++:..dhhb..:++. -hhhh/.  %s"
"${c2}  +ohhh: -hoyhohhoohhohyoh- :hhho+  %s"
"${c2}  /hhhh   shhy-ohyyho-yhhs   hhhh/  %s"
"${c2}  /hhhh    shy\+hhhh+/yhs    hhhh/  %s"
"${c2}  +ohhh:  .:d. +:ys:+ .b:.  :hhho+  %s"
"${c2}  ./hhhh- do  /  oo  \  ob -hhhh/.  %s"
"${c2}   :/hhhh/   -   ss   -   /hhhh/:   %s"
"${c2}    -+shhhh+.    //    .+hhhhs+-    %s"
"${c2}      :oshhhhhso+//+oshhhhhso:      %s"
"${c2}        -/oshhhhhhhhhhhhso/-        %s"
"${c2}           --/+osssso+/--           %s")
		;;

		"Chapeau")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'white') # White
				c2=$(getColor 'light green') # Light Green
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="35"
			fulloutput=(
"${c2}               .-/-.               %s"
"${c2}             ////////.             %s"
"${c2}           ////////${c1}y+${c2}//.           %s"
"${c2}         ////////${c1}mMN${c2}/////.         %s"
"${c2}       ////////${c1}mMN+${c2}////////.       %s"
"${c2}     ////////////////////////.     %s"
"${c2}   /////////+${c1}shhddhyo${c2}+////////.    %s"
"${c2}  ////////${c1}ymMNmdhhdmNNdo${c2}///////.   %s"
"${c2} ///////+${c1}mMms${c2}////////${c1}hNMh${c2}///////.  %s"
"${c2} ///////${c1}NMm+${c2}//////////${c1}sMMh${c2}///////  %s"
"${c2} //////${c1}oMMNmmmmmmmmmmmmMMm${c2}///////  %s"
"${c2} //////${c1}+MMmssssssssssssss+${c2}///////  %s"
"${c2} \`//////${c1}yMMy${c2}////////////////////   %s"
"${c2}  \`//////${c1}smMNhso++oydNm${c2}////////    %s"
"${c2}   \`///////${c1}ohmNMMMNNdy+${c2}///////     %s"
"${c2}     \`//////////${c1}++${c2}//////////       %s"
"${c2}        \`////////////////.         %s"
"${c2}            -////////-             %s"
"${c2}                                   %s")
		;;

		"Korora")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'white')
				c2=$(getColor 'light blue')
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="32"
			fulloutput=(
"${c1}                 ____________   %s"
"${c1}              _add55555555554${c2}:  %s"
"${c1}            _w?'${c2}\`\`\`\`\`\`\`\`\`\`'${c1})k${c2}:  %s"
"${c1}           _Z'${c2}\`${c1}            ]k${c2}:  %s"
"${c1}           m(${c2}\`${c1}             )k${c2}:  %s"
"${c1}      _.ss${c2}\`${c1}m[${c2}\`${c1},            ]e${c2}:  %s"
"${c1}    .uY\"^\`${c2}\`${c1}Xc${c2}\`${c1}?Ss.         d(${c2}\`  %s"
"${c1}   jF'${c2}\`${c1}    \`@.  ${c2}\`${c1}Sc      .jr${c2}\`   %s"
"${c1}  jr${c2}\`${c1}       \`?n_ ${c2}\`${c1}$;   _a2\"${c2}\`    %s"
"${c1} .m${c2}:${c1}          \`~M${c2}\`${c1}1k${c2}\`${c1}5?!\`${c2}\`      %s"
"${c1} :#${c2}:${c1}             ${c2}\`${c1})e${c2}\`\`\`         %s"
"${c1} :m${c2}:${c1}             ,#'${c2}\`           %s"
"${c1} :#${c2}:${c1}           .s2'${c2}\`            %s"
"${c1} :m,________.aa7^${c2}\`              %s"
"${c1} :#baaaaaaas!J'${c2}\`                %s"
"${c2}  \`\`\`\`\`\`\`\`\`\`\`                   %s")
		;;

		"gNewSense")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light blue') # Light Blue
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			logowidth="52"
			fulloutput=(
"${c1}                      ..,,,,..                      %s"
"${c1}                .oocchhhhhhhhhhccoo.                %s"
"${c1}         .ochhlllllllc hhhhhh ollllllhhco.          %s"
"${c1}     ochlllllllllll hhhllllllhhh lllllllllllhco     %s"
"${c1}  .cllllllllllllll hlllllo  +hllh llllllllllllllc.  %s"
"${c1} ollllllllllhco\'\'  hlllllo  +hllh  \`\`ochllllllllllo %s"
"${c1} hllllllllc\'       hllllllllllllh       \`cllllllllh %s"
"${c1} ollllllh          +llllllllllll+          hllllllo %s"
"${c1}  \`cllllh.           ohllllllho           .hllllc\'  %s"
"${c1}     ochllc.            ++++            .cllhco     %s"
"${c1}        \`+occooo+.                .+ooocco+\'        %s"
"${c1}               \`+oo++++      ++++oo+\'               %s"
"${c1}                                                    %s")
		;;

		"BLAG")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light purple')
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			logowidth="36"
			fulloutput=(
"${c1}              d                     %s"
"${c1}             ,MK:                   %s"
"${c1}             xMMMX:                 %s"
"${c1}            .NMMMMMX;               %s"
"${c1}            lMMMMMMMM0clodkO0KXWW:  %s"
"${c1}            KMMMMMMMMMMMMMMMMMMX'   %s"
"${c1}       .;d0NMMMMMMMMMMMMMMMMMMK.    %s"
"${c1}  .;dONMMMMMMMMMMMMMMMMMMMMMMx      %s"
"${c1} 'dKMMMMMMMMMMMMMMMMMMMMMMMMl       %s"
"${c1}    .:xKWMMMMMMMMMMMMMMMMMMM0.      %s"
"${c1}        .:xNMMMMMMMMMMMMMMMMMK.     %s"
"${c1}           lMMMMMMMMMMMMMMMMMMK.    %s"
"${c1}           ,MMMMMMMMWkOXWMMMMMM0    %s"
"${c1}           .NMMMMMNd.     \`':ldko   %s"
"${c1}            OMMMK:                  %s"
"${c1}            oWk,                    %s"
"${c1}            ;:                      %s")
		;;

		"FreeBSD")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'white') # white
				c2=$(getColor 'light red') # Light Red
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="37"
			fulloutput=(
"${c1}                                     %s"
"${c1}   \`\`\`                        ${c2}\`      %s"
"${c1}  \` \`.....---...${c2}....--.\`\`\`   -/      %s"
"${c1}  +o   .--\`         ${c2}/y:\`      +.     %s"
"${c1}   yo\`:.            ${c2}:o      \`+-      %s"
"${c1}    y/               ${c2}-/\`   -o/       %s"
"${c1}   .-                  ${c2}::/sy+:.      %s"
"${c1}   /                     ${c2}\`--  /      %s"
"${c1}  \`:                          ${c2}:\`     %s"
"${c1}  \`:                          ${c2}:\`     %s"
"${c1}   /                          ${c2}/      %s"
"${c1}   .-                        ${c2}-.      %s"
"${c1}    --                      ${c2}-.       %s"
"${c1}     \`:\`                  ${c2}\`:\`        %s"
"${c2}       .--             \`--.          %s"
"${c2}          .---.....----.             %s"
"${c2}                                     %s"
"${c2}                                     %s")
		;;

		"FreeBSD - Old")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'white') # white
				c2=$(getColor 'light red') # Light Red
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="34"
			fulloutput=(
"${c2}              ,        ,          %s"
"${c2}             /(        )\`         %s"
"${c2}             \ \___   / |         %s"
"${c2}             /- ${c1}_${c2}  \`-/  '         %s"
"${c2}            (${c1}/\/ \ ${c2}\   /\\         %s"
"${c1}            / /   |${c2} \`    \\        %s"
"${c1}            O O   )${c2} /    |        %s"
"${c1}            \`-^--'\`${c2}<     '        %s"
"${c2}           (_.)  _  )   /         %s"
"${c2}            \`.___/\`    /          %s"
"${c2}              \`-----' /           %s"
"${c1} <----.     ${c2}__/ __   \\            %s"
"${c1} <----|====${c2}O}}}${c1}==${c2}} \} \/${c1}====      %s"
"${c1} <----'    ${c2}\`--' \`.__,' \\          %s"
"${c2}              |        |          %s"
"${c2}               \       /       /\\ %s"
"${c2}          ______( (_  / \______/  %s"
"${c2}        ,'  ,-----'   |           %s"
"${c2}        \`--{__________)           %s"
"${c2}                                  %s")
		;;

		"OpenBSD")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'yellow') # Light Yellow
				c2=$(getColor 'brown') # Bold Yellow
				c3=$(getColor 'light cyan') # Light Cyan
				c4=$(getColor 'light red') # Light Red
				c5=$(getColor 'dark grey')
			fi
			if [ -n "${my_lcolor}" ]; then
				c1="${my_lcolor}"
				c2="${my_lcolor}"
				c3="${my_lcolor}"
				c4="${my_lcolor}"
				c5="${my_lcolor}"
			fi
			startline="3"
			logowidth="44"
			fulloutput=(
"${c3}                                        _   "
"${c3}                                       (_)  "
"${c1}              |    .                        "
"${c1}          .   |L  /|   .         ${c3} _         %s"
"${c1}      _ . |\ _| \--+._/| .       ${c3}(_)        %s"
"${c1}     / ||\| Y J  )   / |/| ./               %s"
"${c1}    J  |)'( |        \` F\`.'/       ${c3} _       %s"
"${c1}  -<|  F         __     .-<        ${c3}(_)      %s"
"${c1}    | /       .-'${c3}. ${c1}\`.  /${c3}-. ${c1}L___             %s"
"${c1}    J \      <    ${c3}\ ${c1} | | ${c5}O${c3}\\\\${c1}|.-' ${c3} _          %s"
"${c1}  _J \  .-    \\\\${c3}/ ${c5}O ${c3}| ${c1}| \  |${c1}F    ${c3}(_)         %s"
"${c1} '-F  -<_.     \   .-'  \`-' L__             %s"
"${c1}__J  _   _.     >-'  ${c2})${c4}._.   ${c1}|-'             %s"
"${c1} \`-|.'   /_.          ${c4}\_|  ${c1} F               %s"
"${c1}  /.-   .                _.<                %s"
"${c1} /'    /.'             .'  \`\               %s"
"${c1}  /L  /'   |/      _.-'-\                   %s"
"${c1} /'J       ___.---'\|                       %s"
"${c1}   |\  .--' V  | \`. \`                       %s"
"${c1}   |/\`. \`-.     \`._)                        %s"
"${c1}      / .-.\                                %s"
"${c1}      \ (  \`\                               %s"
"${c1}       \`.\                                  %s")
		;;

		"DragonFlyBSD")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light red') # Red
				c2=$(getColor 'white') # White
				c3=$(getColor 'yellow')
				c4=$(getColor 'light red')
			fi
            if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; c3="${my_lcolor}"; c4="${my_lcolor}"; fi
			startline="0"
			logowidth="43"
			fulloutput=(
"${c1}                      |                    %s"
"${c1}                     .-.                   %s"
"${c3}                    ()${c1}I${c3}()                  %s"
"${c1}               \"==.__:-:__.==\"             %s"
"${c1}              \"==.__/~|~\__.==\"            %s"
"${c1}              \"==._(  Y  )_.==\"            %s"
"${c2}   .-'~~\"\"~=--...,__${c1}\/|\/${c2}__,...--=~\"\"~~'-. %s"
"${c2}  (               ..=${c1}\\\\=${c1}/${c2}=..               )%s"
"${c2}   \`'-.        ,.-\"\`;${c1}/=\\\\${c2} ;\"-.,_        .-'\`%s"
"${c2}       \`~\"-=-~\` .-~\` ${c1}|=|${c2} \`~-. \`~-=-\"~\`     %s"
"${c2}            .-~\`    /${c1}|=|${c2}\    \`~-.          %s"
"${c2}         .~\`       / ${c1}|=|${c2} \       \`~.       %s"
"${c2}     .-~\`        .'  ${c1}|=|${c2}  \\\\\`.        \`~-.  %s"
"${c2}   (\`     _,.-=\"\`    ${c1}|=|${c2}    \`\"=-.,_     \`) %s"
"${c2}    \`~\"~\"\`           ${c1}|=|${c2}           \`\"~\"~\`  %s"
"${c1}                     /=\                   %s"
"${c1}                     \=/                   %s"
"${c1}                      ^                    %s")
		;;

		"NetBSD")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'orange') # Orange
				c2=$(getColor 'white') # White
			fi
            if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="60"
			fulloutput=(
"${c1}                                  __,gnnnOCCCCCOObaau,_     %s"
"${c2}   _._                    ${c1}__,gnnCCCCCCCCOPF\"''              %s"
"${c2}  (N\\\\\\\\${c1}XCbngg,._____.,gnnndCCCCCCCCCCCCF\"___,,,,___          %s"
"${c2}   \\\\N\\\\\\\\${c1}XCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCOOOOPYvv.     %s"
"${c2}    \\\\N\\\\\\\\${c1}XCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCPF\"''               %s"
"${c2}     \\\\N\\\\\\\\${c1}XCCCCCCCCCCCCCCCCCCCCCCCCCOF\"'                     %s"
"${c2}      \\\\N\\\\\\\\${c1}XCCCCCCCCCCCCCCCCCCCCOF\"'                         %s"
"${c2}       \\\\N\\\\\\\\${c1}XCCCCCCCCCCCCCCCPF\"'                             %s"
"${c2}        \\\\N\\\\\\\\${c1}\"PCOCCCOCCFP\"\"                                  %s"
"${c2}         \\\\N\                                                %s"
"${c2}          \\\\N\                                               %s"
"${c2}           \\\\N\                                              %s"
"${c2}            \\\\NN\                                            %s"
"${c2}             \\\\NN\                                           %s"
"${c2}              \\\\NNA.                                         %s"
"${c2}               \\\\NNA,                                        %s"
"${c2}                \\\\NNN,                                       %s"
"${c2}                 \\\\NNN\                                      %s"
"${c2}                  \\\\NNN\                                     %s"
"${c2}                   \\\\NNNA                                    %s")
		;;

		"Mandriva"|"Mandrake")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light blue') # Light Blue
				c2=$(getColor 'yellow') # Bold Yellow
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="41"
			fulloutput=(
"${c2}                                         %s"
"${c2}                         \`\`              %s"
"${c2}                        \`-.              %s"
"${c1}       \`               ${c2}.---              %s"
"${c1}     -/               ${c2}-::--\`             %s"
"${c1}   \`++    ${c2}\`----...\`\`\`-:::::.             %s"
"${c1}  \`os.      ${c2}.::::::::::::::-\`\`\`     \`  \` %s"
"${c1}  +s+         ${c2}.::::::::::::::::---...--\` %s"
"${c1} -ss:          ${c2}\`-::::::::::::::::-.\`\`.\`\` %s"
"${c1} /ss-           ${c2}.::::::::::::-.\`\`   \`    %s"
"${c1} +ss:          ${c2}.::::::::::::-            %s"
"${c1} /sso         ${c2}.::::::-::::::-            %s"
"${c1} .sss/       ${c2}-:::-.\`   .:::::            %s"
"${c1}  /sss+.    ${c2}..\`${c1}  \`--\`    ${c2}.:::            %s"
"${c1}   -ossso+/:://+/-\`        ${c2}.:\`           %s"
"${c1}     -/+ooo+/-.              ${c2}\`           %s"
"${c1}                                         %s"
"${c1}                                         %s")
		;;

		"openSUSE"|"SUSE Linux Enterprise")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light green') # Bold Green
				c2=$c0$bold
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="44"
			fulloutput=(
"${c2}             .;ldkO0000Okdl;.               %s"
"${c2}         .;d00xl:^''''''^:ok00d;.           %s"
"${c2}       .d00l'                'o00d.         %s"
"${c2}     .d0K^'${c1}  Okxoc;:,.          ${c2}^O0d.       %s"
"${c2}    .OVV${c1}AK0kOKKKKKKKKKKOxo:,      ${c2}lKO.      %s"
"${c2}   ,0VV${c1}AKKKKKKKKKKKKK0P^${c2},,,${c1}^dx:${c2}    ;00,     %s"
"${c2}  .OVV${c1}AKKKKKKKKKKKKKk'${c2}.oOPPb.${c1}'0k.${c2}   cKO.    %s"
"${c2}  :KV${c1}AKKKKKKKKKKKKKK: ${c2}kKx..dd ${c1}lKd${c2}   'OK:    %s"
"${c2}  lKl${c1}KKKKKKKKKOx0KKKd ${c2}^0KKKO' ${c1}kKKc${c2}   lKl    %s"
"${c2}  lKl${c1}KKKKKKKKKK;.;oOKx,..${c2}^${c1}..;kKKK0.${c2}  lKl    %s"
"${c2}  :KA${c1}lKKKKKKKKK0o;...^cdxxOK0O/^^'  ${c2}.0K:    %s"
"${c2}   kKA${c1}VKKKKKKKKKKKK0x;,,......,;od  ${c2}lKP     %s"
"${c2}   '0KA${c1}VKKKKKKKKKKKKKKKKKK00KKOo^  ${c2}c00'     %s"
"${c2}    'kKA${c1}VOxddxkOO00000Okxoc;''   ${c2}.dKV'      %s"
"${c2}      l0Ko.                    .c00l'       %s"
"${c2}       'l0Kk:.              .;xK0l'         %s"
"${c2}          'lkK0xc;:,,,,:;odO0kl'            %s"
"${c2}              '^:ldxkkkkxdl:^'              %s")
		;;

		"Slackware")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light blue') # Light Blue
				c2=$(getColor 'white') # Bold White
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="1"
			logowidth="46"
			fulloutput=(
"${c1}                   :::::::                    "
"${c1}             :::::::::::::::::::              %s"
"${c1}          :::::::::::::::::::::::::           %s"
"${c1}        ::::::::${c2}cllcccccllllllll${c1}::::::        %s"
"${c1}     :::::::::${c2}lc               dc${c1}:::::::      %s"
"${c1}    ::::::::${c2}cl   clllccllll    oc${c1}:::::::::    %s"
"${c1}   :::::::::${c2}o   lc${c1}::::::::${c2}co   oc${c1}::::::::::   %s"
"${c1}  ::::::::::${c2}o    cccclc${c1}:::::${c2}clcc${c1}::::::::::::  %s"
"${c1}  :::::::::::${c2}lc        cclccclc${c1}:::::::::::::  %s"
"${c1} ::::::::::::::${c2}lcclcc          lc${c1}:::::::::::: %s"
"${c1} ::::::::::${c2}cclcc${c1}:::::${c2}lccclc     oc${c1}::::::::::: %s"
"${c1} ::::::::::${c2}o    l${c1}::::::::::${c2}l    lc${c1}::::::::::: %s"
"${c1}  :::::${c2}cll${c1}:${c2}o     clcllcccll     o${c1}:::::::::::  %s"
"${c1}  :::::${c2}occ${c1}:${c2}o                  clc${c1}:::::::::::  %s"
"${c1}   ::::${c2}ocl${c1}:${c2}ccslclccclclccclclc${c1}:::::::::::::   %s"
"${c1}    :::${c2}oclcccccccccccccllllllllllllll${c1}:::::    %s"
"${c1}     ::${c2}lcc1lcccccccccccccccccccccccco${c1}::::     %s"
"${c1}       ::::::::::::::::::::::::::::::::       %s"
"${c1}         ::::::::::::::::::::::::::::         %s"
"${c1}            ::::::::::::::::::::::            %s"
"${c1}                 ::::::::::::                 %s")
		;;

		"ROSA")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'rosa_blue') # special blue color from ROSA
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="3"
			logowidth="41"
			fulloutput=(
"${c1}            ROSAROSAROSAROSAR            "
"${c1}         ROSA               AROS         "
"${c1}       ROS   SAROSAROSAROSAR   AROS      "
"${c1}     RO   ROSAROSAROSAROSAROSAR   RO     %s"
"${c1}   ARO  AROSAROSAROSARO      AROS  ROS   %s"
"${c1}  ARO  ROSAROS         OSAR   ROSA  ROS  %s"
"${c1}  RO  AROSA   ROSAROSAROSA    ROSAR  RO  %s"
"${c1} RO  ROSAR  ROSAROSAROSAR  R  ROSARO  RO %s"
"${c1} RO  ROSA  AROSAROSAROSA  AR  ROSARO  AR %s"
"${c1} RO AROS  ROSAROSAROSA   ROS  AROSARO AR %s"
"${c1} RO AROS  ROSAROSARO   ROSARO  ROSARO AR %s"
"${c1} RO  ROS  AROSAROS   ROSAROSA AROSAR  AR %s"
"${c1} RO  ROSA  ROS     ROSAROSAR  ROSARO  RO %s"
"${c1}  RO  ROS     AROSAROSAROSA  ROSARO  AR  %s"
"${c1}  ARO  ROSA   ROSAROSAROS   AROSAR  ARO  %s"
"${c1}   ARO  OROSA      R      ROSAROS  ROS   %s"
"${c1}     RO   AROSAROS   AROSAROSAR   RO     %s"
"${c1}      AROS   AROSAROSAROSARO   AROS      %s"
"${c1}         ROSA               SARO         %s"
"${c1}            ROSAROSAROSAROSAR            %s")
		;;

		"Red Hat Enterprise Linux")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light red') # Light Red
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			logowidth="42"
			fulloutput=(
"${c1}            .MMM..:MMMMMMM                 %s"
"${c1}           MMMMMMMMMMMMMMMMMM              %s"
"${c1}           MMMMMMMMMMMMMMMMMMMM.           %s"
"${c1}          MMMMMMMMMMMMMMMMMMMMMM           %s"
"${c1}         ,MMMMMMMMMMMMMMMMMMMMMM:          %s"
"${c1}         MMMMMMMMMMMMMMMMMMMMMMMM          %s"
"${c1}   .MMMM'  MMMMMMMMMMMMMMMMMMMMMM          %s"
"${c1}  MMMMMM    \`MMMMMMMMMMMMMMMMMMMM.         %s"
"${c1} MMMMMMMM      MMMMMMMMMMMMMMMMMM .        %s"
"${c1} MMMMMMMMM.       \`MMMMMMMMMMMMM' MM.      %s"
"${c1} MMMMMMMMMMM.                     MMMM     %s"
"${c1} \`MMMMMMMMMMMMM.                 ,MMMMM.   %s"
"${c1}  \`MMMMMMMMMMMMMMMMM.          ,MMMMMMMM.  %s"
"${c1}     MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM  %s"
"${c1}       MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:  %s"
"${c1}          MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM   %s"
"${c1}             \`MMMMMMMMMMMMMMMMMMMMMMMM:    %s"
"${c1}                 \`\`MMMMMMMMMMMMMMMMM'      %s")
		;;

		"Frugalware")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'white') # White
				c2=$(getColor 'light blue') # Light Blue
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="3"
			logowidth="50"
			fulloutput=(
"${c2}          \`++/::-.\`                               "
"${c2}         /o+++++++++/::-.\`                        "
"${c2}        \`o+++++++++++++++o++/::-.\`                "
"${c2}        /+++++++++++++++++++++++oo++/:-.\`\`        %s"
"${c2}       .o+ooooooooooooooooooosssssssso++oo++/:-\`  %s"
"${c2}       ++osoooooooooooosssssssssssssyyo+++++++o:  %s"
"${c2}      -o+ssoooooooooooosssssssssssssyyo+++++++s\`  %s"
"${c2}      o++ssoooooo++++++++++++++sssyyyyo++++++o:   %s"
"${c2}     :o++ssoooooo${c1}/-------------${c2}+syyyyyo+++++oo    %s"
"${c2}    \`o+++ssoooooo${c1}/-----${c2}+++++ooosyyyyyyo++++os:    %s"
"${c2}    /o+++ssoooooo${c1}/-----${c2}ooooooosyyyyyyyo+oooss     %s"
"${c2}   .o++++ssooooos${c1}/------------${c2}syyyyyyhsosssy-     %s"
"${c2}   ++++++ssooooss${c1}/-----${c2}+++++ooyyhhhhhdssssso      %s"
"${c2}  -s+++++syssssss${c1}/-----${c2}yyhhhhhhhhhhhddssssy.      %s"
"${c2}  sooooooyhyyyyyh${c1}/-----${c2}hhhhhhhhhhhddddyssy+       %s"
"${c2} :yooooooyhyyyhhhyyyyyyhhhhhhhhhhdddddyssy\`       %s"
"${c2} yoooooooyhyyhhhhhhhhhhhhhhhhhhhddddddysy/        %s"
"${c2}-ysooooooydhhhhhhhhhhhddddddddddddddddssy         %s"
"${c2} .-:/+osssyyyysyyyyyyyyyyyyyyyyyyyyyyssy:         %s"
"${c2}       \`\`.-/+oosysssssssssssssssssssssss          %s"
"${c2}               \`\`.:/+osyysssssssssssssh.          %s"
"${c2}                        \`-:/+osyyssssyo           %s"
"${c2}                                .-:+++\`           %s")
		;;

		"Peppermint")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'white') # White
				c2=$(getColor 'light red') # Light Red
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="3"
			logowidth="40"
			fulloutput=(
"${c2}             PPPPPPPPPPPPPP             "
"${c2}         PPPP${c1}MMMMMMM${c2}PPPPPPPPPPP         "
"${c2}       PPPP${c1}MMMMMMMMMM${c2}PPPPPPPP${c1}MM${c2}PP       "
"${c2}     PPPPPPPP${c1}MMMMMMM${c2}PPPPPPPP${c1}MMMMM${c2}PP     %s"
"${c2}   PPPPPPPPPPPP${c1}MMMMMM${c2}PPPPPPP${c1}MMMMMMM${c2}PP   %s"
"${c2}  PPPPPPPPPPPP${c1}MMMMMMM${c2}PPPP${c1}M${c2}P${c1}MMMMMMMMM${c2}PP  %s"
"${c2} PP${c1}MMMM${c2}PPPPPPPPPP${c1}MMM${c2}PPPPP${c1}MMMMMMM${c2}P${c1}MM${c2}PPPP %s"
"${c2} P${c1}MMMMMMMMMM${c2}PPPPPP${c1}MM${c2}PPPPP${c1}MMMMMM${c2}PPPPPPPP %s"
"${c2}P${c1}MMMMMMMMMMMM${c2}PPPPP${c1}MM${c2}PP${c1}M${c2}P${c1}MM${c2}P${c1}MM${c2}PPPPPPPPPPP%s"
"${c2}P${c1}MMMMMMMMMMMMMMMM${c2}PP${c1}M${c2}P${c1}MMM${c2}PPPPPPPPPPPPPPPP%s"
"${c2}P${c1}MMM${c2}PPPPPPPPPPPPPPPPPPPPPPPPPPPPPP${c1}MMMMM${c2}P%s"
"${c2}PPPPPPPPPPPPPPPP${c1}MMM${c2}P${c1}M${c2}P${c1}MMMMMMMMMMMMMMMM${c2}PP%s"
"${c2}PPPPPPPPPPP${c1}MM${c2}P${c1}MM${c2}PPPP${c1}MM${c2}PPPPP${c1}MMMMMMMMMMM${c2}PP%s"
"${c2} PPPPPPPP${c1}MMMMMM${c2}PPPPP${c1}MM${c2}PPPPPP${c1}MMMMMMMMM${c2}PP %s"
"${c2} PPPP${c1}MM${c2}P${c1}MMMMMMM${c2}PPPPPP${c1}MM${c2}PPPPPPPPPP${c1}MMMM${c2}PP %s"
"${c2}  PP${c1}MMMMMMMMM${c2}P${c1}M${c2}PPPP${c1}MMMMMM${c2}PPPPPPPPPPPPP  %s"
"${c2}   PP${c1}MMMMMMM${c2}PPPPPPP${c1}MMMMMM${c2}PPPPPPPPPPPP   %s"
"${c2}     PP${c1}MMMM${c2}PPPPPPPPP${c1}MMMMMMM${c2}PPPPPPPP     %s"
"${c2}       PP${c1}MM${c2}PPPPPPPP${c1}MMMMMMMMMM${c2}PPPP       %s"
"${c2}         PPPPPPPPPP${c1}MMMMMMMM${c2}PPPP         %s"
"${c2}             PPPPPPPPPPPPPP             %s")
		;;

"Grombyang"|"GrombyangOS")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light blue')
				c2=$(getColor 'light green')
				c3=$(getColor 'light red')
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			fulloutput=(
"${c1}             eeeeeeeeeeee                           %s"
"${c1}          eeeeeeeeeeeeeeeee          %s"
"${c1}       eeeeeeeeeeeeeeeeeeeeeee       %s"
"${c1}     eeeee       ${c2}.o+       ${c1}eeee      %s"
"${c1}   eeee         ${c2}\`ooo/         ${c1}eeee   %s"
"${c1}  eeee         ${c2}\`+oooo:         ${c1}eeee  %s"
"${c1} eee          ${c2}\`+oooooo:          ${c1}eee %s"
"${c1} eee          ${c2}-+oooooo+:         ${c1}eee %s"
"${c1} ee         ${c2}\`/:oooooooo+:         ${c1}ee %s"
"${c1} ee        ${c2}\`/+   +++    +:        ${c1}ee %s"
"${c1} ee              ${c2}+o+\             ${c1}ee %s"
"${c1} eee             ${c2}+o+\            ${c1}eee %s"
"${c1} eee        ${c2}//  \\ooo/  \\\         ${c1}eee %s"
"${c1}  eee      ${c2}//++++oooo++++\\\      ${c1}eee  %s"
"${c1}   eeee    ${c2}::::++oooo+:::::   ${c1}eeee   %s"
"${c1}     eeeee   ${c3}Grombyang OS ${c1}  eeee     %s"
"${c1}       eeeeeeeeeeeeeeeeeeeeeee       %s"
"${c1}          eeeeeeeeeeeeeeeee          %s"
"                                     %s"
"                                     %s")
	;;

		"Solus")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'white') # White
				c2=$(getColor 'blue') # Blue
				c3=$(getColor 'black') # Black
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="36"
			fulloutput=(
"${c3}               ......               %s"
"${c3}         .'${c1}D${c3}lddddddddddd'.          %s"
"${c3}      .'ddd${c1}XM${c3}xdddddddddddddd.       %s"
"${c3}    .dddddx${c1}MMM0${c3};dddddddddddddd.     %s"
"${c3}   'dddddl${c1}MMMMMN${c3}cddddddddddddddd.   %s"
"${c3}  ddddddc${c1}WMMMMMMW${c3}lddddddddddddddd.  %s"
"${c3} ddddddc${c1}WMMMMMMMMO${c3}ddoddddddddddddd. %s"
"${c3}.ddddd:${c1}NMMMMMMMMMK${c3}dd${c1}NX${c3}od;c${c1}lxl${c3}dddddd %s"
"${c3}dddddc${c1}WMMMMMMMMMMNN${c3}dd${c1}MMXl${c3};d${c1}00xl;${c3}ddd.%s"
"${c3}ddddl${c1}WMMMMMMMMMMMMM${c3}d;${c1}MMMM0${c3}:dl${c1}XMMXk:${c3}'%s"
"${c3}dddo${c1}WMMMMMMMMMMMMMM${c3}dd${c1}MMMMMW${c3}od${c3};${c1}XMMMOd%s"
"${c3}.dd${c1}MMMMMMMMMMMMMMMM${c3}d:${c1}MMMMMMM${c3}kd${c1}lMKll %s"
"${c3}.;dk0${c1}KXNWWMMMMMMMMM${c3}dx${c1}MMMMMMM${c3}Xl;lxK; %s"
"${c3}  'dddddddd;:cclodcddxddolloxO0O${c1}d'  %s"
"${c1}   ckkxxxddddddddxxkOOO000Okdool.   %s"
"${c2}    .lddddxxxxxxddddooooooooood     %s"
"${c2}      .:oooooooooooooooooooc'       %s"
"${c2}         .,:looooooooooc;.  %s")
		;;

		"Mageia")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'white') # White
			 	c2=$(getColor 'light cyan') # Light Cyan
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="33"
			fulloutput=(
"${c2}               .°°.              %s"
"${c2}                °°   .°°.        %s"
"${c2}                .°°°. °°         %s"
"${c2}                .   .            %s"
"${c2}                 °°° .°°°.       %s"
"${c2}             .°°°.   '___'       %s"
"${c1}            .${c2}'___'     ${c1}   .      %s"
"${c1}          :dkxc;'.  ..,cxkd;     %s"
"${c1}        .dkk. kkkkkkkkkk .kkd.   %s"
"${c1}       .dkk.  ';cloolc;.  .kkd   %s"
"${c1}       ckk.                .kk;  %s"
"${c1}       xO:                  cOd  %s"
"${c1}       xO:                  lOd  %s"
"${c1}       lOO.                .OO:  %s"
"${c1}       .k00.              .00x   %s"
"${c1}        .k00;            ;00O.   %s"
"${c1}         .lO0Kc;,,,,,,;c0KOc.    %s"
"${c1}            ;d00KKKKKK00d;       %s"
"${c1}               .,KKKK,.          %s")
		;;

		"Hyperbola GNU/Linux-libre")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light grey') # light grey
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="25"
			fulloutput=(
"${c1}                                    %s"
"${c1}                  ..              , %s"
"${c1}                  a;           ._#  %s"
"${c1}                 )##        _au#?   %s"
"${c1}                 ]##s,.__a_w##e^    %s"
"${c1}                 :###########(      %s"
"${c1}                  ^!#####?!^        %s"
"${c1}                  ._                %s"
"${c1}             _au######a,            %s"
"${c1}           sa###########,           %s"
"${c1}        _a##############o           %s"
"${c1}      .a#####?!^^^^^-####_          %s"
"${c1}     j####^           ~##i          %s"
"${c1}   _de!^               -#i          %s"
"${c1} _#e^                   ]+          %s"
"${c1} ^                      ^           %s"
"${c1}                                    %s")
			;;

		"Parabola GNU/Linux-libre")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'purple') # Purple
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="33"
			fulloutput=(
"${c1}                                       %s"
"${c1}                          _,,     _    %s"
"${c1}                   _,   ,##'    ,##;   %s"
"${c1}             _, ,##'  ,##'    ,#####;  %s"
"${c1}         _,;#',##'  ,##'    ,#######'  %s"
"${c1}     _,#**^'         \`    ,#########   %s"
"${c1} .-^\`                    \`#########    %s"
"${c1}                          ########     %s"
"${c1}                          ;######      %s"
"${c1}                          ;####*       %s"
"${c1}                          ####'        %s"
"${c1}                         ;###          %s"
"${c1}                        ,##'           %s"
"${c1}                        ##             %s"
"${c1}                       #'              %s"
"${c1}                      /                %s"
"${c1}                     '                 %s"
"${c1}                                       %s")
		;;

		"Viperr")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'white') # White
				c2=$(getColor 'dark grey') # Dark Gray
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="31"
			fulloutput=(
"${c1}    wwzapd         dlzazw      %s"
"${c1}   an${c2}#${c1}zncmqzepweeirzpas${c2}#${c1}xz     %s"
"${c1} apez${c2}##${c1}qzdkawweemvmzdm${c2}##${c1}dcmv   %s"
"${c1}zwepd${c2}####${c1}qzdweewksza${c2}####${c1}ezqpa  %s"
"${c1}ezqpdkapeifjeeazezqpdkazdkwqz  %s"
"${c1} ezqpdksz${c2}##${c1}wepuizp${c2}##${c1}wzeiapdk   %s"
"${c1}  zqpakdpa${c2}#${c1}azwewep${c2}#${c1}zqpdkqze    %s"
"${c1}    apqxalqpewenwazqmzazq      %s"
"${c1}     mn${c2}##${c1}==${c2}#######${c1}==${c2}##${c1}qp       %s"
"${c1}      qw${c2}##${c1}=${c2}#######${c1}=${c2}##${c1}zl        %s"
"${c1}      z0${c2}######${c1}=${c2}######${c1}0a        %s"
"${c1}       qp${c2}#####${c1}=${c2}#####${c1}mq         %s"
"${c1}       az${c2}####${c1}===${c2}####${c1}mn         %s"
"${c1}        ap${c2}#########${c1}qz          %s"
"${c1}         9qlzskwdewz           %s"
"${c1}          zqwpakaiw            %s"
"${c1}            qoqpe              %s"
"${c1}                               %s")
		;;

		"LinuxDeepin")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light green') # Bold Green
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			logowidth="33"
			fulloutput=(
"${c1}  eeeeeeeeeeeeeeeeeeeeeeeeeeee   %s"
"${c1} eee  eeeeeee          eeeeeeee  %s"
"${c1}ee   eeeeeeeee      eeeeeeeee ee %s"
"${c1}e   eeeeeeeee     eeeeeeeee    e %s"
"${c1}e   eeeeeee    eeeeeeeeee      e %s"
"${c1}e   eeeeee    eeeee            e %s"
"${c1}e    eeeee    eee  eee         e %s"
"${c1}e     eeeee   ee eeeeee        e %s"
"${c1}e      eeeee   eee   eee       e %s"
"${c1}e       eeeeeeeeee  eeee       e %s"
"${c1}e         eeeee    eeee        e %s"
"${c1}e               eeeeee         e %s"
"${c1}e            eeeeeee           e %s"
"${c1}e eee     eeeeeeee             e %s"
"${c1}eeeeeeeeeeeeeeee               e %s"
"${c1}eeeeeeeeeeeee                 ee %s"
"${c1} eeeeeeeeeee                eee  %s"
"${c1}  eeeeeeeeeeeeeeeeeeeeeeeeeeee   %s"
"${c1}                                 %s")
		;;

		"Deepin")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'cyan') # Bold Green
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			logowidth="41"
			fulloutput=(
"${c1}              ............               %s"
"${c1}          .';;;;;.       .,;,.           %s"
"${c1}       .,;;;;;;;.       ';;;;;;;.        %s"
"${c1}     .;::::::::'     .,::;;,''''',.      %s"
"${c1}    ,'.::::::::    .;;'.          ';     %s"
"${c1}   ;'  'cccccc,   ,' :: '..        .:    %s"
"${c1}  ,,    :ccccc.  ;: .c, '' :.       ,;   %s"
"${c1} .l.     cllll' ., .lc  :; .l'       l.  %s"
"${c1} .c       :lllc  ;cl:  .l' .ll.      :'  %s"
"${c1} .l        'looc. .   ,o:  'oo'      c,  %s"
"${c1} .o.         .:ool::coc'  .ooo'      o.  %s"
"${c1}  ::            .....   .;dddo      ;c   %s"
"${c1}   l:...            .';lddddo.     ,o    %s"
"${c1}    lxxxxxdoolllodxxxxxxxxxc      :l     %s"
"${c1}     ,dxxxxxxxxxxxxxxxxxxl.     'o,      %s"
"${c1}       ,dkkkkkkkkkkkkko;.    .;o;        %s"
"${c1}         .;okkkkkdl;.    .,cl:.          %s"
"${c1}             .,:cccccccc:,.              %s")
		;;

		"Chakra")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light blue') # Light Blue
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			logowidth="38"
			fulloutput=(
"${c1}      _ _ _        \"kkkkkkkk.         %s"
"${c1}    ,kkkkkkkk.,    \'kkkkkkkkk,        %s"
"${c1}    ,kkkkkkkkkkkk., \'kkkkkkkkk.       %s"
"${c1}   ,kkkkkkkkkkkkkkkk,\'kkkkkkkk,       %s"
"${c1}  ,kkkkkkkkkkkkkkkkkkk\'kkkkkkk.       %s"
"${c1}   \"\'\'\"\'\'\',;::,,\"\'\'kkk\'\'kkkkk;   __   %s"
"${c1}       ,kkkkkkkkkk, \"k\'\'kkkkk\' ,kkkk  %s"
"${c1}     ,kkkkkkk\' ., \' .: \'kkkk\',kkkkkk  %s"
"${c1}   ,kkkkkkkk\'.k\'   ,  ,kkkk;kkkkkkkkk %s"
"${c1}  ,kkkkkkkk\';kk \'k  \"\'k\',kkkkkkkkkkkk %s"
"${c1} .kkkkkkkkk.kkkk.\'kkkkkkkkkkkkkkkkkk\' %s"
"${c1} ;kkkkkkkk\'\'kkkkkk;\'kkkkkkkkkkkkk\'\'   %s"
"${c1} \'kkkkkkk; \'kkkkkkkk.,\"\"\'\'\"\'\'\"\"       %s"
"${c1}   \'\'kkkk;  \'kkkkkkkkkk.,             %s"
"${c1}      \';\'    \'kkkkkkkkkkkk.,          %s"
"${c1}              ';kkkkkkkkkk\'           %s"
"${c1}                ';kkkkkk\'             %s"
"${c1}                   \"\'\'\"               %s")
		;;

		"Fuduntu")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'dark grey') # Dark Gray
				c2=$(getColor 'yellow') # Bold Yellow
				c3=$(getColor 'light red') # Light Red
				c4=$(getColor 'white') # White
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; c3="${my_lcolor}"; c4="${my_lcolor}"; fi
			startline="1"
			logowidth="49"
			fulloutput=(
"${c1}       \`dwoapfjsod\`${c2}           \`dwoapfjsod\`       "
"${c1}    \`xdwdsfasdfjaapz\`${c2}       \`dwdsfasdfjaapzx\`    %s"
"${c1}  \`wadladfladlafsozmm\`${c2}     \`wadladfladlafsozmm\`  %s"
"${c1} \`aodowpwafjwodisosoaas\`${c2} \`odowpwafjwodisosoaaso\` %s"
"${c1} \`adowofaowiefawodpmmxs\`${c2} \`dowofaowiefawodpmmxso\` %s"
"${c1} \`asdjafoweiafdoafojffw\`${c2} \`sdjafoweiafdoafojffwq\` %s"
"${c1}  \`dasdfjalsdfjasdlfjdd\`${c2} \`asdfjalsdfjasdlfjdda\`  %s"
"${c1}   \`dddwdsfasdfjaapzxaw\`${c2} \`ddwdsfasdfjaapzxawo\`   %s"
"${c1}     \`dddwoapfjsowzocmw\`${c2} \`ddwoapfjsowzocmwp\`     %s"
"${c1}       \`ddasowjfowiejao\`${c2} \`dasowjfowiejaow\`       %s"
"${c1}                                                 %s"
"${c3}       \`ddasowjfowiejao\`${c4} \`dasowjfowiejaow\`       %s"
"${c3}     \`dddwoapfjsowzocmw\`${c4} \`ddwoapfjsowzocmwp\`     %s"
"${c3}   \`dddwdsfasdfjaapzxaw\`${c4} \`ddwdsfasdfjaapzxawo\`   %s"
"${c3}  \`dasdfjalsdfjasdlfjdd\`${c4} \`asdfjalsdfjasdlfjdda\`  %s"
"${c3} \`asdjafoweiafdoafojffw\`${c4} \`sdjafoweiafdoafojffwq\` %s"
"${c3} \`adowofaowiefawodpmmxs\`${c4} \`dowofaowiefawodpmmxso\` %s"
"${c3} \`aodowpwafjwodisosoaas\`${c4} \`odowpwafjwodisosoaaso\` %s"
"${c3}   \`wadladfladlafsozmm\`${c4}     \`wadladfladlafsozmm\` %s"
"${c3}     \`dwdsfasdfjaapzx\`${c4}       \`dwdsfasdfjaapzx\`   %s"
"${c3}        \`woapfjsod\`${c4}             \`woapfjsod\`      %s")
		;;

		"Zorin OS")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light blue') # Light Blue
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			fulloutput=(
"${c1}           ...................          %s"
"${c1}          :ooooooooooooooooooo/         %s"
"${c1}         /ooooooooooooooooooooo+        %s"
"${c1}        ''''''''''''''''''''''''        %s"
"${c1}                                        %s"
"${c1}    .++++++++++++++++++/.       :++-    %s"
"${c1}   -oooooooooooooooo/-       :+ooooo:   %s"
"${c1}  :oooooooooooooo/-       :+ooooooooo:  %s"
"${c1} .oooooooooooo+-       :+ooooooooooooo- %s"
"${c1}  -oooooooo/-       -+ooooooooooooooo:  %s"
"${c1}   .oooo+-       -+ooooooooooooooooo-   %s"
"${c1}    .--        .-------------------.    %s"
"${c1}                                        %s"
"${c1}        .//////////////////////-        %s"
"${c1}         :oooooooooooooooooooo/         %s"
"${c1}          :oooooooooooooooooo:          %s"
"${c1}           ''''''''''''''''''           %s")
		;;

		"Mac OS X"|"macOS")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'green') # Green
				c2=$(getColor 'brown') # Yellow
				c3=$(getColor 'light red') # Orange
				c4=$(getColor 'red') # Red
				c5=$(getColor 'purple') # Purple
				c6=$(getColor 'blue') # Blue
			fi
			if [ -n "${my_lcolor}" ]; then
				c1="${my_lcolor}"
				c2="${my_lcolor}"
				c3="${my_lcolor}"
				c4="${my_lcolor}"
				c5="${my_lcolor}"
				c6="${my_lcolor}"
			fi
			startline="1"
			logowidth="31"
			fulloutput=(
"${c1}                               "
"${c1}                 -/+:.         %s"
"${c1}                :++++.         %s"
"${c1}               /+++/.          %s"
"${c1}       .:-::- .+/:-\`\`.::-      %s"
"${c1}    .:/++++++/::::/++++++/:\`   %s"
"${c2}  .:///////////////////////:\`  %s"
"${c2}  ////////////////////////\`    %s"
"${c3} -+++++++++++++++++++++++\`     %s"
"${c3} /++++++++++++++++++++++/      %s"
"${c4} /sssssssssssssssssssssss.     %s"
"${c4} :ssssssssssssssssssssssss-    %s"
"${c5}  osssssssssssssssssssssssso/\` %s"
"${c5}  \`syyyyyyyyyyyyyyyyyyyyyyyy+\` %s"
"${c6}   \`ossssssssssssssssssssss/   %s"
"${c6}     :ooooooooooooooooooo+.    %s"
"${c6}      \`:+oo+/:-..-:/+o+/-      %s"
"${c6}                               %s")
		;;

		"Mac OS X - Classic")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'blue') # Blue
				c2=$(getColor 'light blue') # Light blue
				c3=$(getColor 'light grey') # Gray
				c4=$(getColor 'dark grey') # Dark Ggray
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; c3="${my_lcolor}"; c4="${my_lcolor}"; fi
			startline="1"
			logowidth="39"
			fulloutput=(
"${c3}                                       "
"${c3}                        ..             %s"
"${c3}                       dWc             %s"
"${c3}                     ,X0'              %s"
"${c1}  ;;;;;;;;;;;;;;;;;;${c3}0Mk${c2}::::::::::::::: %s"
"${c1}  ;;;;;;;;;;;;;;;;;${c3}KWo${c2}:::::::::::::::: %s"
"${c1}  ;;;;;;;;;${c4}NN${c1};;;;;${c3}KWo${c2}:::::${c3}NN${c2}:::::::::: %s"
"${c1}  ;;;;;;;;;${c4}NN${c1};;;;${c3}0Md${c2}::::::${c3}NN${c2}:::::::::: %s"
"${c1}  ;;;;;;;;;${c4}NN${c1};;;${c3}xW0${c2}:::::::${c3}NN${c2}:::::::::: %s"
"${c1}  ;;;;;;;;;;;;;;${c3}KMc${c2}::::::::::::::::::: %s"
"${c1}  ;;;;;;;;;;;;;${c3}lWX${c2}:::::::::::::::::::: %s"
"${c1}  ;;;;;;;;;;;;;${c3}xWWXXXXNN7${c2}::::::::::::: %s"
"${c1}  ;;;;;;;;;;;;;;;;;;;;${c3}WK${c2}:::::::::::::: %s"
"${c1}  ;;;;;${c4}TKX0ko.${c1};;;;;;;${c3}kMx${c2}:::${c3}.cOKNF${c2}::::: %s"
"${c1}  ;;;;;;;;${c4}\`kO0KKKKKKK${c3}NMNXK0OP*${c2}:::::::: %s"
"${c1}  ;;;;;;;;;;;;;;;;;;;${c3}kMx${c2}:::::::::::::: %s"
"${c1}  ;;;;;;;;;;;;;;;;;;;;${c3}WX${c2}:::::::::::::: %s"
"${c3}                      lMc              %s"
"${c3}                       kN.             %s"
"${c3}                        o'             %s"
"${c3}                                       %s")
		;;

		"Windows"|"Cygwin"|"Msys")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light red') # Red
				c2=$(getColor 'light green') # Green
				c3=$(getColor 'light blue') # Blue
				c4=$(getColor 'yellow') # Yellow
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; c3="${my_lcolor}"; c4="${my_lcolor}"; fi
			startline="0"
			logowidth="37"
			fulloutput=(
"${c1}        ,.=:!!t3Z3z.,                %s"
"${c1}       :tt:::tt333EE3                %s"
"${c1}       Et:::ztt33EEEL${c2} @Ee.,      .., %s"
"${c1}      ;tt:::tt333EE7${c2} ;EEEEEEttttt33# %s"
"${c1}     :Et:::zt333EEQ.${c2} \$EEEEEttttt33QL %s"
"${c1}     it::::tt333EEF${c2} @EEEEEEttttt33F  %s"
"${c1}    ;3=*^\`\`\`\"*4EEV${c2} :EEEEEEttttt33@.  %s"
"${c3}    ,.=::::!t=., ${c1}\`${c2} @EEEEEEtttz33QF   %s"
"${c3}   ;::::::::zt33)${c2}   \"4EEEtttji3P*    %s"
"${c3}  :t::::::::tt33.${c4}:Z3z..${c2}  \`\`${c4} ,..g.    %s"
"${c3}  i::::::::zt33F${c4} AEEEtttt::::ztF     %s"
"${c3} ;:::::::::t33V${c4} ;EEEttttt::::t3      %s"
"${c3} E::::::::zt33L${c4} @EEEtttt::::z3F      %s"
"${c3}{3=*^\`\`\`\"*4E3)${c4} ;EEEtttt:::::tZ\`      %s"
"${c3}             \`${c4} :EEEEtttt::::z7       %s"
"${c4}                 \"VEzjt:;;z>*\`       %s")
		;;

		"Windows - Modern")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light blue') # Blue
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			logowidth="38"
			fulloutput=(
"${c1}                                  .., %s"
"${c1}                      ....,,:;+ccllll %s"
"${c1}        ...,,+:;  cllllllllllllllllll %s"
"${c1}  ,cclllllllllll  lllllllllllllllllll %s"
"${c1}  llllllllllllll  lllllllllllllllllll %s"
"${c1}  llllllllllllll  lllllllllllllllllll %s"
"${c1}  llllllllllllll  lllllllllllllllllll %s"
"${c1}  llllllllllllll  lllllllllllllllllll %s"
"${c1}  llllllllllllll  lllllllllllllllllll %s"
"${c1}                                      %s"
"${c1}  llllllllllllll  lllllllllllllllllll %s"
"${c1}  llllllllllllll  lllllllllllllllllll %s"
"${c1}  llllllllllllll  lllllllllllllllllll %s"
"${c1}  llllllllllllll  lllllllllllllllllll %s"
"${c1}  llllllllllllll  lllllllllllllllllll %s"
"${c1}  \`'ccllllllllll  lllllllllllllllllll %s"
"${c1}         \`'\"\"*::  :ccllllllllllllllll %s"
"${c1}                        \`\`\`\`''\"*::cll %s"
"${c1}                                   \`\` %s")
		;;

		"Haiku")
			if [[ "$no_color" != "1" ]]; then
				if [ "$haikualpharelease" == "yes" ]; then
					c1=$(getColor 'black_haiku') # Black
					c2=$(getColor 'light grey') # Light Gray
				else
					c1=$(getColor 'black') # Black
					c2=${c1}
				fi
				c3=$(getColor 'green') # Green
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; c3="${my_lcolor}"; fi
			startline="0"
			logowidth="36"
			fulloutput=(
"${c1}          :dc'                      %s"
"${c1}       'l:;'${c2},${c1}'ck.    .;dc:.         %s"
"${c1}       co    ${c2}..${c1}k.  .;;   ':o.       %s"
"${c1}       co    ${c2}..${c1}k. ol      ${c2}.${c1}0.       %s"
"${c1}       co    ${c2}..${c1}k. oc     ${c2}..${c1}0.       %s"
"${c1}       co    ${c2}..${c1}k. oc     ${c2}..${c1}0.       %s"
"${c1}.Ol,.  co ${c2}...''${c1}Oc;kkodxOdddOoc,.    %s"
"${c1} ';lxxlxOdxkxk0kd${c3}oooll${c1}dl${c3}ccc:${c1}clxd;   %s"
"${c1}     ..${c3}oOolllllccccccc:::::${c1}od;      %s"
"${c1}       cx:ooc${c3}:::::::;${c1}cooolcX.       %s"
"${c1}       cd${c2}.${c1}''cloxdoollc' ${c2}...${c1}0.       %s"
"${c1}       cd${c2}......${c1}k;${c2}.${c1}xl${c2}....  .${c1}0.       %s"
"${c1}       .::c${c2};..${c1}cx;${c2}.${c1}xo${c2}..... .${c1}0.       %s"
"${c1}          '::c'${c2}...${c1}do${c2}..... .${c1}K,       %s"
"${c1}                  cd,.${c2}....:${c1}O,${c2}...... %s"
"${c1}                    ':clod:'${c2}......  %s"
"${c1}                        ${c2}.           %s")
		;;

		"Trisquel")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light blue') # Light Blue
				c2=$(getColor 'light cyan') # Blue
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="38"
			fulloutput=(
"${c1}                          ▄▄▄▄▄▄      %s"
"${c1}                       ▄█████████▄    %s"
"${c1}       ▄▄▄▄▄▄         ████▀   ▀████   %s"
"${c1}    ▄██████████▄     ████▀   ▄▄ ▀███  %s"
"${c1}  ▄███▀▀   ▀▀████     ███▄   ▄█   ███ %s"
"${c1} ▄███   ▄▄▄   ████▄    ▀██████   ▄███ %s"
"${c1} ███   █▀▀██▄  █████▄     ▀▀   ▄████  %s"
"${c1} ▀███      ███  ███████▄▄  ▄▄██████   %s"
"${c1}  ▀███▄   ▄███  █████████████${c2}████▀    %s"
"${c1}   ▀█████████    ███████${c2}███▀▀▀        %s"
"${c1}     ▀▀███▀▀     ██${c2}████▀▀             %s"
"${c2}                ██████▀   ▄▄▄▄        %s"
"${c2}               █████▀   ████████      %s"
"${c2}               █████   ███▀  ▀███     %s"
"${c2}                ████▄   ██▄▄▄  ███    %s"
"${c2}                 █████▄   ▀▀  ▄██     %s"
"${c2}                   ██████▄▄▄████      %s"
"${c2}		              █████▀▀       %s")
		;;

		"Manjaro")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light green') # Green
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="1"
			logowidth="33"
			fulloutput=(""
"${c1} ██████████████████  ████████    %s"
"${c1} ██████████████████  ████████    %s"
"${c1} ██████████████████  ████████    %s"
"${c1} ██████████████████  ████████    %s"
"${c1} ████████            ████████    %s"
"${c1} ████████  ████████  ████████    %s"
"${c1} ████████  ████████  ████████    %s"
"${c1} ████████  ████████  ████████    %s"
"${c1} ████████  ████████  ████████    %s"
"${c1} ████████  ████████  ████████    %s"
"${c1} ████████  ████████  ████████    %s"
"${c1} ████████  ████████  ████████    %s"
"${c1} ████████  ████████  ████████    %s"
"${c1} ████████  ████████  ████████    %s"
"                                 %s")
		;;

		"Netrunner")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light blue') # Blue
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			logowidth="43"
			fulloutput=(
"${c1} nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn  %s"
"${c1} nnnnnnnnnnnnnn            nnnnnnnnnnnnnn  %s"
"${c1} nnnnnnnnnn     nnnnnnnnnn     nnnnnnnnnn  %s"
"${c1} nnnnnnn   nnnnnnnnnnnnnnnnnnnn   nnnnnnn  %s"
"${c1} nnnn   nnnnnnnnnnnnnnnnnnnnnnnnnn   nnnn  %s"
"${c1} nnn  nnnnnnnnnnnnnnnnnnnnnnnnnnnnnn  nnn  %s"
"${c1} nn  nnnnnnnnnnnnnnnnnnnnnn  nnnnnnnn  nn  %s"
"${c1} n  nnnnnnnnnnnnnnnnn       nnnnnnnnnn  n  %s"
"${c1} n nnnnnnnnnnn              nnnnnnnnnnn n  %s"
"${c1} n nnnnnn                  nnnnnnnnnnnn n  %s"
"${c1} n nnnnnnnnnnn             nnnnnnnnnnnn n  %s"
"${c1} n nnnnnnnnnnnnn           nnnnnnnnnnnn n  %s"
"${c1} n nnnnnnnnnnnnnnnn       nnnnnnnnnnnnn n  %s"
"${c1} n nnnnnnnnnnnnnnnnn      nnnnnnnnnnnnn n  %s"
"${c1} n nnnnnnnnnnnnnnnnnn    nnnnnnnnnnnn   n  %s"
"${c1} nn  nnnnnnnnnnnnnnnnn   nnnnnnnnnnnn  nn  %s"
"${c1} nnn   nnnnnnnnnnnnnnn  nnnnnnnnnnn   nnn  %s"
"${c1} nnnnn   nnnnnnnnnnnnnn nnnnnnnnn   nnnnn  %s"
"${c1} nnnnnnn   nnnnnnnnnnnnnnnnnnnn   nnnnnnn  %s"
"${c1} nnnnnnnnnn     nnnnnnnnnn     nnnnnnnnnn  %s"
"${c1} nnnnnnnnnnnnnn            nnnnnnnnnnnnnn  %s"
"${c1} nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn  %s"
"${c1}                                           %s")
		;;

			"Logos")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'green') # Green
			fi
            if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			logowidth="25"
			fulloutput=(
"${c1}    ..:.:.               %s"
"${c1}   ..:.:.:.:.            %s"
"${c1}  ..:.:.:.:.:.:.         %s"
"${c1} ..:.:.:.:.:.:.:.:.      %s"
"${c1}   .:.::;.::::..:.:.:.   %s"
"${c1}      .:.:.::.::.::.;;/  %s"
"${c1}         .:.::.::://///  %s"
"${c1}            ..;;///////  %s"
"${c1}            ///////////  %s"
"${c1}         //////////////  %s"
"${c1}      /////////////////  %s"
"${c1}   ///////////////////   %s"
"${c1} //////////////////      %s"
"${c1}  //////////////         %s"
"${c1}   //////////            %s"
"${c1}    //////               %s"
"${c1}     //                  %s")
		;;

			"Manjaro-tree")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;32m" # Green
				c2="\e[1;33m" # Yellow
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="33"
			fulloutput=(
"${c1}                         ###     %s"
"${c1}     ###             ####        %s"
"${c1}        ###       ####           %s"
"${c1}         ##### #####             %s"
"${c1}      #################          %s"
"${c1}    ###     #####    ####        %s"
"${c1}   ##        ${c2}OOO       ${c1}###       %s"
"${c1}  #          ${c2}WW         ${c1}##       %s"
"${c1}            ${c2}WW            ${c1}#      %s"
"${c2}            WW                   %s"
"${c2}            WW                   %s"
"${c2}           WW                    %s"
"${c2}           WW                    %s"
"${c2}           WW                    %s"
"${c2}          WW                     %s"
"${c2}          WW                     %s"
"${c2}          WW                     %s"
"${c2}                                 %s")
		;;

		"elementary OS"|"elementary os")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'white') # White
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			logowidth="36"
			fulloutput=(
"${c1}                                    %s"
"${c1}         eeeeeeeeeeeeeeeee          %s"
"${c1}      eeeeeeeeeeeeeeeeeeeeeee       %s"
"${c1}    eeeee  eeeeeeeeeeee   eeeee     %s"
"${c1}  eeee   eeeee       eee     eeee   %s"
"${c1} eeee   eeee          eee     eeee  %s"
"${c1}eee    eee            eee       eee %s"
"${c1}eee   eee            eee        eee %s"
"${c1}ee    eee           eeee       eeee %s"
"${c1}ee    eee         eeeee      eeeeee %s"
"${c1}ee    eee       eeeee      eeeee ee %s"
"${c1}eee   eeee   eeeeee      eeeee  eee %s"
"${c1}eee    eeeeeeeeee     eeeeee    eee %s"
"${c1} eeeeeeeeeeeeeeeeeeeeeeee    eeeee  %s"
"${c1}  eeeeeeee eeeeeeeeeeee      eeee   %s"
"${c1}    eeeee                 eeeee     %s"
"${c1}      eeeeeee         eeeeeee       %s"
"${c1}         eeeeeeeeeeeeeeeee          %s")
	;;

		"Android")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light green') # Bold Green
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="2"
			logowidth="24"
			fulloutput=(
"${c1}       ╲ ▁▂▂▂▁ ╱        "
"${c1}       ▄███████▄        "
"${c1}      ▄██ ███ ██▄       %s"
"${c1}     ▄███████████▄      %s"
"${c1}  ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄ █▄   %s"
"${c1}  ██ █████████████ ██   %s"
"${c1}  ██ █████████████ ██   %s"
"${c1}  ██ █████████████ ██   %s"
"${c1}  ██ █████████████ ██   %s"
"${c1}     █████████████      %s"
"${c1}      ███████████       %s"
"${c1}       ██     ██        %s"
"${c1}       ██     ██        %s")
		;;

		"Scientific Linux")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light blue')
				c2=$(getColor 'light red')
				c3=$(getColor 'white')
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; c3="${my_lcolor}"; fi
			startline="1"
			logowidth="44"
			fulloutput=(
"${c1}                  =/;;/-                    "
"${c1}                 +:    //                   %s"
"${c1}                /;      /;                  %s"
"${c1}               -X        H.                 %s"
"${c1} .//;;;:;;-,   X=        :+   .-;:=;:;#;.   %s"
"${c1} M-       ,=;;;#:,      ,:#;;:=,       ,@   %s"
"${c1} :#           :#.=/++++/=.$=           #=   %s"
"${c1}  ,#;         #/:+/;,,/++:+/         ;+.    %s"
"${c1}    ,+/.    ,;@+,        ,#H;,    ,/+,      %s"
"${c1}       ;+;;/= @.  ${c2}.H${c3}#${c2}#X   ${c1}-X :///+;         %s"
"${c1}       ;+=;;;.@,  ${c3}.X${c2}M${c3}@$.  ${c1}=X.//;=#/.        %s"
"${c1}    ,;:      :@#=        =\$H:     .+#-      %s"
"${c1}  ,#=         #;-///==///-//         =#,    %s"
"${c1} ;+           :#-;;;:;;;;-X-           +:   %s"
"${c1} @-      .-;;;;M-        =M/;;;-.      -X   %s"
"${c1}  :;;::;;-.    #-        :+    ,-;;-;:==    %s"
"${c1}               ,X        H.                 %s"
"${c1}                ;/      #=                  %s"
"${c1}                 //    +;                   %s"
"${c1}                  '////'                    %s")
		;;

		"BackTrack Linux")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'white') # White
				c2=$(getColor 'light red') # Light Red
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="1"
			logowidth="48"
			fulloutput=(
"${c1}..............                                  "
"${c1}            ..,;:ccc,.                          %s"
"${c1}          ......''';lxO.                        %s"
"${c1}.....''''..........,:ld;                        %s"
"${c1}           .';;;:::;,,.x,                       %s"
"${c1}      ..'''.            0Xxoc:,.  ...           %s"
"${c1}  ....                ,ONkc;,;cokOdc',.         %s"
"${c1} .                   OMo           ':${c2}dd${c1}o.       %s"
"${c1}                    dMc               :OO;      %s"
"${c1}                    0M.                 .:o.    %s"
"${c1}                    ;Wd                         %s"
"${c1}                     ;XO,                       %s"
"${c1}                       ,d0Odlc;,..              %s"
"${c1}                           ..',;:cdOOd::,.      %s"
"${c1}                                    .:d;.':;.   %s"
"${c1}                                       'd,  .'  %s"
"${c1}                                         ;l   ..%s"
"${c1}                                          .o    %s"
"${c1}                                            c   %s"
"${c1}                                            .'  %s"
"${c1}                                             .  %s")
		;;

		"Kali Linux")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light blue') # White
				c2=$(getColor 'black') # Light Red
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="1"
			logowidth="48"
			fulloutput=(
"${c1}..............                                  "
"${c1}            ..,;:ccc,.                          %s"
"${c1}          ......''';lxO.                        %s"
"${c1}.....''''..........,:ld;                        %s"
"${c1}           .';;;:::;,,.x,                       %s"
"${c1}      ..'''.            0Xxoc:,.  ...           %s"
"${c1}  ....                ,ONkc;,;cokOdc',.         %s"
"${c1} .                   OMo           ':${c2}dd${c1}o.       %s"
"${c1}                    dMc               :OO;      %s"
"${c1}                    0M.                 .:o.    %s"
"${c1}                    ;Wd                         %s"
"${c1}                     ;XO,                       %s"
"${c1}                       ,d0Odlc;,..              %s"
"${c1}                           ..',;:cdOOd::,.      %s"
"${c1}                                    .:d;.':;.   %s"
"${c1}                                       'd,  .'  %s"
"${c1}                                         ;l   ..%s"
"${c1}                                          .o    %s"
"${c1}                                            c   %s"
"${c1}                                            .'  %s"
"${c1}                                             .  %s")
		;;

		"Sabayon")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'white') # White
				c2=$(getColor 'light blue') # Blue
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="38"
			fulloutput=(
"${c2}            ...........               %s"
"${c2}         ..             ..            %s"
"${c2}      ..                   ..         %s"
"${c2}    ..           ${c1}o           ${c2}..       %s"
"${c2}  ..            ${c1}:W'            ${c2}..     %s"
"${c2} ..             ${c1}.d.             ${c2}..    %s"
"${c2}:.             ${c1}.KNO              ${c2}.:   %s"
"${c2}:.             ${c1}cNNN.             ${c2}.:   %s"
"${c2}:              ${c1}dXXX,              ${c2}:   %s"
"${c2}:   ${c1}.          dXXX,       .cd,   ${c2}:   %s"
"${c2}:   ${c1}'kc ..     dKKK.    ,ll;:'    ${c2}:   %s"
"${c2}:     ${c1}.xkkxc;..dkkkc',cxkkl       ${c2}:   %s"
"${c2}:.     ${c1}.,cdddddddddddddo:.       ${c2}.:   %s"
"${c2} ..         ${c1}:lllllll:           ${c2}..    %s"
"${c2}   ..         ${c1}',,,,,          ${c2}..      %s"
"${c2}     ..                     ..        %s"
"${c2}        ..               ..           %s"
"${c2}          ...............             %s")
		;;

		"KaOS")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light blue')
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			logowidth="35"
			fulloutput=(
"${c1}                     ..            %s"
"${c1}  .....         ..OSSAAAAAAA..     %s"
"${c1} .KKKKSS.     .SSAAAAAAAAAAA.      %s"
"${c1}.KKKKKSO.    .SAAAAAAAAAA...       %s"
"${c1}KKKKKKS.   .OAAAAAAAA.             %s"
"${c1}KKKKKKS.  .OAAAAAA.                %s"
"${c1}KKKKKKS. .SSAA..                   %s"
"${c1}.KKKKKS..OAAAAAAAAAAAA........     %s"
"${c1} DKKKKO.=AA=========A===AASSSO..   %s"
"${c1}  AKKKS.==========AASSSSAAAAAASS.  %s"
"${c1}  .=KKO..========ASS.....SSSSASSSS.%s"
"${c1}    .KK.       .ASS..O.. =SSSSAOSS:%s"
"${c1}     .OK.      .ASSSSSSSO...=A.SSA.%s"
"${c1}       .K      ..SSSASSSS.. ..SSA. %s"
"${c1}                 .SSS.AAKAKSSKA.   %s"
"${c1}                    .SSS....S..    %s")
		;;

		"CentOS")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'yellow')
				c2=$(getColor 'light green')
				c3=$(getColor 'light blue')
				c4=$(getColor 'light purple')
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; c3="${my_lcolor}"; c4="${my_lcolor}"; fi
			startline="0"
			logowidth="40"
			fulloutput=(
"${c1}                   ..                   %s"
"${c1}                 .PLTJ.                 %s"
"${c1}                <><><><>                %s"
"${c2}       KKSSV' 4KKK ${c1}LJ${c4} KKKL.'VSSKK       %s"
"${c2}       KKV' 4KKKKK ${c1}LJ${c4} KKKKAL 'VKK       %s"
"${c2}       V' ' 'VKKKK ${c1}LJ${c4} KKKKV' ' 'V       %s"
"${c2}       .4MA.' 'VKK ${c1}LJ${c4} KKV' '.4Mb.       %s"
"${c4}     . ${c2}KKKKKA.' 'V ${c1}LJ${c4} V' '.4KKKKK ${c3}.     %s"
"${c4}   .4D ${c2}KKKKKKKA.'' ${c1}LJ${c4} ''.4KKKKKKK ${c3}FA.   %s"
"${c4}  <QDD ++++++++++++  ${c3}++++++++++++ GFD>  %s"
"${c4}   'VD ${c3}KKKKKKKK'.. ${c2}LJ ${c1}..'KKKKKKKK ${c3}FV    %s"
"${c4}     ' ${c3}VKKKKK'. .4 ${c2}LJ ${c1}K. .'KKKKKV ${c3}'     %s"
"${c3}        'VK'. .4KK ${c2}LJ ${c1}KKA. .'KV'        %s"
"${c3}       A. . .4KKKK ${c2}LJ ${c1}KKKKA. . .4       %s"
"${c3}       KKA. 'KKKKK ${c2}LJ ${c1}KKKKK' .4KK       %s"
"${c3}       KKSSA. VKKK ${c2}LJ ${c1}KKKV .4SSKK       %s"
"${c2}                <><><><>                %s"
"${c2}                 'MKKM'                 %s"
"${c2}                   ''                   %s")
		;;

		"Jiyuu Linux")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light blue') # Light Blue
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			logowidth="31"
			fulloutput=(
"${c1}+++++++++++++++++++++++.       %s"
"${c1}ss:-......-+so/:----.os-       %s"
"${c1}ss        +s/        os-       %s"
"${c1}ss       :s+         os-       %s"
"${c1}ss       os.         os-       %s"
"${c1}ss      .so          os-       %s"
"${c1}ss      :s+          os-       %s"
"${c1}ss      /s/          os-       %s"
"${c1}ss      /s:          os-       %s"
"${c1}ss      +s-          os-       %s"
"${c1}ss-.....os:..........os-       %s"
"${c1}++++++++os+++++++++oooo.       %s"
"${c1}        os.     ./oo/.         %s"
"${c1}        os.   ./oo:            %s"
"${c1}        os. ./oo:              %s"
"${c1}        os oo+-                %s"
"${c1}        os+-                   %s"
"${c1}        /.                     %s")
		;;

		"Antergos")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'blue') # Light Blue
				c2=$(getColor 'light blue') # Light Blue
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="1"
			logowidth="41"
			fulloutput=(
"${c1}               \`.-/::/-\`\`                "
"${c1}            .-/osssssssso/.              %s"
"${c1}           :osyysssssssyyys+-            %s"
"${c1}        \`.+yyyysssssssssyyyyy+.          %s"
"${c1}       \`/syyyyyssssssssssyyyyys-\`        %s"
"${c1}      \`/yhyyyyysss${c2}++${c1}ssosyyyyhhy/\`        %s"
"${c1}     .ohhhyyyys${c2}o++/+o${c1}so${c2}+${c1}syy${c2}+${c1}shhhho.      %s"
"${c1}    .shhhhys${c2}oo++//+${c1}sss${c2}+++${c1}yyy${c2}+s${c1}hhhhs.     %s"
"${c1}   -yhhhhs${c2}+++++++o${c1}ssso${c2}+++${c1}yyy${c2}s+o${c1}hhddy:    %s"
"${c1}  -yddhhy${c2}o+++++o${c1}syyss${c2}++++${c1}yyy${c2}yooy${c1}hdddy-   %s"
"${c1} .yddddhs${c2}o++o${c1}syyyyys${c2}+++++${c1}yyhh${c2}sos${c1}hddddy\`  %s"
"${c1}\`odddddhyosyhyyyyyy${c2}++++++${c1}yhhhyosddddddo  %s"
"${c1}.dmdddddhhhhhhhyyyo${c2}+++++${c1}shhhhhohddddmmh. %s"
"${c1}ddmmdddddhhhhhhhso${c2}++++++${c1}yhhhhhhdddddmmdy %s"
"${c1}dmmmdddddddhhhyso${c2}++++++${c1}shhhhhddddddmmmmh %s"
"${c1}-dmmmdddddddhhys${c2}o++++o${c1}shhhhdddddddmmmmd- %s"
"${c1} .smmmmddddddddhhhhhhhhhdddddddddmmmms.  %s"
"${c1}   \`+ydmmmdddddddddddddddddddmmmmdy/.    %s"
"${c1}      \`.:+ooyyddddddddddddyyso+:.\`       %s")
		;;

		"Void Linux")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'green')       # Dark Green
				c2=$(getColor 'light green') # Light Green
				c3=$(getColor 'dark grey')   # Black
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; c3="${my_lcolor}"; fi
			startline="0"
			logowidth="47"
			fulloutput=(
"${c2}                 __.;=====;.__                 %s"
"${c2}             _.=+==++=++=+=+===;.              %s"
"${c2}              -=+++=+===+=+=+++++=_            %s"
"${c1}         .     ${c2}-=:\`\`     \`--==+=++==.          %s"
"${c1}        _vi,    ${c2}\`            --+=++++:         %s"
"${c1}       .uvnvi.       ${c2}_._       -==+==+.        %s"
"${c1}      .vvnvnI\`    ${c2}.;==|==;.     :|=||=|.       %s"
"${c3} +QmQQm${c1}pvvnv; ${c3}_yYsyQQWUUQQQm #QmQ#${c2}:${c3}QQQWUV\$QQmL %s"
"${c3}  -QQWQW${c1}pvvo${c3}wZ?.wQQQE${c2}==<${c3}QWWQ/QWQW.QQWW${c2}(: ${c3}jQWQE %s"
"${c3}   -\$QQQQmmU'  jQQQ@${c2}+=<${c3}QWQQ)mQQQ.mQQQC${c2}+;${c3}jWQQ@' %s"
"${c3}    -\$WQ8Y${c1}nI:   ${c3}QWQQwgQQWV${c2}\`${c3}mWQQ.jQWQQgyyWW@!   %s"
"${c1}      -1vvnvv.     ${c2}\`~+++\`        ++|+++        %s"
"${c1}       +vnvnnv,                 ${c2}\`-|===         %s"
"${c1}        +vnvnvns.           .      ${c2}:=-         %s"
"${c1}         -Invnvvnsi..___..=sv=.     ${c2}\`          %s"
"${c1}           +Invnvnvnnnnnnnnvvnn;.              %s"
"${c1}             ~|Invnvnvvnvvvnnv}+\`              %s"
"${c1}                -~\"|{*l}*|\"\"~                  %s")
		;;

		"NixOS")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'blue')
				c2=$(getColor 'light blue')
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="45"
			fulloutput=(
"${c1}          ::::.    ${c2}':::::     ::::'          %s"
"${c1}          ':::::    ${c2}':::::.  ::::'           %s"
"${c1}            :::::     ${c2}'::::.:::::            %s"
"${c1}      .......:::::..... ${c2}::::::::             %s"
"${c1}     ::::::::::::::::::. ${c2}::::::    ${c1}::::.     %s"
"${c1}    ::::::::::::::::::::: ${c2}:::::.  ${c1}.::::'     %s"
"${c2}           .....           ::::' ${c1}:::::'      %s"
"${c2}          :::::            '::' ${c1}:::::'       %s"
"${c2} ........:::::               ' ${c1}:::::::::::.  %s"
"${c2}:::::::::::::                 ${c1}:::::::::::::  %s"
"${c2} ::::::::::: ${c1}..              :::::           %s"
"${c2}     .::::: ${c1}.:::            :::::            %s"
"${c2}    .:::::  ${c1}:::::          '''''    ${c2}.....    %s"
"${c2}    :::::   ${c1}':::::.  ${c2}......:::::::::::::'    %s"
"${c2}     :::     ${c1}::::::. ${c2}':::::::::::::::::'     %s"
"${c1}            .:::::::: ${c2}'::::::::::            %s"
"${c1}           .::::''::::.     ${c2}'::::.           %s"
"${c1}          .::::'   ::::.     ${c2}'::::.          %s"
"${c1}         .::::      ::::      ${c2}'::::.         %s")
		;;

		"Guix System")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'orange')
				c2=$(getColor 'light orange')
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="40"
			fulloutput=(
"${c1} +                                    ? %s"
"${c1} ??                                  ?I %s"
"${c1}  ??I?   I??N              ${c2}???    ${c1}????  %s"
"${c1}   ?III7${c2}???????          ??????${c1}7III?Z   %s"
"${c1}     OI77\$${c2}?????         ?????${c1}$77IIII      %s"
"${c1}           ?????        ${c2}????            %s"
"${c1}            ???ID      ${c2}????             %s"
"${c1}             IIII     ${c2}+????             %s"
"${c1}             IIIII    ${c2}????              %s"
"${c1}              IIII   ${c2}?????              %s"
"${c1}              IIIII  ${c2}????               %s"
"${c1}               II77 ${c2}????$               %s"
"${c1}               7777+${c2}????                %s"
"${c1}                77++?${c2}??$                %s"
"${c1}                N?+???${c2}?                 %s")
			;;
		"BunsenLabs")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'blue')
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="5"
			logowidth="25"
			fulloutput=(
"${c1}            HC]          "
"${c1}          H]]]]          "
"${c1}        H]]]]]]4         "
"${c1}      @C]]]]]]]]*        "
"${c1}     @]]]]]]]]]]xd       "
"${c1}    @]]]]]]]]]]]]]d      %s"
"${c1}   0]]]]]]]]]]]]]]]]     %s"
"${c1}   kx]]]]]]x]]x]]]]]%%    %s"
"${c1}  #x]]]]]]]]]]]]]x]]]d   %s"
"${c1}  #]]]]]]qW  x]]x]]]]]4  %s"
"${c1}  k]x]]xg     %%x]]]]]]%%  %s"
"${c1}  Wx]]]W       x]]]]]]]  %s"
"${c1}  #]]]4         xx]]x]]  %s"
"${c1}   px]           ]]]]]x  %s"
"${c1}   Wx]           x]]x]]  %s"
"${c1}    &x           x]]]]   %s"
"${c1}     m           x]]]]   %s"
"${c1}                 x]x]    %s"
"${c1}                 x]]]    %s"
"${c1}                ]]]]     %s"
"${c1}                x]x      %s"
"${c1}               x]q       %s"
"${c1}               ]g        %s"
"${c1}              q          %s")
		;;

		"SteamOS")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'grey') # Gray
				c2=$(getColor 'purple') # Dark Purple
				c3=$(getColor 'light purple') # Light Purple
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; c3="${my_lcolor}"; fi
			startline="0"
			logowidth="37"
			fulloutput=(
"${c2}               .,,,,.                %s"
"${c2}         .,'onNMMMMMNNnn',.          %s"
"${c2}      .'oNM${c3}ANK${c2}MMMMMMMMMMMNNn'.       %s"
"${c3}    .'ANMMMMMMMXK${c2}NNWWWPFFWNNMNn.     %s"
"${c3}   ;NNMMMMMMMMMMNWW'' ${c2},.., 'WMMM,    %s"
"${c3}  ;NMMMMV+##+VNWWW' ${c3}.+;'':+, 'WM${c2}W,   %s"
"${c3} ,VNNWP+${c1}######${c3}+WW,  ${c1}+:    ${c3}:+, +MMM,  %s"
"${c3} '${c1}+#############,   +.    ,+' ${c3}+NMMM  %s"
"${c1}   '*#########*'     '*,,*' ${c3}.+NMMMM. %s"
"${c1}      \`'*###*'          ,.,;###${c3}+WNM, %s"
"${c1}          .,;;,      .;##########${c3}+W  %s"
"${c1} ,',.         ';  ,+##############'  %s"
"${c1}  '###+. :,. .,; ,###############'   %s"
"${c1}   '####.. \`'' .,###############'    %s"
"${c1}     '#####+++################'      %s"
"${c1}       '*##################*'        %s"
"${c1}          ''*##########*''           %s"
"${c1}               ''''''                %s")
		;;

		"SailfishOS")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'dark grey') # Grey
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			logowidth="32"
			fulloutput=(
"${c1}                 _a@b            %s"
"${c1}              _#b (b             %s"
"${c1}            _@@   @_         _,  %s"
"${c1}          _#^@ _#*^^*gg,aa@^^    %s"
"${c1}          #- @@^  _a@^^          %s"
"${c1}          @_  *g#b               %s"
"${c1}          ^@_   ^@_              %s"
"${c1}            ^@_   @              %s"
"${c1}             @(b (b              %s"
"${c1}            #b(b#^               %s"
"${c1}          _@_#@^                 %s"
"${c1}       _a@a*^                    %s"
"${c1}   ,a@*^                         %s")
		;;

		"Qubes OS")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'cyan')
				c2=$(getColor 'blue')
				c3=$(getColor 'light blue')
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; c3="${my_lcolor}"; fi
			startline="0"
			logowidth="47"
			fulloutput=(
"${c3}                      ####                     %s"
"${c3}                    ########                   %s"
"${c3}                  ############                 %s"
"${c3}                #######  #######               %s"
"${c1}              #${c3}######      ######${c2}#             %s"
"${c1}            ####${c3}###          ###${c2}####           %s"
"${c1}          ######        ${c2}        ######         %s"
"${c1}          ######        ${c2}        ######         %s"
"${c1}          ######        ${c2}        ######         %s"
"${c1}          ######        ${c2}        ######         %s"
"${c1}          ######        ${c2}        ######         %s"
"${c1}            #######     ${c2}     #######           %s"
"${c1}              #######   ${c2}   #########           %s"
"${c1}                ####### ${c2} ##############        %s"
"${c1}                  ######${c2}######  ######         %s"
"${c1}                    ####${c2}####     ###           %s"
"${c1}                      ##${c2}##                     %s"
"${c1}                                               %s")
		;;

		"PCLinuxOS")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'blue') # Blue
				c2=$(getColor 'light grey') # White
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			logowidth="50"
			fulloutput=(
"${c1}                                                  %s"
"${c1}                                             <NNN>%s"
"${c1}                                           <NNY   %s"
"${c1}                 <ooooo>--.               ((      %s"
"${c1}               Aoooooooooooo>--.           \\\\\\     %s"
"${c1}              AooodNNNNNNNNNNNNNNNN>--.     ))    %s"
"${c2}          (${c1}  AoodNNNNNNNNNNNNNNNNNNNNNNN>-///'    %s"
"${c2}          \\\\\\\\${c1}AodNNNNNNNNNNNNNNNNNNNNNNNNNNNY/      %s"
"${c1}           AodNNNNNNNNNNNNNNNNNNNNNNNNNNNNN       %s"
"${c1}          AdNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNA       %s"
"${c1}         (${c2}/)${c1}NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNA      %s"
"${c2}         //${c1}<NNNNNNNNNNNNNNNNNY'   YNNY YNNNN      %s"
"${c2} ,====#Y//${c1}   \`<NNNNNNNNNNNY       ANY     YNA     %s"
"${c1}               ANY<NNNNYYN       .NY        YN.   %s"
"${c1}             (NNY       NN      (NND       (NND   %s"
"${c1}                      (NNU                        %s"
"${c1}                                                  %s")
		;;

		"Exherbo")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'dark grey')  # Black
				c2=$(getColor 'light blue') # Blue
				c3=$(getColor 'light red')  # Beige
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; c3="${my_lcolor}"; fi
			startline="0"
			logowidth="46"
			fulloutput=(
"${c1}  ,                                           %s"
"${c1}  OXo.                                        %s"
"${c1}  NXdX0:    .cok0KXNNXXK0ko:.                 %s"
"${c1}  KX  '0XdKMMK;.xMMMk, .0MMMMMXx;  ...        %s"
"${c1}  'NO..xWkMMx   kMMM    cMMMMMX,NMWOxOXd.     %s"
"${c1}    cNMk  NK    .oXM.   OMMMMO. 0MMNo  kW.    %s"
"${c1}    lMc   o:       .,   .oKNk;   ;NMMWlxW'    %s"
"${c1}   ;Mc    ..   .,,'    .0M${c2}g;${c1}WMN'dWMMMMMMO     %s"
"${c1}   XX        ,WMMMMW.  cM${c2}cfli${c1}WMKlo.   .kMk    %s"
"${c1}  .Mo        .WM${c2}GD${c1}MW.   XM${c2}WO0${c1}MMk        oMl   %s"
"${c1}  ,M:         ,XMMWx::,''oOK0x;          NM.  %s"
"${c1}  'Ml      ,kNKOxxxxxkkO0XXKOd:.         oMk  %s"
"${c1}   NK    .0Nxc${c3}:::::::::::::::${c1}fkKNk,      .MW  %s"
"${c1}   ,Mo  .NXc${c3}::${c1}qXWXb${c3}::::::::::${c1}oo${c3}::${c1}lNK.    .MW  %s"
"${c1}    ;Wo oMd${c3}:::${c1}oNMNP${c3}::::::::${c1}oWMMMx${c3}:${c1}c0M;   lMO  %s"
"${c1}     'NO;W0c${c3}:::::::::::::::${c1}dMMMMO${c3}::${c1}lMk  .WM'  %s"
"${c1}       xWONXdc${c3}::::::::::::::${c1}oOOo${c3}::${c1}lXN. ,WMd   %s"
"${c1}        'KWWNXXK0Okxxo,${c3}:::::::${c1},lkKNo  xMMO    %s"
"${c1}          :XMNxl,';:lodxkOO000Oxc. .oWMMo     %s"
"${c1}            'dXMMXkl;,.        .,o0MMNo'      %s"
"${c1}               ':d0XWMMMMWNNNNMMMNOl'         %s"
"${c1}                     ':okKXWNKkl'             %s")
		;;

		"Red Star OS")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light red')  # Red
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			logowidth="45"
			fulloutput=(
"${c1}                      ..                     %s"
"${c1}                    .oK0l                    %s"
"${c1}                   :0KKKKd.                  %s"
"${c1}                 .xKO0KKKKd                  %s"
"${c1}                ,Od' .d0000l                 %s"
"${c1}               .c;.   .'''...           ..'. %s"
"${c1}  .,:cloddxxxkkkkOOOOkkkkkkkkxxxxxxxxxkkkx:  %s"
"${c1}  ;kOOOOOOOkxOkc'...',;;;;,,,'',;;:cllc:,.   %s"
"${c1}   .okkkkd,.lko  .......',;:cllc:;,,'''''.   %s"
"${c1}     .cdo. :xd' cd:.  ..';'',,,'',,;;;,'.    %s"
"${c1}        . .ddl.;doooc'..;oc;'..';::;,'.      %s"
"${c1}          coo;.oooolllllllcccc:'.  .         %s"
"${c1}         .ool''lllllccccccc:::::;.           %s"
"${c1}         ;lll. .':cccc:::::::;;;;'           %s"
"${c1}         :lcc:'',..';::::;;;;;;;,,.          %s"
"${c1}         :cccc::::;...';;;;;,,,,,,.          %s"
"${c1}         ,::::::;;;,'.  ..',,,,'''.          %s"
"${c1}          ........          ......           %s"
"${c1}                                             %s")
		;;

		"SparkyLinux")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light gray') # Gray
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			logowidth="48"
			fulloutput=(
"${c1}             .            \`-:-\`                %s"
"${c1}            .o\`       .-///-\`                  %s"
"${c1}           \`oo\`    .:/++:.                     %s"
"${c1}           os+\`  -/+++:\` \`\`.........\`\`\`        %s"
"${c1}          /ys+\`./+++/-.-::::::----......\`\`     %s"
"${c1}         \`syyo\`++o+--::::-::/+++/-\`\`           %s"
"${c1}         -yyy+.+o+\`:/:-:sdmmmmmmmmdy+-\`        %s"
"${c1}  ::-\`   :yyy/-oo.-+/\`ymho++++++oyhdmdy/\`      %s"
"${c1}  \`/yy+-\`.syyo\`+o..o--h..osyhhddhs+//osyy/\`    %s"
"${c1}    -ydhs+-oyy/.+o.-: \` \`  :/::+ydhy+\`\`\`-os-   %s"
"${c1}     .sdddy::syo--/:.     \`.:dy+-ohhho    ./:  %s"
"${c1}       :yddds/:+oo+//:-\`- /+ +hy+.shhy:     \`\` %s"
"${c1}        \`:ydmmdysooooooo-.ss\`/yss--oyyo        %s"
"${c1}          \`./ossyyyyo+:-/oo:.osso- .oys        %s"
"${c1}         \`\`..-------::////.-oooo/   :so        %s"
"${c1}      \`...----::::::::--.\`/oooo:    .o:        %s"
"${c1}             \`\`\`\`\`\`\`     ++o+:\`     \`:\`        %s"
"${c1}                       ./+/-\`        \`         %s"
"${c1}                     \`-:-.                     %s"
"${c1}                     \`\`                        %s")
		;;

		"Pardus")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'yellow') # Light Yellow
				c2=$(getColor 'light gray') # Light Gray
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="1"
			logowidth="45"
			fulloutput=(
""
"${c1}   .smNdy+-    \`.:/osyyso+:.\`    -+ydmNs.   %s"
"${c1}  /Md- -/ymMdmNNdhso/::/oshdNNmdMmy/. :dM/  %s"
"${c1}  mN.     oMdyy- -y          \`-dMo     .Nm  %s"
"${c1}  .mN+\`  sMy hN+ -:             yMs  \`+Nm.  %s"
"${c1}   \`yMMddMs.dy \`+\`               sMddMMy\`   %s"
"${c1}     +MMMo  .\`  .                 oMMM+     %s"
"${c1}     \`NM/    \`\`\`\`\`.\`    \`.\`\`\`\`\`    +MN\`     %s"
"${c1}     yM+   \`.-:yhomy    ymohy:-.\`   +My     %s"
"${c1}     yM:          yo    oy          :My     %s"
"${c1}     +Ms         .N\`    \`N.      +h sM+     %s"
"${c1}     \`MN      -   -::::::-   : :o:+\`NM\`     %s"
"${c1}      yM/    sh   -dMMMMd-   ho  +y+My      %s"
"${c1}      .dNhsohMh-//: /mm/ ://-yMyoshNd\`      %s"
"${c1}        \`-ommNMm+:/. oo ./:+mMNmmo:\`        %s"
"${c1}       \`/o+.-somNh- :yy: -hNmos-.+o/\`       %s"
"${c1}      ./\` .s/\`s+sMdd+\`\`+ddMs+s\`/s. \`/.      %s"
"${c1}          : -y.  -hNmddmNy.  .y- :          %s"
"${c1}           -+       \`..\`       +-           %s"
"%s")
		;;

		"Sulin")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light gray') # Light Yellow
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="1"
			logowidth="45"
			fulloutput=(
""
"${c1}             ++                    +++      %s"
"${c1}            ++::+                ++:+:      %s"
"${c1}            +:~:~:              +:~:~:+     %s"
"${c1}            +:~::~:+           +~:::::      %s"
"${c1}            +:~:::~~+:~.  ..~::.::+:~+      %s"
"${c1}             +~:::.             .::~:+      %s"
"${c1}             +::.            .   .~:+       %s"
"${c1}               :~:~+~..~ ~: ~++~++~+        %s"
"${c1}               :++++++++:++:+++++++:        %s"
"${c1}        ++++  +:+++.+++++++++++.+++:        %s"
"${c1}        :.  ~  :+++.+++++++++++~+++:        %s"
"${c1}        +~   .++++++++++   ++ ++++:+        %s"
"${c1}          +:  ~ :~+   +~+  ~+   +~+         %s"
"${c1}            ++:+++++           +++          %s"
"${c1}              +::~:++++++++++++++           %s"
"${c1}                 +++++++++++++++:           %s"
"${c1}                 +:++++++++++++::           %s"
"${c1}                 :.~+++:++:++++..+          %s"
"${c1}                 +~::++::+~::+:.+           %s"
"${c1}                  :~~~~~:+~:~~~:+           %s")
		;;

		"SwagArch")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'white') # White
				c2=$(getColor 'light blue') # Light Blue
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			logowidth="48"
			fulloutput=(
"${c1}                                               %s"
"${c1}          .;ldkOKXXNNNNXXK0Oxoc,.              %s"
"${c1}     ,lkXMMNK0OkkxkkOKWMMMMMMMMMM;             %s"
"${c1}   'K0xo  ..,;:c:.     \`'lKMMMMM0              %s"
"${c1}       .lONMMMMMM'         \`lNMk'              %s"
"${c1}      ;WMMMMMMMMMO.              ${c2}....::...     %s"
"${c1}      OMMMMMMMMMMMMKl.       ${c2}.,;;;;;ccccccc,   %s"
"${c1}      \`0MMMMMMMMMMMMMM0:         ${c2}.. .ccccccc.  %s"
"${c1}        'kWMMMMMMMMMMMMMNo.   ${c2}.,:'  .ccccccc.  %s"
"${c1}          \`c0MMMMMMMMMMMMMN,${c2},:c;    :cccccc:   %s"
"${c1}   ckl.      \`lXMMMMMMMMMX${c2}occcc:.. ;ccccccc.   %s"
"${c1}  dMMMMXd,     \`OMMMMMMWk${c2}ccc;:''\` ,ccccccc:    %s"
"${c1}  XMMMMMMMWKkxxOWMMMMMNo${c2}ccc;     .cccccccc.    %s"
"${c1}   \`':ldxO0KXXXXXK0Okdo${c2}cccc.     :cccccccc.    %s"
"${c2}                      :ccc:'     \`cccccccc:,   %s"
"${c2}                                     ''        %s"
"${c2}                                               %s")
		;;

		"EuroLinux")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light blue')
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}";fi;
			startline="0"
			logowidth="39"
			fulloutput=(

"${c1}                                       %s"
"${c1}           DZZZZZZZZZZZZZ              %s" 
"${c1}         ZZZZZZZZZZZZZZZZZZZ           %s"
"${c1}          ZZZZZZZZZZZZZZZZZZZZ         %s"
"${c1}           OZZZZZZZZZZZZZZZZZZZZ       %s"
"${c1}   Z         ZZZ    8ZZZZZZZZZZZZ      %s" 
"${c1}  ZZZ                   ZZZZZZZZZZ     %s"
"${c1} ZZZZZN                   ZZZZZZZZZ    %s"
"${c1} ZZZZZZZ                    ZZZZZZZZ   %s"
"${c1}ZZZZZZZZ                    OZZZZZZZ   %s"
"${c1}ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ  %s"
"${c1}ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ  %s"
"${c1}ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ  %s"
"${c1}ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ   %s"
"${c1}ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ    %s"
"${c1}ZZZZZZZZ                               %s"
"${c1} ZZZZZZZZ                              %s"
"${c1} OZZZZZZZZO                            %s"
"${c1}  ZZZZZZZZZZZ                          %s"
"${c1}   OZZZZZZZZZZZZZZZN                   %s"
"${c1}     ZZZZZZZZZZZZZZZZ                  %s"
"${c1}      DZZZZZZZZZZZZZZZ                 %s"
"${c1}         ZZZZZZZZZZZZZ                 %s"
"${c1}            NZZZZZZZZ                  %s"
"${c1}                                       %s")
		;;


		"OBRevenge")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'red') # White
				c2=$(getColor 'light blue') # Light Blue
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			logowidth="48"
			fulloutput=(
"${c1}       _@@@@   @@@g_      	%s"
"${c1}     _@@@@@@   @@@@@@     	%s"
"${c1}    _@@@@@@M   W@@@@@@_   	%s"
"${c1}   j@@@@P        ^W@@@@   	%s"
"${c1}   @@@@L____  _____Q@@@@  	%s"
"${c1}  Q@@@@@@@@@@j@@@@@@@@@@  	%s"
"${c1}  @@@@@    T@j@    T@@@@@	%s"
"${c1}  @@@@@ ___Q@J@    _@@@@@ 	%s"
"${c1}  @@@@@fMMM@@j@jggg@@@@@@ 	%s"
"${c1}  @@@@@    j@j@^MW@P @@@@ 	%s"
"${c1}  Q@@@@@ggg@@f@   @@@@@@L 	%s"
"${c1}  ^@@@@WWMMP  @    Q@@@@  	%s"
"${c1}   @@@@@_         _@@@@l  	%s"
"${c1}    W@@@@@g_____g@@@@@P   	%s"
"${c1}     @@@@@@@@@@@@@@@@l    	%s"
"${c1}      ^W@@@@@@@@@@@P      	%s"
"${c1}         ^TMMMMTll   		%s"
"${c1}                                  %s")
		;;

		"Parrot Security")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light blue') # Light Blue
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			logowidth="43"
			fulloutput=(
"${c1}    ,:oho/-.                              %s"
"${c1}   mMMMMMMMMMMMNmmdhy-                    %s"
"${c1}   dMMMMMMMMMMMMMMMMMMs.                  %s"
"${c1}   +MMsohNMMMMMMMMMMMMMm/                 %s"
"${c1}   .My   .+dMMMMMMMMMMMMMh.               %s"
"${c1}    +       :NMMMMMMMMMMMMNo              %s"
"${c1}             \`yMMMMMMMMMMMMMm:            %s"
"${c1}               /NMMMMMMMMMMMMMy.          %s"
"${c1}                .hMMMMMMMMMMMMMN+         %s"
"${c1}                    \`\`-NMMMMMMMMMd-       %s"
"${c1}                       /MMMMMMMMMMMs.     %s"
"${c1}                        mMMMMMMMsyNMN/    %s"
"${c1}                        +MMMMMMMo  :sNh.  %s"
"${c1}                        \`NMMMMMMm     -o/ %s"
"${c1}                         oMMMMMMM.        %s"
"${c1}                         \`NMMMMMM+        %s"
"${c1}                          +MMd/NMh        %s"
"${c1}                           mMm -mN\`       %s"
"${c1}                           /MM  \`h:       %s"
"${c1}                            dM\`   .       %s"
"${c1}                            :M-           %s"
"${c1}                             d:           %s"
"${c1}                             -+           %s"
"${c1}                              -           %s")
		;;

		"Amazon Linux")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light orange') # Orange
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			logowidth="40"
			fulloutput=(
"${c1}               .,:cc:,.              %s"
"${c1}          .:okXWMMMMMMWXko:.         %s"
"${c1}      .:kNMMMMMMMMMMMMMMMMMMNkc.     %s"
"${c1}   cc,.    \`':ox0XWWXOxo:'\`    .,c;  %s"
"${c1}   KMMMMXOdc,.    ''    .,cdOXWMMMO  %s"
"${c1}   KMMMMMMMMMMWXO.  .OXWMMMMMMMMMMO  %s"
"${c1}   KMMMMMMMMMMMMM,  ,MMMMMMMMMMMMMO  %s"
"${c1}   KMMMMMMMMMMMMM,  ,MMMMMMMMMMMMMO  %s"
"${c1}   KMMMMMMMMMMMMM,  ,MMMMMMMMMMMMMO  %s"
"${c1}   KMMMMMMMMMMMMM,  ,MMMMMMMMMMMMMO  %s"
"${c1}   KMMMMMMMMMMMMM,  ,MMMMMMMMMMMMMO  %s"
"${c1}   KMMMMMMMMMMMMM,  ,MMMMMMMMMMMMMk  %s"
"${c1}   KMMMMMMMMMMMMM,  ,MMMMMMMMMMMMMd  %s"
"${c1}   \`:lx0WMMMMMMMM,  ,MMMMMMMMW0xl:\`  %s"
"${c1}         \`'lx0NMM,  ,MMN0xc'\`        %s"
"${c1}               \`''  ''\`              %s")
		;;

		"Source Mage GNU/Linux")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'dark gray')
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="1"
			logowidth="40"
			fulloutput=(
"${c1}                              "
"${c1}       -sdNMNds:              %s"
"${c1} .shmNMMMMMMNNNNh.            %s"
"${c1}  \` \':sNNNNNNNNNNm-           %s"
"${c1}      .NNNNNNmmmmmdo.         %s"
"${c1}     -mNmmmmmmmmmmddd:        %s"
"${c1}     +mmmmmmmddddddddh-       %s"
"${c1}     :mmdddddddddhhhhhy.      %s"
"${c1}     -ddddddhhhhhhhhyyyo      %s"
"${c1}     .hyhhhhhhhyyyyyyyys:     %s"
"${c1}      .\`shyyyyyyyyyssssso     %s"
"${c1}        \`/yyyysssssssoooo.    %s"
"${c1}          .osssssooooo+++/    %s"
"${c1}           \`:+oooo+++++///.   %s"
"${c1}            \`://++//////::-   %s"
"${c1}        ..-///  .//::::::--.  %s"
"${c1}       \`\`\`\` \`\`\`  :::--------\` %s"
"${c1}                 \`------....\` %s"
"${c1}                  \`.........\` %s"
"${c1}                  \`......\` %s")
		;;

		"OS Elbrus")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'light blue') # Green
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="1"
			logowidth="33"
			fulloutput=(""
"${c1}   ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄   %s"
"${c1}   ██▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀██   %s"
"${c1}   ██                       ██   %s"
"${c1}   ██   ███████   ███████   ██   %s"
"${c1}   ██   ██   ██   ██   ██   ██   %s"
"${c1}   ██   ██   ██   ██   ██   ██   %s"
"${c1}   ██   ██   ██   ██   ██   ██   %s"
"${c1}   ██   ██   ██   ██   ██   ██   %s"
"${c1}   ██   ██   ███████   ███████   %s"
"${c1}   ██   ██                  ██   %s"
"${c1}   ██   ██▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄██   %s"
"${c1}   ██   ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀██   %s"
"${c1}   ██                       ██   %s"
"${c1}   ███████████████████████████   %s"
"                                 %s")
		;;

		"PureOS")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'dark grey') # "Black"
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="1"
			logowidth="44"
			fulloutput=(""
"                                            %s"
"${c1}  dmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmd  %s"
"${c1}  dNm//////////////////////////////////mNd  %s"
"${c1}  dNd                                  dNd  %s"
"${c1}  dNd                                  dNd  %s"
"${c1}  dNd                                  dNd  %s"
"${c1}  dNd                                  dNd  %s"
"${c1}  dNd                                  dNd  %s"
"${c1}  dNd                                  dNd  %s"
"${c1}  dNd                                  dNd  %s"
"${c1}  dNd                                  dNd  %s"
"${c1}  dNm//////////////////////////////////mNd  %s"
"${c1}  dmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmd  %s"
"                                            %s")
		;;

    "DraugerOS")
      if [[ "$no_color" != "1" ]]; then
        c1=$(getColor 'red') # red
      fi
      if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
      startline="0"
      logowidth="52"
      fulloutput=(
"${c1}                                                 %s"
"${c1}                      &   &                      %s"
"${c1}                     %(   (#                     %s"
"${c1}                    (((   (((                    %s"
"${c1}                   ((((   ((((                   %s"
"${c1}                  ((((     ((((                  %s"
"${c1}                 ((((       ((((                 %s"
"${c1}                ((((         ((((                %s"
"${c1}              %((((           ((((%              %s"
"${c1}             ((((               ((((             %s"
"${c1}            ((((                 ((((            %s"
"${c1}           ((((                   ((((           %s"
"${c1}         &((((                     ((((&         %s"
"${c1}        #((((                       ((((#        %s"
"${c1}       (((((                         (((((       %s"
"${c1}      ((((#                           #((((      %s"
"${c1}     (#  (((((((((((((((((((((((((((((((  #(     %s"
"${c1}       (((((((((((((((((((((((((((((((((((       %s"
"                                                      %s")
		;;

		"januslinux")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'white') # white
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="1"
			logowidth="25"
			fulloutput=(""
"                         %s"
"${c1}   ________________      %s"
"${c1}  |\               \     %s"
"${c1}  | \               \    %s"
"${c1}  |  \               \   %s"
"${c1}  |   \ ______________\  %s"
"${c1}  |    |              |  %s"
"${c1}  |    |              |  %s"
"${c1}  |    |              |  %s"
"${c1}   \   |  januslinux  |  %s"
"${c1}    \  |              |  %s"
"${c1}     \ |              |  %s"
"${c1}      \|______________|  %s"
"                         %s")
		;;
		"EndeavourOS")
			if [[ "$no_color" != "1" ]]; then
				c1=$(getColor 'yellow')
				c3=$(getColor 'purple')
				c5=$(getColor 'cyan')
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c3="${my_lcolor}"; c5="${my_lcolor}"; fi
			startline="1"
			logowidth="44"
			fulloutput=(""
"${c1}                  +${c3}I${c5}+		        %s"
"${c1}                 +${c3}777${c5}+                  %s"
"${c1}	        +${c3}77777${c5}++		%s"
"${c1}	       +${c3}7777777${c5}++		%s"
"${c1}	      +${c3}7777777777${c5}++		%s"
"${c1}	    ++${c3}7777777777777${c5}++		%s"
"${c1}	   ++${c3}777777777777777${c5}+++       	%s"
"${c1}	 ++${c3}77777777777777777${c5}++++        %s"
"${c1}	++${c3}7777777777777777777${c5}++++       %s"
"${c1}      +++${c3}777777777777777777777${c5}++++	%s"
"${c1}    ++++${c3}7777777777777777777777${c5}+++++  	%s"	
"${c1}   ++++${c3}77777777777777777777777${c5}+++++  	%s"	
"${c1}  +++++${c3}777777777777777777777777${c5}+++++	%s"	
"${c5}       +++++++${c3}7777777777777777${c5}++++++	%s"	
"${c5}      +++++++++++++++++++++++++++++     %s"
"${c5}     +++++++++++++++++++++++++++        %s"
"                                      	%s"
);;

		*)
			if [[ "${kernel}" =~ "Linux" ]]; then
				if [[ "$no_color" != "1" ]]; then
					c1=$(getColor 'white') # White
					c2=$(getColor 'dark grey') # Light Gray
					c3=$(getColor 'yellow') # Light Yellow
				fi
				if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; c3="${my_lcolor}"; fi
				startline="0"
				logowidth="28"
				fulloutput=(
"${c2}                            %s"
"${c2}                            %s"
"${c2}                            %s"
"${c2}         #####              %s"
"${c2}        #######             %s"
"${c2}        ##${c1}O${c2}#${c1}O${c2}##             %s"
"${c2}        #${c3}#####${c2}#             %s"
"${c2}      ##${c1}##${c3}###${c1}##${c2}##           %s"
"${c2}     #${c1}##########${c2}##          %s"
"${c2}    #${c1}############${c2}##         %s"
"${c2}    #${c1}############${c2}###        %s"
"${c3}   ##${c2}#${c1}###########${c2}##${c3}#        %s"
"${c3} ######${c2}#${c1}#######${c2}#${c3}######      %s"
"${c3} #######${c2}#${c1}#####${c2}#${c3}#######      %s"
"${c3}   #####${c2}#######${c3}#####        %s"
"${c2}                            %s"
"${c2}                            %s"
"${c2}                            %s")

			elif [[ "${kernel}" =~ "Hurd" || "${kernel}" =~ "GNU" || "${OSTYPE}" == "gnu" ]]; then
				if [[ "$no_color" != "1" ]]; then
					c1=$(getColor 'dark grey') # Light Gray
				fi
				if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
				startline="0"
				logowidth="37"
				fulloutput=(
"${c1}    _-\`\`\`\`\`-,           ,- '- .      %s"
"${c1}   .'   .- - |          | - -.  \`.   %s"
"${c1}  /.'  /                     \`.   \\  %s"
"${c1} :/   :      _...   ..._      \`\`   : %s"
"${c1} ::   :     /._ .\`:'_.._\\.    ||   : %s"
"${c1} ::    \`._ ./  ,\`  :    \\ . _.''   . %s"
"${c1} \`:.      /   |  -.  \\-. \\\\\_      /  %s"
"${c1}   \\:._ _/  .'   .@)  \\@) \` \`\\ ,.'   %s"
"${c1}      _/,--'       .- .\\,-.\`--\`.     %s"
"${c1}        ,'/''     (( \\ \`  )          %s"
"${c1}         /'/'  \\    \`-'  (           %s"
"${c1}          '/''  \`._,-----'           %s"
"${c1}           ''/'    .,---'            %s"
"${c1}            ''/'      ;:             %s"
"${c1}              ''/''  ''/             %s"
"${c1}                ''/''/''             %s"
"${c1}                  '/'/'              %s"
"${c1}                   \`;                %s")
# Source: https://www.gnu.org/graphics/alternative-ascii.en.html
# Copyright (C) 2003, Vijay Kumar
# Permission is granted to copy, distribute and/or modify this image under the
# terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.

			else
				if [[ "$no_color" != "1" ]]; then
					c1=$(getColor 'light green') # Light Green
				fi
				if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
				startline="0"
				logowidth="44"
				fulloutput=(
"${c1}                                            %s"
"${c1}                                            %s"
"${c1} UUU     UUU NNN      NNN IIIII XXX     XXXX%s"
"${c1} UUU     UUU NNNN     NNN  III    XX   xXX  %s"
"${c1} UUU     UUU NNNNN    NNN  III     XX xXX   %s"
"${c1} UUU     UUU NNN NN   NNN  III      XXXX    %s"
"${c1} UUU     UUU NNN  NN  NNN  III      xXX     %s"
"${c1} UUU     UUU NNN   NN NNN  III     xXXXX    %s"
"${c1} UUU     UUU NNN    NNNNN  III    xXX  XX   %s"
"${c1}  UUUuuuUUU  NNN     NNNN  III   xXX    XX  %s"
"${c1}    UUUUU    NNN      NNN IIIII xXXx    xXXx%s"
"${c1}                                            %s"
"${c1}                                            %s"
"${c1}                                            %s"
"${c1}                                            %s")
			fi
		;;
	esac


	# Truncate lines based on terminal width.
	if [ "$truncateSet" == "Yes" ]; then
		missinglines=$((${#out_array[*]} + startline - ${#fulloutput[*]}))
		for ((i=0; i<missinglines; i++)); do
			fulloutput+=("${c1}$(printf '%*s' "$logowidth")%s")
		done
		for ((i=0; i<${#fulloutput[@]}; i++)); do
			my_out=$(printf "${fulloutput[i]}$c0\n" "${out_array}")
			my_out_full=$(echo "$my_out" | cat -v)
			termWidth=$(tput cols)
			SHOPT_EXTGLOB_STATE=$(shopt -p extglob)
			read SHOPT_CMD SHOPT_STATE SHOPT_OPT <<< "${SHOPT_EXTGLOB_STATE}"
			if [[ ${SHOPT_STATE} == "-u" ]]; then
				shopt -s extglob
			fi

			stringReal="${my_out_full//\^\[\[@([0-9]|[0-9];[0-9][0-9])m}"

			if [[ ${SHOPT_STATE} == "-u" ]]; then
				shopt -u extglob
			fi

			if [[ "${#stringReal}" -le "${termWidth}" ]]; then
				echo -e "${my_out}"$c0
			elif [[ "${#stringReal}" -gt "${termWidth}" ]]; then
				((NORMAL_CHAR_COUNT=0))
				for ((j=0; j<=${#my_out_full}; j++)); do
					if [[ "${my_out_full:${j}:3}" == '^[[' ]]; then
						if [[ "${my_out_full:${j}:5}" =~ ^\^\[\[[[:digit:]]m$ ]]; then
							if [[ ${j} -eq 0 ]]; then
								j=$((j + 5))
							else
								j=$((j + 4))
							fi
						elif [[ "${my_out_full:${j}:8}" =~ ^\^\[\[[[:digit:]]\;[[:digit:]][[:digit:]]m ]]; then
							if [[ ${j} -eq 0 ]]; then
								j=$((j + 8))
							else
								j=$((j + 7))
							fi
						fi
					else
						((NORMAL_CHAR_COUNT++))
						if [[ ${NORMAL_CHAR_COUNT} -ge ${termWidth} ]]; then
							echo -e "${my_out:0:$((j - 5))}"$c0
							break 1
						fi
					fi
				done
			fi

			if [[ "$i" -ge "$startline" ]]; then
				unset 'out_array[0]'
				out_array=( "${out_array[@]}" )
			fi
		done
	elif [[ "$portraitSet" = "Yes" ]]; then
		for i in "${!fulloutput[@]}"; do
			printf "${fulloutput[$i]}$c0\n"
		done

		printf "\n"

		for ((i=0; i<${#fulloutput[*]}; i++)); do
			[[ -z "$out_array[0]" ]] && continue
			printf "%s\n" "${out_array[0]}"
			unset 'out_array[0]'
			out_array=( "${out_array[@]}" )
		done

	elif [[ "$display_logo" == "Yes" ]]; then
		for i in "${!fulloutput[@]}"; do
			printf "${fulloutput[i]}$c0\n"
		done
	else
		if [[ "$lineWrap" = "Yes" ]]; then
			availablespace=$(($(tput cols) - logowidth + 16)) #I dont know why 16 but it works
			new_out_array=("${out_array[0]}")
			for ((i=1; i<${#out_array[@]}; i++)); do
				lines=$(echo "${out_array[i]}" | fmt -w $availablespace)
				IFS=$'\n' read -rd '' -a splitlines <<<"$lines"
				new_out_array+=("${splitlines[0]}")
				for ((j=1; j<${#splitlines[*]}; j++)); do
					line=$(echo -e "$labelcolor $textcolor  ${splitlines[j]}")
					new_out_array=( "${new_out_array[@]}" "$line" );
				done
			done
			out_array=("${new_out_array[@]}")
		fi
		missinglines=$((${#out_array[*]} + startline - ${#fulloutput[*]}))
		for ((i=0; i<missinglines; i++)); do
			fulloutput+=("${c1}$(printf '%*s' "$logowidth")%s")
		done
		#n=${#fulloutput[*]}
		for ((i=0; i<${#fulloutput[*]}; i++)); do
			# echo "${out_array[@]}"
			case $(awk 'BEGIN{srand();print int(rand()*(1000-1))+1 }') in
				411|188|15|166|609)
					f_size=${#fulloutput[*]}
					o_size=${#out_array[*]}
					f_max=$(( 32768 / f_size * f_size ))
					#o_max=$(( 32768 / o_size * o_size ))
					for ((a=f_size-1; a>0; a--)); do
						while (( (rand=RANDOM) >= f_max )); do :; done
						rand=$(( rand % (a+1) ))
						tmp=${fulloutput[a]} fulloutput[a]=${fulloutput[rand]} fulloutput[rand]=$tmp
					done
					for ((b=o_size-1; b>0; b--)); do
						rand=$(( rand % (b+1) ))
						tmp=${out_array[b]} out_array[b]=${out_array[rand]} out_array[rand]=$tmp
					done
				;;
			esac
			printf "${fulloutput[i]}$c0\n" "${out_array[0]}"
			if [[ "$i" -ge "$startline" ]]; then
				unset 'out_array[0]'
				out_array=( "${out_array[@]}" )
			fi
		done
	fi
	# Done with ASCII output
}

infoDisplay () {
	textcolor="\033[0m"
	[[ "$my_hcolor" ]] && textcolor="${my_hcolor}"
	#TODO: Centralize colors and use them across the board so we only change them one place.
	myascii="${distro}"
	[[ "${asc_distro}" ]] && myascii="${asc_distro}"
	case ${myascii} in
		"Alpine Linux"|"Arch Linux - Old"|"ArcoLinux"|"blackPanther OS"|"Fedora"|"Korora"|"Chapeau"|"Mandriva"|"Mandrake"| \
		"Chakra"|"ChromeOS"|"Sabayon"|"Slackware"|"Mac OS X"|"macOS"|"Trisquel"|"Kali Linux"|"Jiyuu Linux"|"Antergos"| \
		"KaOS"|"Logos"|"gNewSense"|"Netrunner"|"NixOS"|"SailfishOS"|"Qubes OS"|"Kogaion"|"PCLinuxOS"| \
		"Obarun"|"Siduction"|"Solus"|"SwagArch"|"Parrot Security"|"Zorin OS")
			labelcolor=$(getColor 'light blue')
		;;
		"Arch Linux"|"Artix Linux"|"Frugalware"|"Mageia"|"Deepin"|"CRUX"|"OS Elbrus"|"EndeavourOS")
			labelcolor=$(getColor 'light cyan')
		;;
		"Mint"|"LMDE"|"KDE neon"|"openSUSE"|"SUSE Linux Enterprise"|"LinuxDeepin"|"DragonflyBSD"|"Manjaro"| \
		"Manjaro-tree"|"Android"|"Void Linux"|"DesaOS")
			labelcolor=$(getColor 'light green')
		;;
		"Ubuntu"|"FreeBSD"|"FreeBSD - Old"|"Debian"|"Raspbian"|"BSD"|"Red Hat Enterprise Linux"|"Oracle Linux"| \
		"Peppermint"|"Cygwin"|"Msys"|"Fuduntu"|"Scientific Linux"|"DragonFlyBSD"|"BackTrack Linux"|"Red Star OS"| \
		"SparkyLinux"|"OBRevenge"|"Source Mage GNU/Linux")
			labelcolor=$(getColor 'light red')
		;;
		"ROSA"|"januslinux")
			labelcolor=$(getColor 'white')
		;;
		"CrunchBang"|"Viperr"|"elementary"*)
			labelcolor=$(getColor 'dark grey')
		;;
		"Gentoo"|"Parabola GNU/Linux-libre"|"Funtoo"|"Funtoo-text"|"BLAG"|"SteamOS"|"Devuan")
			labelcolor=$(getColor 'light purple')
		;;
		"Haiku")
			labelcolor=$(getColor 'green')
		;;
		"NetBSD"|"Amazon Linux"|"Proxmox VE")
			labelcolor=$(getColor 'orange')
		;;
		"CentOS")
			labelcolor=$(getColor 'yellow')
		;;
		"Hyperbola GNU/Linux-libre"|"PureOS"|*)
			labelcolor=$(getColor 'light grey')
		;;
	esac
	[[ "$my_lcolor" ]] && labelcolor="${my_lcolor}"
	if [[ "$art" ]]; then
		source "$art"
	fi
	if [[ "$no_color" == "1" ]]; then
		labelcolor=""
		bold=""
		c0=""
		textcolor=""
	fi
	# Some verbosity stuff
	[[ "$screenshot" == "1" ]] && verboseOut "Screenshot will be taken after info is displayed."
	[[ "$upload" == "1" ]] && verboseOut "Screenshot will be transferred/uploaded to specified location."
	#########################
	# Info Variable Setting #
	#########################
	if [[ "${distro}" == "Android" ]]; then
		myhostname=$(echo -e "${labelcolor} ${hostname}"); out_array=( "${out_array[@]}" "$myhostname" )
		mydistro=$(echo -e "$labelcolor OS:$textcolor $distro $distro_ver"); out_array=( "${out_array[@]}" "$mydistro" )
		mydevice=$(echo -e "$labelcolor Device:$textcolor $device"); out_array=( "${out_array[@]}" "$mydevice" )
		myrom=$(echo -e "$labelcolor ROM:$textcolor $rom"); out_array=( "${out_array[@]}" "$myrom" )
		mybaseband=$(echo -e "$labelcolor Baseband:$textcolor $baseband"); out_array=( "${out_array[@]}" "$mybaseband" )
		mykernel=$(echo -e "$labelcolor Kernel:$textcolor $kernel"); out_array=( "${out_array[@]}" "$mykernel" )
		myuptime=$(echo -e "$labelcolor Uptime:$textcolor $uptime"); out_array=( "${out_array[@]}" "$myuptime" )
		mycpu=$(echo -e "$labelcolor CPU:$textcolor $cpu"); out_array=( "${out_array[@]}" "$mycpu" )
		mygpu=$(echo -e "$labelcolor GPU:$textcolor $cpu"); out_array=( "${out_array[@]}" "$mygpu" )
		mymem=$(echo -e "$labelcolor RAM:$textcolor $mem"); out_array=( "${out_array[@]}" "$mymem" )
	else
		if [[ "${display[@]}" =~ "host" ]]; then
			myinfo=$(echo -e "${labelcolor} ${myUser}$textcolor${bold}@${c0}${labelcolor}${myHost}")
			out_array=( "${out_array[@]}" "$myinfo" )
			((display_index++))
		fi
		if [[ "${display[@]}" =~ "distro" ]]; then
			if [[ "$distro" == "Mac OS X" || "$distro" == "macOS" ]]; then
				sysArch="$(getconf LONG_BIT)bit"
				prodVers=$(sw_vers | grep 'ProductVersion')
				prodVers=${prodVers:16}
				buildVers=$(sw_vers |grep 'BuildVersion')
				buildVers=${buildVers:14}
				if [ -n "$distro_more" ]; then
					mydistro=$(echo -e "$labelcolor OS:$textcolor $distro_more $sysArch")
				else
					mydistro=$(echo -e "$labelcolor OS:$textcolor $sysArch $distro $prodVers $buildVers")
				fi
			elif [[ "$distro" == "Cygwin" || "$distro" == "Msys" ]]; then
				distro="$(wmic os get caption | sed 's/\r//g; s/[ \t]*$//g; 2!d')"
				if [[ "$(wmic os get version | grep -o '^10\.')" == "10." ]]; then
					distro="$distro (v$(wmic os get version | grep '^10\.' | tr -d ' '))"
				fi
				sysArch=$(wmic os get OSArchitecture | sed 's/\r//g; s/[ \t]*$//g; 2!d')
				mydistro=$(echo -e "$labelcolor OS:$textcolor $distro $sysArch")
			else
				if [ -n "$distro_more" ]; then
					mydistro=$(echo -e "$labelcolor OS:$textcolor $distro_more")
				else
					mydistro=$(echo -e "$labelcolor OS:$textcolor $distro $sysArch")
				fi
			fi
			out_array=( "${out_array[@]}" "$mydistro$wsl" )
			((display_index++))
		fi
		if [[ "${display[@]}" =~ "kernel" ]]; then
			mykernel=$(echo -e "$labelcolor Kernel:$textcolor $kernel")
			out_array=( "${out_array[@]}" "$mykernel" )
			((display_index++))
		fi
		if [[ "${display[@]}" =~ "uptime" ]]; then
			myuptime=$(echo -e "$labelcolor Uptime:$textcolor $uptime")
			out_array=( "${out_array[@]}" "$myuptime" )
			((display_index++))
		fi
		if [[ "${display[@]}" =~ "pkgs" ]]; then
			mypkgs=$(echo -e "$labelcolor Packages:$textcolor $pkgs")
			out_array=( "${out_array[@]}" "$mypkgs" )
			((display_index++))
		fi
		if [[ "${display[@]}" =~ "shell" ]]; then
			myshell=$(echo -e "$labelcolor Shell:$textcolor $myShell")
			out_array=( "${out_array[@]}" "$myshell" )
			((display_index++))
		fi
		if [[ -n "$DISPLAY" || "$distro" == "Mac OS X" || "$distro" == "macOS" ]]; then
			if [ -n "${xResolution}" ]; then
				if [[ "${display[@]}" =~ "res" ]]; then
					myres=$(echo -e "$labelcolor Resolution:${textcolor} $xResolution")
					out_array=( "${out_array[@]}" "$myres" )
					((display_index++))
				fi
			fi
			if [[ "${display[@]}" =~ "de" ]]; then
				if [[ "${DE}" != "Not Present" ]]; then
					myde=$(echo -e "$labelcolor DE:$textcolor $DE")
					out_array=( "${out_array[@]}" "$myde" )
					((display_index++))
				fi
			fi
			if [[ "${display[@]}" =~ "wm" ]]; then
				mywm=$(echo -e "$labelcolor WM:$textcolor $WM")
				out_array=( "${out_array[@]}" "$mywm" )
				((display_index++))
			fi
			if [[ "${display[@]}" =~ "wmtheme" ]]; then
				if [[ "${Win_theme}" != "Not Applicable" && "${Win_theme}" != "Not Found" ]]; then
					mywmtheme=$(echo -e "$labelcolor WM Theme:$textcolor $Win_theme")
					out_array=( "${out_array[@]}" "$mywmtheme" )
					((display_index++))
				fi
			fi
			if [[ "${display[@]}" =~ "gtk" ]]; then
				if [[ "$distro" == "Mac OS X" || "$distro" == "macOS" ]]; then
					if [[ "$gtkFont" != "Not Applicable" && "$gtkFont" != "Not Found" ]]; then
						if [ -n "$gtkFont" ]; then
							myfont=$(echo -e "$labelcolor Font:$textcolor $gtkFont")
							out_array=( "${out_array[@]}" "$myfont" )
							((display_index++))
						fi
					fi
				else
					if [[ "$gtk2Theme" != "Not Applicable" && "$gtk2Theme" != "Not Found" ]]; then
						if [ -n "$gtk2Theme" ]; then
							mygtk2="${gtk2Theme} [GTK2]"
						fi
					fi
					if [[ "$gtk3Theme" != "Not Applicable" && "$gtk3Theme" != "Not Found" ]]; then
						if [ -n "$mygtk2" ]; then
							mygtk3=", ${gtk3Theme} [GTK3]"
						else
							mygtk3="${gtk3Theme} [GTK3]"
						fi
					fi
					if [[ "$gtk_2line" == "yes" ]]; then
						mygtk2=$(echo -e "$labelcolor GTK2 Theme:$textcolor $gtk2Theme")
						out_array=( "${out_array[@]}" "$mygtk2" )
						((display_index++))
						mygtk3=$(echo -e "$labelcolor GTK3 Theme:$textcolor $gtk3Theme")
						out_array=( "${out_array[@]}" "$mygtk3" )
						((display_index++))
					else
						if [[ "$gtk2Theme" == "$gtk3Theme" ]]; then
							if [[ "$gtk2Theme" != "Not Applicable" && "$gtk2Theme" != "Not Found" ]]; then
								mygtk=$(echo -e "$labelcolor GTK Theme:$textcolor ${gtk2Theme} [GTK2/3]")
								out_array=( "${out_array[@]}" "$mygtk" )
								((display_index++))
							fi
						else
							mygtk=$(echo -e "$labelcolor GTK Theme:$textcolor ${mygtk2}${mygtk3}")
							out_array=( "${out_array[@]}" "$mygtk" )
							((display_index++))
						fi
					fi
					if [[ "$gtkIcons" != "Not Applicable" && "$gtkIcons" != "Not Found" ]]; then
						if [ -n "$gtkIcons" ]; then
							myicons=$(echo -e "$labelcolor Icon Theme:$textcolor $gtkIcons")
							out_array=( "${out_array[@]}" "$myicons" )
							((display_index++))
						fi
					fi
					if [[ "$gtkFont" != "Not Applicable" && "$gtkFont" != "Not Found" ]]; then
						if [ -n "$gtkFont" ]; then
							myfont=$(echo -e "$labelcolor Font:$textcolor $gtkFont")
							out_array=( "${out_array[@]}" "$myfont" )
							((display_index++))
						fi
					fi
				fi
			fi
		elif [[ "$fake_distro" == "Cygwin" || "$fake_distro" == "Msys" || "$fake_distro" == "Windows - Modern" ]]; then
			if [[ "${display[@]}" =~ "res" && -n "$xResolution" ]]; then
				myres=$(echo -e "$labelcolor Resolution:${textcolor} $xResolution")
				out_array=( "${out_array[@]}" "$myres" )
				((display_index++))
			fi
			if [[ "${display[@]}" =~ "de" ]]; then
				if [[ "${DE}" != "Not Present" ]]; then
					myde=$(echo -e "$labelcolor DE:$textcolor $DE")
					out_array=( "${out_array[@]}" "$myde" )
					((display_index++))
				fi
			fi
			if [[ "${display[@]}" =~ "wm" ]]; then
				mywm=$(echo -e "$labelcolor WM:$textcolor $WM")
				out_array=( "${out_array[@]}" "$mywm" )
				((display_index++))
			fi
			if [[ "${display[@]}" =~ "wmtheme" ]]; then
				if [[ "${Win_theme}" != "Not Applicable" && "${Win_theme}" != "Not Found" ]]; then
					mywmtheme=$(echo -e "$labelcolor WM Theme:$textcolor $Win_theme")
					out_array=( "${out_array[@]}" "$mywmtheme" )
					((display_index++))
				fi
			fi
		elif [[ "$distro" == "Haiku" && -n "${xResolution}" && "${display[@]}" =~ "res" ]]; then
			myres=$(echo -e "$labelcolor Resolution:${textcolor} $xResolution")
			out_array=( "${out_array[@]}" "$myres" )
			((display_index++))
		fi
		if [[ "${fake_distro}" != "Cygwin" && "${fake_distro}" != "Msys" && "${fake_distro}" != "Windows - Modern" && "${display[@]}" =~ "disk" ]]; then
			mydisk=$(echo -e "$labelcolor Disk:$textcolor $diskusage")
			out_array=( "${out_array[@]}" "$mydisk" )
			((display_index++))
		fi
		if [[ "${display[@]}" =~ "cpu" ]]; then
			mycpu=$(echo -e "$labelcolor CPU:$textcolor $cpu")
			out_array=( "${out_array[@]}" "$mycpu" )
			((display_index++))
		fi
		if [[ "${display[@]}" =~ "gpu" ]] && [[ "$gpu" != "Not Found" ]]; then
			mygpu=$(echo -e "$labelcolor GPU:$textcolor $gpu")
			out_array=( "${out_array[@]}" "$mygpu" )
			((display_index++))
		fi
		if [[ "${display[@]}" =~ "mem" ]]; then
			mymem=$(echo -e "$labelcolor RAM:$textcolor $mem")
			out_array=( "${out_array[@]}" "$mymem" )
			((display_index++))
		fi
		if [[ "$use_customlines" = 1 ]]; then
			customlines
		fi
	fi
	if [[ "$display_type" == "ASCII" ]]; then
		asciiText
	else
		if [[ "${display[@]}" =~ "host" ]]; then echo -e "$myinfo"; fi
		if [[ "${display[@]}" =~ "distro" ]]; then echo -e "$mydistro"; fi
		if [[ "${display[@]}" =~ "kernel" ]]; then echo -e "$mykernel"; fi
		if [[ "${distro}" == "Android" ]]; then
			echo -e "$mydevice"
			echo -e "$myrom"
			echo -e "$mybaseband"
			echo -e "$mykernel"
			echo -e "$myuptime"
			echo -e "$mycpu"
			echo -e "$mymem"
		else
			if [[ "${display[@]}" =~ "uptime" ]]; then echo -e "$myuptime"; fi
			if [[ "${display[@]}" =~ "pkgs" && "$mypkgs" != "Unknown" ]]; then echo -e "$mypkgs"; fi
			if [[ "${display[@]}" =~ "shell" ]]; then echo -e "$myshell"; fi
			if [[ "${display[@]}" =~ "res" ]]; then
				test -z "$myres" || echo -e "$myres"
			fi
			if [[ "${display[@]}" =~ "de" ]]; then
				if [[ "${DE}" != "Not Present" ]]; then echo -e "$myde"; fi
			fi
			if [[ "${display[@]}" =~ "wm" ]]; then
				test -z "$mywm" || echo -e "$mywm"
				if [[ "${Win_theme}" != "Not Applicable" && "${Win_theme}" != "Not Found" ]]; then
					test -z "$mywmtheme" || echo -e "$mywmtheme"
				fi
			fi
			if [[ "${display[@]}" =~ "gtk" ]]; then
				if [[ "$gtk_2line" == "yes" ]]; then
					test -z "$mygtk2" || echo -e "$mygtk2"
					test -z "$mygtk3" || echo -e "$mygtk3"
				else
					test -z "$mygtk" || echo -e "$mygtk"
				fi
				test -z "$myicons" || echo -e "$myicons"
				test -z "$myfont" || echo -e "$myfont"
			fi
			if [[ "${display[@]}" =~ "disk" ]]; then echo -e "$mydisk"; fi
			if [[ "${display[@]}" =~ "cpu" ]]; then echo -e "$mycpu"; fi
			if [[ "${display[@]}" =~ "gpu" ]]; then echo -e "$mygpu"; fi
			if [[ "${display[@]}" =~ "mem" ]]; then echo -e "$mymem"; fi
		fi
	fi
}

##################
# Let's Do This!
##################

if [[ -f "$HOME/.screenfetchOR" ]]; then
	source "$HOME/.screenfetchOR"
fi

if [[ "$overrideDisplay" ]]; then
	verboseOut "Found 'd' flag in syntax. Overriding display..."
	OLDIFS=$IFS
	IFS=';'
	for i in ${overrideDisplay}; do
		modchar="${i:0:1}"
		if [[ "${modchar}" == "-" ]]; then
			i=${i/${modchar}}
			_OLDIFS=IFS
			IFS=,
			for n in $i; do
				if [[ ! "${display[@]}" =~ "$n" ]]; then
					echo "The var $n is not currently being displayed."
				else
					for e in "${!display[@]}"; do
						if [[ ${display[e]} = "$n" ]]; then
							unset 'display[e]'
						fi
					done
				fi
			done
			IFS=$_OLDIFS
		elif [[ "${modchar}" == "+" ]]; then
			i=${i/${modchar}}
			_OLDIFS=IFS
			IFS=,
			for n in $i; do
				if [[ "${valid_display[@]}" =~ "$n" ]]; then
					if [[ "${display[@]}" =~ "$n" ]]; then
						echo "The $n var is already being displayed."
					else
						display+=("$n")
					fi
				else
					echo "The var $n is not a valid display var."
				fi
			done
			IFS=$_OLDIFS
		else
			IFS=$OLDIFS
			i="${i//,/ }"
			display=( "$i" )
		fi
	done
	IFS=$OLDIFS
fi

for i in "${display[@]}"; do
	if [[ -n "$i" ]]; then
		if [[ $i =~ wm ]]; then
			test -z "$WM" && detectwm
			test -z "$Win_theme" && detectwmtheme
		else
			if [[ "${display[*]}" =~ "$i" ]]; then
				if [[ "$errorSuppress" == "1" ]]; then
					detect"${i}" 2>/dev/null
				else
					detect"${i}"
				fi
			fi
		fi
	fi
done

# Check for android
if [[ -f /system/build.prop  && "${distro}" != "SailfishOS" ]]; then
    distro="Android"
    detectmem
    detectuptime
    detectkernel
    detectdroid
    infoDisplay
    exit 0
fi

if [ "$gpu" = 'Not Found' ] ; then
	DetectIntelGPU
fi


infoDisplay
[ "$screenshot" == "1" ] && takeShot

exit 0
