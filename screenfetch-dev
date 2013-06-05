#!/usr/bin/env bash

# screenFetch

# Script to fetch system and theme settings for screenshots in most mainstream
# Linux distributions.

# Copyright (c) 2010-2012 Brett Bohnenkamper < kittykatt AT archlinux DOT us >

# Permission is hereby granted, free of charge, to any person obtaining a copy of this software
# and associated documentation files (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Yes, I do realize some of this is horribly ugly coding. Any ideas/suggestions would be
# appreciated by emailing me or by stopping by http://github.com/KittyKatt/screenFetch . You
# could also drop in on my IRC network, SilverIRC, at irc://kittykatt.silverirc.com:6667/screenFetch
# to put forth suggestions/ideas. Thank you.
#

scriptVersion="2.9.0"

######################
# Settings for fetcher
######################

# This setting controls what ASCII logo is displayed. Available: Arch Linux (Old and Current Logos), Linux Mint, Ubuntu, Crunchbang, Debian, Gentoo, Mandrake/Mandriva, Slackware, SUSE, Fedora, BSD, OS X and None
# distro="Linux"

# This sets the information to be displayed. Available: distro, Kernel, DE, WM, Win_theme, Theme, Icons, Font, Background, ASCII. To get just the information, and not a text-art logo, you would take "ASCII" out of the below variable.
#display="host distro kernel uptime shell res de wm wmtheme gtk icons font background gpu"
display=( host distro kernel uptime pkgs shell res de wm wmtheme gtk cpu mem )
# Display Type: ASCII or Text
display_type="ASCII"

# Colors to use for the information found. These are set below according to distribution. If you would like to set your OWN color scheme for these, uncomment the lines below and edit them to your heart's content.
# textcolor="\e[0m"
# labelcolor="\e[1;34m"

# WM & DE process names
# Removed WM's: compiz
wmnames="fluxbox openbox blackbox xfwm4 metacity kwin icewm pekwm fvwm dwm awesome wmaker stumpwm musca i3 xmonad ratpoison scrotwm spectrwm wmfs wmii beryl subtle e16 enlightenment sawfish emerald monsterwm dminiwm compiz Finder herbstluftwm"
denames="gnome-session xfce-mcs-manage xfce4-session xfconfd ksmserver lxsession gnome-settings-daemon mate-session mate-settings-daemon Finder"

# Export theme settings
# screenFetch has the capability (on some WM's and GTK) to export your GTK and WM settings to an archive. Specify Yes if you want this and No if you do not.
exportTheme=

# Screenshot Settings
# This setting lets the script know if you want to take a screenshot or not. 1=Yes 0=No
screenshot=
# You can specify a custom screenshot command here. Just uncomment and edit. Otherwise, we'll be using the default command: scrot -cd3.
# screenCommand="scrot -cd5"
hostshot=
baseurl="http://www.example.com"
serveraddr="www.example.com"
scptimeout="20"
serverdir="/path/to/directory"
shotfile=$(echo "screenFetch-`date +'%Y-%m-%d_%H-%M-%S'`.png")

# Verbose Setting - Set to 1 for verbose output.
verbosity=

function verboseOut {
	echo -e "\033[1;31m:: \033[0m$1"
}

function errorOut {
	echo -e "\033[1;37m[[ \033[1;31m! \033[1;37m]] \033[0m$1"
}

#############################################
#### CODE No need to edit past here CODE ####
#############################################

####################
# Static Variables
####################
c0="\033[0m" # Reset Text
bold="\033[1m" # Bold Text
underline="\033[4m" # Underline Text
display_index=0



####################
#  Color Defines
####################

detectColors() {
	my_lcolor=$(echo -n "$OPTARG" 2>/dev/null | grep -Eo '[0-9]*,' | sed 's/,$//')
	case $my_lcolor in
		0|00)  export my_lcolor='\033[30m';;
		1|01)  export my_lcolor='\033[31m';;
		2|02)  export my_lcolor='\033[32m';;
		3|03)  export my_lcolor='\033[33m';;
		4|04)  export my_lcolor='\033[34m';;
		5|05)  export my_lcolor='\033[35m';;
		6|06)  export my_lcolor='\033[36m';;
		7|07)  export my_lcolor='\033[37m';;
		8|08)  export my_lcolor='\033[1;30m';;
		9|09)  export my_lcolor='\033[1;31m';;
		10) export my_lcolor='\033[1;32m';;
		11) export my_lcolor='\033[1;33m';;
		12) export my_lcolor='\033[1;34m';;
		13) export my_lcolor='\033[1;35m';;
		14) export my_lcolor='\033[1;36m';;
		15) export my_lcolor='\033[1;37m';;
		*) unset my_lcolor; continue ;;
	esac
	my_hcolor=$(echo -n "$OPTARG" 2>/dev/null | grep -Eo ',[0-9]*' | sed 's/^,//')
	case $my_hcolor in
		0|00)  export my_hcolor='\033[30m';;
		1|01)  export my_hcolor='\033[31m';;
		2|02)  export my_hcolor='\033[32m';;
		3|03)  export my_hcolor='\033[33m';;
		4|04)  export my_hcolor='\033[34m';;
		5|05)  export my_hcolor='\033[35m';;
		6|06)  export my_hcolor='\033[36m';;
		7|07)  export my_hcolor='\033[37m';;
		8|08)  export my_hcolor='\033[1;30m';;
		9|09)  export my_hcolor='\033[1;31m';;
		10) export my_hcolor='\033[1;32m';;
		11) export my_hcolor='\033[1;33m';;
		12) export my_hcolor='\033[1;34m';;
		13) export my_hcolor='\033[1;35m';;
		14) export my_hcolor='\033[1;36m';;
		15) export my_hcolor='\033[1;37m';;
		*) unset my_hcolor; continue ;;
	esac
}


displayHelp() {
	echo -e "${underline}Usage${c0}:"
	echo -e "  screenFetch [OPTIONAL FLAGS]"
	echo ""
	echo "screenFetch - a CLI Bash script to show system/theme info in screenshots."
	echo ""
	echo -e "${underline}Supported Distributions${c0}:      Arch Linux (Old and Current Logos), Linux Mint,"
	echo -e "			      LMDE, Ubuntu, Crunchbang, Debian, Gentoo, Fedora, SolusOS,"
	echo -e "			      Mandrake/Mandriva, Slackware, Frugalware, openSUSE, Mageia,"
	echo -e "			      Peppermint, ParabolaGNU, Viperr, LinuxDeepin, Chakra, and FreeBSD, OpenBSD"
	echo -e "${underline}Supported Desktop Managers${c0}:   KDE, GNOME, XFCE, and LXDE, and Not Present"
	echo -e "${underline}Supported Window Managers${c0}:    PekWM, OpenBox, FluxBox, BlackBox, Xfwm4,"
	echo -e "			      Metacity, StumpWM, KWin, IceWM, FVWM,"
	echo -e "			      DWM, Awesome, XMonad, Musca, i3, WindowMaker,"
	echo -e "			      Ratpoison, wmii, WMFS, ScrotWM, SpectrWM,"
	echo -e "			      subtle, Emerald, E17 and Beryl."
	echo ""
	echo -e "${underline}Options${c0}:"
	echo -e "   ${bold}-v${c0}                 Verbose output."
	echo -e "   ${bold}-o 'OPTIONS'${c0}       Allows for setting script variables on the"
	echo -e "		      command line. Must be in the following format..."
	echo -e "		      'OPTION1=\"OPTIONARG1\";OPTION2=\"OPTIONARG2\"'"
	#echo -e "   ${bold}-d 'ARGUMENTS'${c0}     Allows for setting what information is displayed"
	#echo -e "		      on the command line. Format must be as follows:"
	#echo -e "		      'OPTION OPTION OPTION OPTION'. Valid options are"
	#echo -e "		      host, distro, Kernel, Uptime, Shell, Resolution, DE, WM,"
	#echo -e "		      Win_theme, Theme, Icons, Font, ASCII, Background."
	echo -e "   ${bold}-n${c0}                 Do not display ASCII distribution logo."
	echo -e "   ${bold}-N${c0}                 Strip all color from output."
	echo -e "   ${bold}-t${c0}                 Truncate output based on terminal width (Experimental!)."
	echo -e "   ${bold}-s(m)${c0}              Using this flag tells the script that you want it"
	echo -e "		      to take a screenshot. Use the -m flag if you would like"
	echo -e "		      to move it to a new location afterwards."
	#echo -e "   ${bold}-B${c0}                 Enable background detection."
	echo -e "   ${bold}-e${c0}                 When this flag is specified, screenFetch will attempt"
	echo -e "		      to export all of your theme settings and archive them"
	echo -e "		      up for uploading."
	#echo -e "   ${bold}-l${c0}                 Specify that you have a light background. This turns"
	#echo -e "		      all white text into dark gray text (in ascii logos and"
	#echo -e "		      in information output)."
	echo -e "   ${bold}-c string${c0}          You may change the outputted colors with -c. The format is"
	echo -e "                      as follows: [0-9][0-9],[0-9][0-9]. The first argument controls the"
	echo -e "                      ASCII logo colors and the label colors. The second argument"
	echo -e "                      controls the colors of the information found. One argument may be"
	echo -e "                      used without the other."
	echo -e "   ${bold}-S 'COMMAND'${c0}       Here you can specify a custom screenshot command for"
	echo -e "		      the script to execute. Surrounding quotes are required."
	echo -e "   ${bold}-D 'DISTRO'${c0}        Here you can specify your distribution for the script"
	echo -e "		      to use. Surrounding quotes are required."
	echo -e "   ${bold}-A 'DISTRO'${c0}        Here you can specify the distribution art that you want"
	echo -e "		      displayed. This is for when you want your distro"
	echo -e "                      detected but want to display a different logo."
	echo -e "   ${bold}-V${c0}                 Display current script version."
	echo -e "   ${bold}-h${c0}                 Display this help."
	exit 0
}

#####################
# Begin Flags Phase
#####################

case $1 in
	--help) displayHelp;;
esac
		

while getopts ":hsmevVEnNtlS:A:D:o:Bc:" flags; do
	case $flags in
		h) displayHelp;;
		s) screenshot=1; continue;;
		S) screenCommand=$OPTARG; continue;;
		m) hostshot=1; continue;;
		e) exportTheme=1; continue;;
		v) verbosity=1; continue;;
		V)
			echo -e $underline"screenFetch"$c0" - Version $scriptVersion"
			echo "Created by and licensed to Brett Bohnenkamper (kittykatt@kittykatt.us)"
			echo "OS X porting done almost solely by shrx (http://shrx.github.com/) and Hu6."
			echo ""
			echo "This is free software; see the source for copying conditions.  There is NO warranty; not even MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE."
			exit
		;;
		E) errorSuppress="1";;
		D) distro=$OPTARG; continue;;
		A) asc_distro=$OPTARG; continue;;
		t) truncateSet="Yes";;
		n) display_type="Text";;
		o) overrideOpts=$OPTARG; continue;;
		# c) my_color=$(echo "$OPTARG" | awk -F',' '{ print $1 }'); my_bgcolor=$(echo "$OPTARG" | awk -F',' '{ print $2 }'); continue;;
		c) detectColors "$OPTARGS"; continue;;
		# d) overrideDisplay=$OPTARG; continue;;
		# l) colors_light="1";;
		# B) background_detect="1"; continue;;
		N) no_color='1';;
		:) errorOut "Error: You're missing an argument somewhere. Exiting."; exit 1;;
		?) errorOut "Error: Invalid flag somewhere. Exiting."; exit 1;;
		*) errorOut "Error"; exit 1;;
	esac
done

###################
# End Flags Phase
###################


####################
# Override Options
####################

if [[ "$overrideOpts" ]]; then
	[[ "$verbosity" -eq "1" ]] && verboseOut "Found 'o' flag in syntax. Overriding some script variables..."
	OLD_IFS="$IFS"
	IFS=";"
	for overopt in "$overrideOpts"; do
		eval "$overrideOpts"
	done
	IFS="$OLD_IFS"
fi
#if [[ "$overrideDisplay" ]]; then
#	[[ "$verbosity" -eq "1" ]] && verboseOut "Found 'd' flag in syntax. Overriding some display options..."
#	display="$overrideDisplay"
#fi


#########################
# Begin Detection Phase
#########################


# Host and User detection - Begin
detecthost () {
	myUser=${USER}
	myHost=${HOSTNAME}
	[[ "$verbosity" -eq "1" ]] && verboseOut "Finding hostname and user...found as '$myUser@$myHost'"
}

# Distro Detection - Begin
detectdistro () {
	if [[ -z $distro ]]; then
		distro="Unknown"

		# LSB Release Check
		if type -p lsb_release >/dev/null 2>&1; then
			# read distro_detect distro_release distro_codename <<< $(lsb_release -sirc)
			distro_detect=( $(lsb_release -sirc) )
			if [[ ${#distro_detect[@]} -eq 3 ]]; then
				distro_codename=${distro_detect[2]}
				distro_release=${distro_detect[1]}
				distro_detect=${distro_detect[0]}
			else
				for ((i=0; i<${#distro_detect[@]}; i++)); do
					if [[ ${distro_detect[$i]} =~ ^[[:digit:]]+((.[[:digit:]]+|[[:digit:]]+|)+)$ ]]; then
						distro_release=${distro_detect[$i]}
						distro_codename=${distro_detect[@]:$(($i+1)):${#distro_detect[@]}+1}
						distro_detect=${distro_detect[@]:0:${i}}
						break 1
					elif [[ ${distro_detect[$i]} =~ [Nn]/[Aa] || ${distro_detect[$i]} == "rolling" ]]; then
						distro_release=${distro_detect[$i]}
						distro_codename=${distro_detect[@]:$(($i+1)):${#distro_detect[@]}+1}
						distro_detect=${distro_detect[@]:0:${i}}
						break 1
					fi
				done
			fi

			if [[ "${distro_detect}" == "archlinux" || "${distro_detect}" == "Arch Linux" || "${distro_detect}" == "arch" ]]; then
				distro="Arch Linux"
				distro_release="n/a"
			elif [[ "${distro_detect}" == "Chakra" ]]; then
				distro="Chakra"
				distro_release=null
			elif [[ "${distro_detect}" == "Debian" ]]; then
				if [[ -f /etc/crunchbang-lsb-release || -f /etc/lsb-release-crunchbang ]]; then
					distro="CrunchBang"
					distro_release=$(awk -F'=' '/^DISTRIB_RELEASE=/ {print $2}' /etc/lsb-release-crunchbang)
					distro_codename=$(awk -F'=' '/^DISTRIB_DESCRIPTION=/ {print $2}' /etc/lsb-release-crunchbang)
				else
					distro="Debian"
				fi
			elif [[ "${distro_detect}" == "elementary" ]]; then
				distro="ElementaryOS"
				distro_release=null
				distro_codename=null
			elif [[ "${distro_detect}" == "Fedora" ]]; then
				distro="Fedora"
			elif [[ "${distro_detect}" == "frugalware" ]]; then
				distro="Frugalware"
				distro_codename=null
				distro_release=null
			elif [[ "${distro_detect}" == "Fuduntu" ]]; then
				distro="Fuduntu"
				distro_codename=null
			elif [[ "${distro_detect}" == "Gentoo" ]]; then
				distro="Gentoo"
			elif [[ "${distro_detect}" == "LinuxDeepin" ]]; then
				distro="LinuxDeepin"
				distro_codename=null
			elif [[ "${distro_detect}" == "Mageia" ]]; then
				distro="Mageia"
			elif [[ "$distro_detect" == "MandrivaLinux" ]]; then
				distro="Mandriva"
				if [[ "${distro_codename}" == "turtle" ]]; then
					distro="Mandriva-${distro_release}"
					distro_codename=null
				elif [[ "${distro_codename}" == "Henry_Farman" ]]; then
					distro="Mandriva-${distro_release}"
					distro_codename=null
				elif [[ "${distro_codename}" == "Farman" ]]; then
					distro="Mandriva-${distro_release}"
					distro_codename=null
				elif [[ "${distro_codename}" == "Adelie" ]]; then
					distro="Mandriva-${distro_release}"
					distro_codename=null
				elif [[ "${distro_codename}" == "pauillac" ]]; then
					distro="Mandriva-${distro_release}"
					distro_codename=null
				fi
			elif [[ "${distro_detect}" == "ManjaroLinux" ]]; then
				distro="Manjaro"
			elif [[ "${distro_detect}" == "LinuxMint" ]]; then
				distro="Mint"
				if [[ "${distro_codename}" == "debian" ]]; then
					distro="LMDE"
					distro_codename=null
					distro_release=null
				fi
			elif [[ "${distro_detect}" == "SUSE LINUX" || "${distro_detect}" == "openSUSE project" ]]; then
				distro="openSUSE"
			elif [[ "${distro_detect}" == "ParabolaGNU/Linux-libre" ]]; then
				distro="ParabolaGNU/Linux-libre"
			elif [[ "${distro_detect}" == "Peppermint" ]]; then
				distro="Peppermint"
				distro_codename=null
			elif [[ "${distro_detect}" == "CentOS" || "${distro_detect}" =~ "RedHatEnterprise" ]]; then
				distro="Red Hat Linux"
			elif [[ "${distro_detect}" == "Sabayon" ]]; then
				distro="Sabayon"
			elif [[ "${distro_detect}" == "SolusOS" ]]; then
				distro="SolusOS"
			elif [[ "${distro_detect}" == "Trisquel" ]]; then
				distro="Trisquel"
			elif [[ "${distro_detect}" == "Ubuntu" ]]; then
				distro="Ubuntu"
			elif [[ "${distro_detect}" == "Viperr" ]]; then
				distro="Viperr"
				distro_codename=null
			fi
			if [[ -n ${distro_release} && ${distro_release} != "n/a" ]]; then distro_more="$distro_release"; fi
			if [[ -n ${distro_codename} && ${distro_codename} != "n/a" ]]; then distro_more="$distro_more $distro_codename"; fi
			if [[ -n ${distro_more} ]]; then
				distro_more="${distro} ${distro_more}"
			fi
		fi

		# Existing File Check
		if [ "$distro" == "Unknown" ]; then
			if [ $(uname -o 2>/dev/null) ]; then
				if [ `uname -o` == "Cygwin" ]; then distro="Cygwin"; fake_distro="${distro}"; fi
			fi
			if [ -f /etc/os-release ]; then
				distrib_id=$(</etc/os-release);
				for l in $(echo $distrib_id); do
					if [[ ${l} =~ ^ID= ]]; then
						distrib_id=${l//*=}
						break 1
					fi
				done
				if [[ -n ${distrib_id} ]]; then
					if [[ -n ${BASH_VERSINFO} && ${BASH_VERSINFO} -ge 4 ]]; then
						distrib_id=$(for i in ${distrib_id}; do echo -n "${i^} "; done)
						distro=${distrib_id% }
						unset distrib_id
					else
						distrib_id=$(for i in ${distrib_id}; do FIRST_LETTER=$(echo -n "${i:0:1}" | tr "[:lower:]" "[:upper:]"); echo -n "${FIRST_LETTER}${i:1} "; done)
						distro=${distrib_id% }
						unset distrib_id
					fi
				fi

				# Arch Quick fix
				[[ "${distro}" == "Arch" ]] && distro="Arch Linux"
			fi

			if [[ "${distro}" == "Unknown" ]]; then
				if [[ "${OSTYPE}" == "linux-gnu" || "${OSTYPE}" == "linux" ]]; then
					if [ -f /etc/lsb-release ]; then
						LSB_RELEASE=$(</etc/lsb-release)
						distro=$(echo ${LSB_RELEASE} | awk 'BEGIN {
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
				fi
			fi

			if [[ "${distro}" == "Unknown" ]]; then
				if [[ "${OSTYPE}" == "linux-gnu" || "${OSTYPE}" == "linux" ]]; then
					if [ -f /etc/arch-release ]; then distro="Arch Linux"
					elif [ -f /etc/chakra-release ]; then distro="Chakra"
					elif [ -f /etc/crunchbang-lsb-release ]; then distro="CrunchBang"
					elif [ -f /etc/debian_version ]; then distro="Debian"
					elif [ -f /etc/fedora-release ] && grep -q "Fedora" /etc/fedora-release; then distro="Fedora"
					elif [ -f /etc/frugalware-release ]; then distro="Frugalware"
					elif [ -f /etc/gentoo-release ]; then distro="Gentoo"
					elif [ -f /etc/mageia-release ]; then distro="Mageia"
					elif [ -f /etc/mandrake-release ]; then distro="Mandrake"
					elif [ -f /etc/mandriva-release ]; then distro="Mandriva"
					elif [ -f /etc/SuSE-release ]; then distro="openSUSE"
					elif [ -f /etc/redhat-release ] && grep -q "Red Hat" /etc/redhat-release; then distro="Red Hat Linux"
					elif [ -f /etc/slackware-version ]; then distro="Slackware"
					elif [ -f /usr/share/doc/tc/release.txt ]; then distro="TinyCore"
					elif [ -f /etc/sabayon-edition ]; then distro="Sabayon"; fi
				else
					if [[ -x /usr/bin/sw_vers ]] && /usr/bin/sw_vers | grep -i "Mac OS X" >/dev/null; then
						distro="Mac OS X"
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
			if [[ "${distro}" == "Unknown" ]] && [[ "${OSTYPE}" == "linux-gnu" || "${OSTYPE}" == "linux" ]]; then
				if [[ -f /etc/issue ]]; then
					distro=$(awk 'BEGIN {
						distro = "Unknown"
					}
					{
						if ($0 ~ /"LinuxDeepin"/) {
							distro = "LinuxDeepin"
							exit
						}
						else if ($0 ~ /"Parabola GNU\/Linux-libre"/) {
							distro = "ParabolaGNU/Linux-libre"
							exit
						}
						else if ($0 ~ /"SolusOS"/) {
							distro = "SolusOS"
							exit
						}
					} END {
						print distro
					}' /etc/issue)
				fi
			fi
			if [[ "${distro}" == "Unknown" ]] && [[ "${OSTYPE}" == "linux-gnu" || "${OSTYPE}" == "linux" ]]; then
				if [[ -f /etc/system-release ]]; then
					distro=$(awk 'BEGIN {
						distro = "Unknown"
					}
					{
						if ($0 ~ /"Scientific\ Linux"/) {
							distro = "Scientific Linux"
							exit
						}
					} END {
						print distro
					}' /etc/system-release)
				fi
			fi



		fi
	else
		declare -l lcase
		lcase=$distro
		case $lcase in
			arch*linux*old) distro="Arch Linux - Old" ;;
			arch*linux) distro="Arch Linux" ;;
			arch) distro="Arch Linux";;
			elementary) distro="Elementary OS";;
			fedora) distro="Fedora" ;;
			mageia) distro="Mageia" ;;
			mandriva) distro="Mandriva" ;;
			mandrake) distro="Mandrake" ;;
			crunchbang) distro="CrunchBang" ;;
			mint) distro="Mint" ;;
			lmde) distro="LMDE" ;;
			opensuse) distro="openSUSE" ;;
			ubuntu) distro="Ubuntu" ;;
			debian) distro="Debian" ;;
			freebsd) distro="FreeBSD" ;;
			openbsd) distro="OpenBSD" ;;
			dragonflybsd) distro="DragonFlyBSD" ;;
			netbsd) distro="NetBSD" ;;
			red*hat*) distro="Red Hat Linux" ;;
			crunchbang) distro="CrunchBang" ;;
			gentoo) distro="Gentoo" ;;
			slackware) distro="Slackware" ;;
			frugalware) distro="Frugalware" ;;
			peppermint) distro="Peppermint" ;;
			solusos) distro="SolusOS" ;;
			parabolagnu|parabolagnu/linux-libre) distro="ParabolaGNU/Linux-libre" ;;
			viperr) distro="Viperr" ;;
			linuxdeepin) distro="LinuxDeepin" ;;
			chakra) distro="Chakra" ;;
			mac*os*x) distro="Mac OS X" ;;
			fuduntu) distro="Fuduntu" ;;
			manjaro) distro="Manjaro" ;;
			cygwin) distro="Cygwin" ;;
		esac
	fi
	[[ "$verbosity" -eq "1" ]] && verboseOut "Finding distro...found as '$distro $distro_release'"
}
# Distro Detection - End

# Find Number of Running Processes
# processnum="$(( $( ps aux | wc -l ) - 1 ))"

# Kernel Version Detection - Begin
detectkernel () {
	kernel=( $(uname -srm) )
	kernel="${kernel[${#kernel[@]}-1]} ${kernel[@]:0:${#kernel[@]}-1}"
	[[ "$verbosity" -eq "1" ]] && verboseOut "Finding kernel version...found as '$kernel'"
}
# Kernel Version Detection - End


# Uptime Detection - Begin
detectuptime () {
	unset uptime
	if [ "$distro" == "Mac OS X" ]; then
		boot=`sysctl -n kern.boottime | cut -d "=" -f 2 | cut -d "," -f 1`
		now=`date +%s`
		uptime=$(($now-$boot))
	elif [[ "${distro}" == "FreeBSD" || "${distro}" == "OpenBSD" ]]; then
		if [[ "${distro}" == "FreeBSD" ]]; then boot=`sysctl -n kern.boottime | cut -d "=" -f 2 | cut -d "," -f 1`
		else boot=$(sysctl -n kern.boottime); fi
		now=$(date +%s)
		uptime=$((${now} - ${boot}))
	else
		if [[ -f /proc/uptime ]]; then
			uptime=$(</proc/uptime)
			uptime=${uptime//.*}
		fi
	fi

	if [[ -n ${uptime} ]]; then
		secs=$((${uptime}%60))
		mins=$((${uptime}/60%60))
		hours=$((${uptime}/3600%24))
		days=$((${uptime}/86400))
		uptime="${mins}m"
		if [ "${hours}" -ne "0" ]; then
			uptime="${hours}h ${uptime}"
		fi
		if [ "${days}" -ne "0" ]; then
			uptime="${days}d ${uptime}"
		fi
	else
		if [[ "$distro" =~ "NetBSD" ]]; then uptime=$(awk -F. '{print $1}' /proc/uptime); fi
		if [[ "$distro" =~ "BSD" ]]; then uptime=$(uptime | awk '{$1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; sub(" days","d");sub(",","");sub(":","h ");sub(",","m"); print}'); fi
	fi
	[[ "$verbosity" -eq "1" ]] && verboseOut "Finding current uptime...found as '$uptime'"
}
# Uptime Detection - End


# Package Count - Begin
detectpkgs () {
	pkgs="Unknown"
	case $distro in
		'Arch Linux'|'ParabolaGNU/Linux-libre'|'Chakra'|'Manjaro') pkgs=$(pacman -Qq | wc -l) ;;
		'Frugalware') pkgs=$(pacman-g2 -Q | wc -l) ;;
		'Fuduntu'|'Ubuntu'|'Mint'|'SolusOS'|'Debian'|'LMDE'|'CrunchBang'|'Peppermint'|'LinuxDeepin'|'Trisquel') pkgs=$(dpkg --get-selections | wc -l) ;;
		'Slackware') pkgs=$(ls -1 /var/log/packages | wc -l) ;;
		'Gentoo'|'Sabayon') pkgs=$(ls -d /var/db/pkg/*/* | wc -l) ;;
		'Fedora'|'openSUSE'|'Red Hat Linux'|'Mandriva'|'Mandrake'|'Mageia'|'Viperr') pkgs=$(rpm -qa | wc -l) ;;
		'Mac OS X')
			if [ -d "/usr/local/bin" ]; then loc_pkgs=$(echo $(ls /usr/local/bin | wc -w)); pkgs="$loc_pkgs"; fi

			if type -p port >/dev/null 2>&1; then
				port_pkgs=$(port installed 2>/dev/null | wc -l)
				pkgs=$((${pkgs} + (${port_pkgs} -1)))
			fi

			if type -p port >/dev/null 2>&1; then
				brew_pkgs=$(brew list -1 2>/dev/null | wc -l)
				pkgs=$((${pkgs} + ${brew_pkgs}))
			fi
		;;
		'FreeBSD'|'OpenBSD') pkgs=$(pkg_info | wc -l | awk '{sub(" ", "");print $1}') ;;
		'Cygwin') cygfix=2; pkgs=$(($(cygcheck -cd | wc -l)-$cygfix)) ;;
	esac
	[[ "$verbosity" -eq "1" ]] && verboseOut "Finding current package count...found as '$pkgs'"
}




# CPU Detection - Begin
detectcpu () {
	if [ "$distro" == "Mac OS X" ]; then cpu=$(echo $(sysctl -n machdep.cpu.brand_string))
	elif [ "$distro" == "FreeBSD" ]; then cpu=$(sysctl -n hw.model)
	elif [ "$distro" == "DragonflyBSD" ]; then cpu=$(sysctl -n hw.model)
	elif [ "$distro" == "OpenBSD" ]; then cpu=$(sysctl -n hw.model | sed 's/@.*//')
	else
		cpu=$(awk 'BEGIN{FS=":"} /model name/ { gsub(/  +/," ",$2); gsub(/^ /,"",$2); gsub(/\(R\)|\(TM\)|\(tm\)| Processor/,"",$2); print $2; exit }' /proc/cpuinfo | sed 's/ @/\n/' | head -1)
		loc="/sys/devices/system/cpu/cpu0/cpufreq"
		if [ -f $loc/bios_limit ];then
			cpu_mhz=$(cat $loc/bios_limit | awk '{print $1/1000}')
		elif [ -f $loc/scaling_max_freq ];then
			cpu_mhz=$(cat $loc/scaling_max_freq | awk '{print $1/1000}')
		else
			cpu_mhz=$(awk -F':' '/cpu MHz/{ print int($2) }' /proc/cpuinfo | head -n 1)
		fi
		if [ -n "$cpu_mhz" ];then
			if [ $cpu_mhz -gt 999 ];then
				cpu_ghz=$(echo $cpu_mhz | awk '{print $1/1000}')
				cpu="$cpu @ ${cpu_ghz}GHz"
			else
				cpu="$cpu @ ${cpu_mhz}MHz"
			fi
		fi
	fi
	[[ "$verbosity" -eq "1" ]] && verboseOut "Finding current CPU...found as '$cpu'"
}
# CPU Detection - End


# GPU Detection - Begin (EXPERIMENTAL!)
detectgpu () {
	if [ -n "$(type -p lspci)" ]; then
		gpu_info=$(lspci | grep VGA)
		gpu=$(echo "$gpu_info" | grep -oE '\[.*\]' | sed 's/\[//;s/\]//')
		gpu=$(echo "${gpu}" | sed -n '1h;2,$H;${g;s/\n/, /g;p}')
	fi
	if [[ -n "$(type -p glxinfo)" && -z "$gpu" ]]; then
		gpu_info=$(glxinfo 2>/dev/null)
		gpu=$(echo "$gpu_info" | grep "OpenGL renderer string")
		gpu=$(echo "$gpu" | cut -d ':' -f2)
		gpu="${gpu:1}"
		gpu_info=$(echo "$gpu_info" | grep "OpenGL vendor string")
	fi

	if [ -n "$gpu" ];then
		if [ $(echo "$gpu_info" | grep -i nvidia | wc -l) -gt 0 ];then
			gpu_info="NVidia"
		elif [ $(echo "$gpu_info" | grep -i intel | wc -l) -gt 0 ];then
			gpu_info="Intel"
		elif [ $(echo "$gpu_info" | grep -i amd | wc -l) -gt 0 ];then
			gpu_info="AMD"
		elif [ $(echo "$gpu_info" | grep -i ati | wc -l) -gt 0 ];then
			gpu_info="ATI"
		else
			gpu_info=$(echo "$gpu_info" | cut -d ':' -f2)
			gpu_info=${gpu_info:1}
		fi
		gpu="$gpu_info $gpu"
	else
		gpu="Not Found"
	fi

	[[ "$verbosity" -eq "1" ]] && verboseOut "Finding current GPU...found as '$gpu'"
}
# GPU Detection - End


# Memory Detection - Begin
detectmem () {
	hw_mem=0
	free_mem=0
	human=1024
	if [ "$distro" == "Mac OS X" ]; then
		totalmem=$(echo "$(sysctl -n hw.memsize)"/${human}^2|bc)
 		usedmem=$(top -l 1 | awk '{
 			if ($0 ~ /PhysMem/) {
 				for (x=1; x<=NF; x++) {
 					if ($x ~ /wired/) {
 						wired = $(x-1)
 						gsub(/[^0-9]/,"",wired)
 					}

 					if ($x ~ /^active/) {
 						active = $(x-1)
 						gsub(/[^0-9]/,"",active)
 					}

 					if ($x ~ /inactive/) {
 						inactive = $(x-1)
 						gsub(/[^0-9]/,"",inactive)
 					}
 				}
 				usedmem = wired + active + inactive
 				print usedmem
 				exit
 			}
 		}')
	elif [ "$distro" == "Cygwin" ]; then
		total_mem=$(awk '/MemTotal/ { print $2 }' /proc/meminfo)
		totalmem=$((${total_mem}/1024))
		free_mem=$(awk '/MemFree/ { print $2 }' /proc/meminfo)
		used_mem=$((${total_mem} - ${free_mem}))
		usedmem=$((${used_mem}/1024))
	elif [ "$distro" == "FreeBSD" ]; then
		phys_mem=$(sysctl -n hw.physmem)
		size_mem=$phys_mem
		size_chip=1
		guess_chip=`echo "$size_mem / 8 - 1" | bc`
		while [ $guess_chip != 0 ]; do
			guess_chip=`echo "$guess_chip / 2" | bc`
			size_chip=`echo "$size_chip * 2" | bc`
		done
		round_mem=`echo "( $size_mem / $size_chip + 1 ) * $size_chip " | bc`
		totalmem=$(($round_mem / ($human * $human) ))
		pagesize=$(sysctl -n hw.pagesize)
		inactive_count=$(sysctl -n vm.stats.vm.v_inactive_count)
		inactive_mem=$(($inactive_count * $pagesize))
		cache_count=$(sysctl -n vm.stats.vm.v_cache_count)
		cache_mem=$(($cache_count * $pagesize))
		free_count=$(sysctl -n vm.stats.vm.v_free_count)
		free_mem=$(($free_count * $pagesize))
		avail_mem=$(($inactive_mem + $cache_mem + $free_mem))
		used_mem=$(($round_mem - $avail_mem))
		usedmem=$(($used_mem / ($human * $human) ))
	elif [ "$distro" == "OpenBSD" ]; then
		totalmem=$(top -1 1 | awk '/Real:/ {k=split($3,a,"/");print a[k] }' | tr -d 'M')
		usedmem=$(top -1 1 | awk '/Real:/ {print $3}' | sed 's/M.*//')
	elif [ "$distro" == "NetBSD" ]; then
		phys_mem=$(awk '/MemTotal/ { print $2 }' /proc/meminfo)
		totalmem=$((${phys_mem} / $human))
		if grep -q 'Cached' /proc/meminfo; then
			cache=$(awk '/Cached/ {print $2}' /proc/meminfo)
			usedmem=$((${cache} / $human))
		else
			free_mem=$(awk '/MemFree/ { print $2 }' /proc/meminfo)
			used_mem=$((${phys_mem} - ${free_mem}))
			usedmem=$((${used_mem} / $human))
		fi
	else
		mem_info=$(</proc/meminfo)
		mem_info=$(echo $(echo $(mem_info=${mem_info// /}; echo ${mem_info//kB/})))
		for m in $mem_info; do
			if [[ ${m//:*} = MemTotal ]]; then
				memtotal=${m//*:}
			fi

			if [[ ${m//:*} = MemFree ]]; then
				memfree=${m//*:}
			fi

			if [[ ${m//:*} = Buffers ]]; then
				membuffer=${m//*:}
			fi

			if [[ ${m//:*} = Cached ]]; then
				memcached=${m//*:}
			fi
		done

		usedmem="$(((($memtotal - $memfree) - $membuffer - $memcached) / $human))"
		totalmem="$(($memtotal / $human))"
	fi
	mem="${usedmem}MB / ${totalmem}MB"
	[[ "$verbosity" -eq "1" ]] && verboseOut "Finding current RAM usage...found as '$mem'"
}
# Memory Detection - End


# Shell Detection - Begin
detectshell_ver () {
	local version_data='' version='' get_version='--version'

	case $1 in
		# ksh sends version to sdterr. Weeeeeeird.
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
		if [[ "${OSTYPE}" == "linux-gnu" || "${OSTYPE}" == "linux" ]]; then
			shell_type=$(ps -p $(ps -p $PPID -o pid --no-heading) -o cmd --no-heading)
			shell_type=${shell_type/-}
			shell_type=${shell_type//*\/}
		elif [[ "${distro}" == "Mac OS X" ]]; then
			shell_type=$(ps -p $(ps -p $PPID -o pid | tail -1) -o args| tail -1)
			shell_type=${shell_type/-}
			shell_type=${shell_type//*\/}
		elif [[ "${distro}" == "FreeBSD" || "${distro}" == "OpenBSD" ]]; then
			shell_type=$(ps -p $(ps -p $PPID -o pid | tail -1) -o args| tail -1)
			shell_type=${shell_type/-}
			shell_type=${shell_type//*\/}
		elif [[ "${distro}" == "Cygwin" ]]; then
			shell_type=$(echo "$SHELL" | awk -F'/' '{print $NF}')
		else
			shell_type=$(ps -p $(ps -p $PPID | awk '$1 !~ /PID/ {print $1}') | awk 'FNR>1 {print $1}')
			shell_type=${shell_type/-}
			shell_type=${shell_type//*\/}
		fi
	fi

	case $shell_type in
		bash)
			shell_version_data=$( detectshell_ver "$shell_type" "^GNU.bash,.version" "4" )
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
	esac

	if [[ -n $shell_version_data ]];then
		shell_type="$shell_type $shell_version_data"
	fi

	myShell=${shell_type}
	[[ "$verbosity" -eq "1" ]] && verboseOut "Finding current shell...found as '$myShell'"
}
# Shell Detection - End


# Resolution Detection - Begin
detectres () {
	if [[ -n ${DISPLAY} && ${distro} != "Mac OS X" && ${distro} != "Cygwin" ]]; then
		if [[ "$distro" =~ "BSD" ]]; then
			xResolution=$(xdpyinfo | sed -n 's/.*dim.* \([0-9]*x[0-9]*\) .*/\1/pg' | tr '\n' ' ')
		else
			xResolution=$(xdpyinfo | sed -n 's/.*dim.* \([0-9]*x[0-9]*\) .*/\1/pg' | sed ':a;N;$!ba;s/\n/ /g')
		fi
	elif [[ ${distro} == "Mac OS X" ]]; then
		xResolution=$(system_profiler SPDisplaysDataType | awk '/Resolution:/ {print $2"x"$4" "}')
	elif [[ "${distro}" == "Cygwin" ]]; then
		width=$(wmic desktopmonitor get screenwidth | grep -vE '[a-z]+' | tr -d '\r\n ')
		height=$(wmic desktopmonitor get screenheight | grep -vE '[a-z]+' | tr -d '\r\n ')
		xResolution="${width}x${height}"
	else
		xResolution="No X Server"
	fi
	[[ "$verbosity" -eq "1" ]] && verboseOut "Finding current resolution(s)...found as '$xResolution'"
}
# Resolution Detection - End


# DE Detection - Begin
detectde () {
	DE="Not Present"
	if [[ -n ${DISPLAY} && ${distro} != "Mac OS X" && ${distro} != "Cygwin" ]]; then
		if type -p xprop >/dev/null 2>&1;then
			xprop_root="$(xprop -root 2>/dev/null)"
			if [[ -n ${xprop_root} ]]; then
				DE=$(echo "${xprop_root}" | awk 'BEGIN {
					de = "Not Present"
				}
				{
					if ($1 ~ /^_DT_SAVE_MODE/) {
						de = $NF
						gsub(/\"/,"",de)
						de = toupper(de)
						exit
					}
					else if ($1 ~/^KDE_SESSION_VERSION/) {
						de = "KDE"$NF
						exit
					}
					else if ($1 ~ /^_MARCO/) {
						de = "MATE"
						exit
					}
					else if ($1 ~ /^_MUFFIN/) {
						de = "Cinnamon"
						exit
					}
					else if ($0 ~ /"xfce4"/) {
						de = "XFCE4"
						exit
					}
					else if ($0 ~ /"xfce5"/) {
						de = "XFCE5"
						exit
					}
				} END {
					print de
				}')
			fi
		fi

		if [[ ${DE} == "Not Present" ]]; then
			if [[ -n ${GNOME_DESKTOP_SESSION_ID} ]]; then
				DE="Gnome"
				if type -p xprop >/dev/null 2>&1; then
					if xprop -name "unity-launcher" >/dev/null 2>&1; then
						DE="Unity"
					elif xprop -name "launcher" >/dev/null 2>&1 &&
						xprop -name "panel" >/dev/null 2>&1; then

						DE="Unity"
					fi
				fi
			elif [[ -n ${MATE_DESKTOP_SESSION_ID} ]]; then
				DE="MATE"
			elif [[ -n ${KDE_SESSION_VERSION} ]]; then
				if [[ ${KDE_SESSION_VERSION} == '5' ]]; then
					DE="KDE5"
				elif [[ ${KDE_SESSION_VERSION} == '4' ]]; then
					DE="KDE4"
				fi
			elif [[ -n ${KDE_FULL_SESSION} ]]; then
				if [[ ${KDE_FULL_SESSION} == 'true' ]]; then
					DE="KDE"
					DEver_data=$( kded --version 2>/dev/null )
					DEver=$( grep -si '^KDE:' <<< "$DEver_data" | awk '{print $2}' )
				fi
			fi
		fi

		if [[ ${DE} != "Not Present" ]]; then
			if [[ ${DE} == "Cinnamon" ]]; then
				if type -p >/dev/null 2>&1; then
					DEver=$(cinnamon --version)
					DE="${DE} ${DEver//* }"
				fi
			elif [[ ${DE} == "Gnome" || ${DE} == "GNOME" ]]; then
				if type -p gnome-session-properties >/dev/null 2>&1; then
					DEver=$(gnome-session-properties --version)
					DE="${DE} ${DEver//* }"
				elif type -p gnome-session >/dev/null 2>&1; then
					DEver=$(gnome-session --version)
					DE="${DE} ${DEver//* }"
				fi
			elif [[ ${DE} == "KDE4" || ${DE} == "KDE5" ]]; then
				if type -p kded${DE#KDE} >/dev/null 2>&1; then
					DEver=$(kded${DE#KDE} --version)
					for l in $(echo "${DEver// /_}"); do
						if [[ ${l//:*} == "KDE_Development_Platform" ]]; then
							DEver=${l//*:_}
							DE="KDE ${DEver//_*}"
						fi;
					done
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
			fi
		fi

		if [[ "${DE}" == "Not Present" ]]; then
			if pgrep -U ${UID} lxsession >/dev/null 2>&1; then
				DE="LXDE"
				if type -p lxpanel >/dev/null 2>&1; then
					DEver=$(lxpanel -v)
					DE="${DE} $DEver"
				fi
			elif pgrep -U ${UID} razor-session >/dev/null 2>&1; then
				DE="RazorQt"
			fi
		fi
	elif [[ "${distro}" == "Mac OS X" ]]; then
		if ps -U ${USER} | grep [F]inder >/dev/null 2>&1; then
			DE="Aqua"
		fi
	elif [[ "${distro}" == "Cygwin" ]]; then
		winver=`wmic os get version | grep -o '^[0-9]'`
		if [ "$winver" == "7" ]; then DE='Aero'
		elif [ "$winver" == "6" ]; then DE='Aero'
		else DE='Luna'; fi
	fi
	[[ "$verbosity" -eq "1" ]] && verboseOut "Finding desktop environment...found as '$DE'"
}
### DE Detection - End


# WM Detection - Begin
detectwm () {
	WM="Not Found"
	if [[ -n ${DISPLAY} && ${distro} != "Mac OS X" && ${distro} != "Cygwin" ]]; then
		if type -p xprop >/dev/null 2>&1; then
			WM=$(xprop -root _NET_SUPPORTING_WM_CHECK)
			if [[ "$WM" =~ "not found" ]]; then
				WM="Not Found"
			elif [[ "$WM" =~ "invalid window id format" ]]; then
				WM="Not Found"
			elif [[ "$WM" =~ "no such" ]]; then
				WM="Not Found"
			else
				WM=${WM//* }
				WM=$(xprop -id ${WM} 8s _NET_WM_NAME)
				WM=$(echo $(WM=${WM//*= }; echo ${WM//\"}))
			fi
		fi

		if [[ ${WM} == "Not Found" ]]; then
			for each in $wmnames; do
				PID="$(pgrep -U ${UID} $each)"
				if [ "$PID" ]; then
					case $each in
						'awesome') WM="Awesome";;
						'beryl') WM="Beryl";;
						'blackbox') WM="Blackbox";;
						'cinnamon') WM="Cinnamon";;
						'compiz') WM="Compiz";;
						'dminiwm') WM="dminiwm";;
						'dwm') WM="DWM";;
						'e16') WM="E16";;
						'emerald') WM="Emerald";;
						'enlightenment') WM="E17";;
						'fluxbox') WM="FluxBox";;
						'fvwm') WM="FVWM";;
						'herbstluftwm') WM="herbstluftwm";;
						'icewm') WM="IceWM";;
						'kwin') WM="KWin";;
						'metacity') WM="Metacity";;
						'monsterwm') WM="monsterwm";;
						'musca') WM="Musca";;
						'openbox') WM="OpenBox";;
						'pekwm') WM="PekWM";;
						'ratpoison') WM="Ratpoison";;
						'sawfish') WM="Sawfish";;
						'scrotwm') WM="ScrotWM";;
						'spectrwm') WM="SpectrWM";;
						'stumpwm') WM="StumpWM";;
						'subtle') WM="subtle";;
						'wmaker') WM="WindowMaker";;
						'wmfs') WM="WMFS";;
						'wmii') WM="wmii";;
						'xfwm4') WM="Xfwm4";;
						'xmonad') WM="XMonad";;
						'i3') WM="i3";;
					esac
				fi

				if [[ ${WM} != "Not Found" ]]; then
					break 1
				fi
			done
		else
			case ${WM} in
				'awesome') WM="Awesome";;
				'blackbox') WM="Blackbox";;
				'beryl') WM="Beryl";;
				'cinnamon') WM="Cinnamon";;
				'compiz') WM="Compiz";;
				'dminiwm') WM="dminiwm";;
				'dwm') WM="DWM";;
				'e16') WM="E16";;
				'emerald') WM="Emerald";;
				'enlightenment') WM="E17";;
				'fluxbox') WM="FluxBox";;
				'fvwm') WM="FVWM";;
				'herbstluftwm') WM="herbstluftwm";;
				'^i3') WM="i3";;
				'icewm') WM="IceWM";;
				'kwin') WM="KWin";;
				'metacity') WM="Metacity";;
				'monsterwm') WM="monsterwm";;
				'musca') WM="Musca";;
				'openbox') WM="OpenBox";;
				'pekwm') WM="PekWM";;
				'ratpoison') WM="Ratpoison";;
				'scrotwm') WM="ScrotWM";;
				'spectrwm') WM="SpectrWM";;
				'sawfish') WM="Sawfish";;
				'stumpwm') WM="StumpWM";;
				'subtle') WM="subtle";;
				'wmaker') WM="WindowMaker";;
				'wmfs') WM="WMFS";;
				'wmii') WM="wmii";;
				'xfwm4') WM="Xfwm4";;
				'^xmonad') WM="XMonad";;
			esac
		fi
	elif [[ ${distro} == "Mac OS X" ]]; then
		if ps -U ${USER} | grep [F]inder >/dev/null 2>&1; then
			WM="Quartz Compositor"
		fi
	elif [[ "${distro}" == "Cygwin" ]]; then
		bugn=$(tasklist | grep -o 'bugn' | tr -d '\r \n')
		wind=$(tasklist | grep -o 'Windawesome' | tr -d '\r \n')
		if [ "$bugn" = "bugn" ]; then WM="bug.n"
		elif [ "$wind" = "Windawesome" ]; then WM="Windawesome"
		else WM="DWM"; fi
	fi
	[[ "$verbosity" -eq "1" ]] && verboseOut "Finding window manager...found as '$WM'"
}
# WM Detection - End


# WM Theme Detection - BEGIN
detectwmtheme () {
	Win_theme="Not Found"
	case $WM in
		'Awesome') if [ -f ${XDG_CONFIG_HOME:-${HOME}/.config}/awesome/rc.lua ]; then Win_theme="$(grep -e '^[^-].*\(theme\|beautiful\).*lua' ${XDG_CONFIG_HOME:-${HOME}/.config}/awesome/rc.lua | grep '[a-zA-Z0-9]\+/[a-zA-Z0-9]\+.lua' -o | cut -d'/' -f1 | head -n1)"; fi;;
		'BlackBox') if [ -f $HOME/.blackboxrc ]; then Win_theme="$(awk -F"/" '/styleFile/ {print $NF}' $HOME/.blackboxrc)"; fi;;
		'Beryl') Win_theme="Not Present";;
		'Cinnamon') Win_theme="$(gsettings get org.cinnamon.theme name)";;
		'Compiz'|'Mutter'*|'GNOME Shell')
			if type -p gsettings >/dev/null 2>&1; then
				Win_theme="$(gsettings get org.gnome.desktop.wm.preferences theme)"
				Win_theme=${Win_theme//"'"}
			elif type -p gconftool-2 >/dev/null 2>&1; then
				Win_theme=$(gconftool-2 -g /apps/metacity/general/theme)
			fi
		;;
		'dminiwm') Win_theme="Not Present";;
		'DWM') Win_theme="Not Present";;
		'E16') Win_theme="$(awk -F"= " '/theme.name/ {print $2}' $HOME/.e16/e_config--0.0.cfg)";;
		'E17'|'Enlightenment') 
			if [ "$(which eet 2>/dev/null)" ]; then
				econfig="$(eet -d $HOME/.e/e/config/standard/e.cfg config | awk '/value \"file\" string.*.edj/{ print $4 }')"
				econfigend="${econfig##*/}"
				Win_theme=${econfigend%.*}
			fi
		;;
		#E17 doesn't store cfg files in text format so for now get the profile as opposed to theme. atyoung
		#TODO: Find a way to extract and read E17 .cfg files ( google seems to have nothing ). atyoung
		'E17') Win_theme=${E_CONF_PROFILE};;
		'Emerald') if [ -f $HOME/.emerald/theme/theme.ini ]; then Win_theme="$(for a in /usr/share/emerald/themes/* $HOME/.emerald/themes/*; do cmp "$HOME/.emerald/theme/theme.ini" "$a/theme.ini" &>/dev/null && basename "$a"; done)"; fi;;
		'Finder') Win_theme="Not Present";;
		'FluxBox'|'Fluxbox') if [ -f $HOME/.fluxbox/init ]; then Win_theme="$(awk -F"/" '/styleFile/ {print $NF}' $HOME/.fluxbox/init)"; fi;;
		'FVWM') Win_theme="Not Present";;
		'i3') Win_theme="Not Present";;
		'IceWM') if [ -f $HOME/.icewm/theme ]; then Win_theme="$(awk -F"[\",/]" '!/#/ {print $2}' $HOME/.icewm/theme)"; fi;;
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
				Win_theme=$(awk '/PluginLib=kwin3_/{gsub(/PluginLib=kwin3_/,"",$0); print $0; exit}' $KDE_CONFIG_DIR/share/config/kwinrc)
				if [[ -z $Win_theme ]]; then
					if [[ -f $KDE_CONFIG_DIR/share/config/kdebugrc ]]; then
						Win_theme=$(awk '/(decoration)/ {gsub(/\[/,"",$1); print $1; exit}' $KDE_CONFIG_DIR/share/config/kdebugrc)
						if [[ -z $Win_theme ]]; then
							Win_theme="Not Found"
						fi
					else
						Win_theme="Not Found"
					fi
				fi

				if [[ $Win_theme != 'Not Found' ]]; then
					if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
						if [[ ${BASH_VERSINFO[0]} -eq 4 && ${BASH_VERSINFO[1]} -gt 1 ]] || [[ ${BASH_VERSINFO[0]} -gt 4 ]]; then
							Win_theme=${Win_theme^}
						else
							Win_theme="$(tr '[:lower:]' '[:upper:]' <<< ${Win_theme:0:1})${Win_theme:1}"
						fi
					else
						Win_theme="$(tr '[:lower:]' '[:upper:]' <<< ${Win_theme:0:1})${Win_theme:1}"
					fi
				fi
			fi
		;;
		'Marco')
			Win_theme="$(gsettings get org.mate.Marco.general theme)"
			Win_theme=${Win_theme//"'"}
		;;
		'Metacity') if [ "`gconftool-2 -g /apps/metacity/general/theme`" ]; then Win_theme="$(gconftool-2 -g /apps/metacity/general/theme)"; fi ;;
		'monsterwm') Win_theme="Not Present";;
		'Musca') Win_theme="Not Present";;
		'OpenBox'|'Openbox')
			if [ -f ${XDG_CONFIG_HOME:-${HOME}/.config}/openbox/rc.xml ]; then
				Win_theme="$(awk -F"[<,>]" '/<theme/ { getline; print $3 }' ${XDG_CONFIG_HOME:-${HOME}/.config}/openbox/rc.xml)";
			elif [[ -f ${XDG_CONFIG_HOME:-${HOME}/.config}/openbox/lxde-rc.xml && $DE == "LXDE" ]]; then
				Win_theme="$(awk -F"[<,>]" '/<theme/ { getline; print $3 }' ${XDG_CONFIG_HOME:-${HOME}/.config}/openbox/lxde-rc.xml)";
			fi
		;;
		'PekWM') if [ -f $HOME/.pekwm/config ]; then Win_theme="$(awk -F"/" '/Theme/ {gsub(/\"/,""); print $NF}' $HOME/.pekwm/config)"; fi;;
		'Ratpoison') Win_theme="Not Present";;
		'Sawfish') Win_theme="$(awk -F")" '/\(quote default-frame-style/{print $2}' $HOME/.sawfish/custom | sed 's/ (quote //')";;
		'ScrotWM') Win_theme="Not Present";;
		'SpectrWM') Win_theme="Not Present";;
		'subtle') Win_theme="Not Present";;
		'WindowMaker') Win_theme="Not Present";;
		'WMFS') Win_theme="Not Present";;
		'wmii') Win_theme="Not Present";;
		'Xfwm4') if [ -f ${XDG_CONFIG_HOME:-${HOME}/.config}/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml ]; then Win_theme="$(xfconf-query -c xfwm4 -p /general/theme)"; fi;;
		'XMonad') Win_theme="Not Present";;
	esac

	if [[ "${distro}" == "Cygwin" ]]; then
		themeFile="$(reg query 'HKCU\Software\Microsoft\Windows\CurrentVersion\Themes' /v 'CurrentTheme' | grep -o '[A-Z]:\\.*')"
		Win_theme=$(echo $themeFile | awk -F"\\" '{print $NF}' | grep -o '[0-9A-z. ]*$' | grep -o '^[0-9A-z ]*')
	fi

	[[ "$verbosity" -eq "1" ]] && verboseOut "Finding window manager theme...found as '$Win_theme'"
}
# WM Theme Detection - END

# GTK Theme\Icon\Font Detection - BEGIN
detectgtk () {
	gtk2Theme="Not Found"
	gtk3Theme="Not Found"
	gtkIcons="Not Found"
	gtkFont="Not Found"
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
				if grep -q "widgetStyle=" "${KDE_CONFIG_FILE}"; then
					gtk2Theme=$(awk -F"=" '/widgetStyle=/ {print $2}' "${KDE_CONFIG_FILE}")
				elif grep -q "colorScheme=" "${KDE_CONFIG_FILE}"; then
					gtk2Theme=$(awk -F"=" '/colorScheme=/ {print $2}' "${KDE_CONFIG_FILE}")
				fi

				if grep -q "Theme=" "${KDE_CONFIG_FILE}"; then
					gtkIcons=$(awk -F"=" '/Theme=/ {print $2}' "${KDE_CONFIG_FILE}")
				fi

				if grep -q "Font=" "${KDE_CONFIG_FILE}"; then
					gtkFont=$(awk -F"=" '/font=/ {print $2}' "${KDE_CONFIG_FILE}")
				fi
			fi

			if [[ -f $HOME/.gtkrc-2.0 ]]; then
				gtk2Theme=$(grep '^gtk-theme-name' $HOME/.gtkrc-2.0 | awk -F'=' '{print $2}')
				gtk2Theme=${gtk2Theme//\"/}
				gtkIcons=$(grep '^gtk-icon-theme-name' $HOME/.gtkrc-2.0 | awk -F'=' '{print $2}')
				gtkIcons=${gtkIcons//\"/}
				gtkFont=$(grep 'font_name' $HOME/.gtkrc-2.0 | awk -F'=' '{print $2}')
				gtkFont=${gtkFont//\"/}
			fi

			if [[ -f $HOME/.config/gtk-3.0/settings.ini ]]; then
				gtk3Theme=$(grep '^gtk-theme-name=' $HOME/.config/gtk-3.0/settings.ini | awk -F'=' '{print $2}')
			fi
		;;
		'Cinnamon'*) # Desktop Environment found as "Cinnamon"
			if type -p gsettings >/dev/null 2>&1; then
				gtk3Theme=$(gsettings get org.gnome.desktop.interface gtk-theme)
				gtk3Theme=${gtk3Theme//"'"}
				gtk2Theme=${gtk3Theme}

				gtkIcons=$(gsettings get org.gnome.desktop.interface icon-theme)
				gtkIcons=${gtkIcons//"'"}
				gtkFont=$(gsettings get org.gnome.desktop.interface font-name)
				gtkFont=${gtkFont//"'"}
				if [ "$background_detect" == "1" ]; then gtkBackground=$(gsettings get org.gnome.desktop.background picture-uri); fi
			fi
		;;
		'GNOME'*|'Gnome'*|'Unity'*) # Desktop Environment found as "GNOME"
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
			#if type -p gsettings >/dev/null 2&>1; then
			gtk3Theme=$(gsettings get org.mate.interface gtk-theme)
			# gtk3Theme=${gtk3Theme//"'"}
			gtk2Theme=${gtk3Theme}
			gtkIcons=$(gsettings get org.mate.interface icon-theme)
			gtkIcons=${gtkIcons//"'"}
			gtkFont=$(gsettings get org.mate.interface font-name)
			gtkFont=${gtkFont//"'"}
			#fi
		;;
		'XFCE'*) # Desktop Environment found as "XFCE"
			if type -p xfconf-query >/dev/null 2>&1; then
				gtk2Theme=$(xfconf-query -c xsettings -p /Net/ThemeName)
			fi

			if type -p xfconf-query >/dev/null 2>&1; then
				gtkIcons=$(xfconf-query -c xsettings -p /Net/IconThemeName)
			fi

			if type -p xfconf-query >/dev/null 2>&1; then
				gtkFont=$(xfconf-query -c xsettings -p /Gtk/FontName)
			fi
		;;
		'LXDE'*)
			if [ -f ${XDG_CONFIG_HOME:-${HOME}/.config}/lxde/config ]; then
				lxdeconf="/lxde/config"
			elif [ $distro == "Trisquel" ]; then
				lxdeconf=""
			elif [ "$distro" == "FreeBSD" ]; then
				lxdeconf=""
			else
				lxdeconf="/lxsession/LXDE/desktop.conf"
			fi
			# TODO: Clean me.
			if grep -q "sNet\/ThemeName" ${XDG_CONFIG_HOME:-${HOME}/.config}$lxdeconf 2>/dev/null; then
				gtk2Theme=$(awk -F'=' '/sNet\/ThemeName/ {print $2}' ${XDG_CONFIG_HOME:-${HOME}/.config}$lxdeconf)
			fi

			if grep -q IconThemeName ${XDG_CONFIG_HOME:-${HOME}/.config}$lxdeconf 2>/dev/null; then
				gtkIcons=$(awk -F'=' '/sNet\/IconThemeName/ {print $2}' ${XDG_CONFIG_HOME:-${HOME}/.config}$lxdeconf)
			fi

			if grep -q FontName ${XDG_CONFIG_HOME:-${HOME}/.config}$lxdeconf 2>/dev/null; then
				gtkFont=$(awk -F'=' '/sGtk\/FontName/ {print $2}' ${XDG_CONFIG_HOME:-${HOME}/.config}$lxdeconf)
			fi
		;;

		# /home/me/.config/rox.sourceforge.net/ROX-Session/Settings.xml

		*)	# Lightweight or No DE Found
			if [ -f $HOME/.gtkrc-2.0 ]; then
				if grep -q gtk-theme $HOME/.gtkrc-2.0; then
					gtk2Theme=$(awk -F'"' '/^gtk-theme/ {print $2}' $HOME/.gtkrc-2.0)
				fi

				if grep -q icon-theme $HOME/.gtkrc-2.0; then
					gtkIcons=$(awk -F'"' '/^gtk-icon-theme/ {print $2}' $HOME/.gtkrc-2.0)
				fi

				if grep -q font $HOME/.gtkrc-2.0; then
					gtkFont=$(awk -F'"' '/^gtk-font-name/ {print $2}' $HOME/.gtkrc-2.0)
				fi
			fi
			# $HOME/.gtkrc.mine theme detect only
			if [ -f $HOME/.gtkrc.mine ]; then
				if grep -q "^include" $HOME/.gtkrc.mine; then
					gtk2Theme=$(grep '^include.*gtkrc' $HOME/.gtkrc.mine | awk -F "/" '{ print $5 }')
				fi
				if grep -q "^gtk-icon-theme-name" $HOME/.gtkrc.mine; then
					gtkIcons=$(grep '^gtk-icon-theme-name' $HOME/.gtkrc.mine | awk -F '"' '{print $2}')
				fi
			fi
			# /etc/gtk-2.0/gtkrc compatability
			if [[ -f /etc/gtk-2.0/gtkrc && ! -f $HOME/.gtkrc-2.0 && ! -f $HOME/.gtkrc.mine ]]; then
				if grep -q gtk-theme-name /etc/gtk-2.0/gtkrc; then
					gtk2Theme=$(awk -F'"' '/^gtk-theme-name/ {print $2}' /etc/gtk-2.0/gtkrc)
				fi
				if grep -q gtk-fallback-theme-name /etc/gtk-2.0/gtkrc  && ! [ "x$gtk2Theme" = "x" ]; then
					gtk2Theme=$(awk -F'"' '/^gtk-fallback-theme-name/ {print $2}' /etc/gtk-2.0/gtkrc)
				fi

				if grep -q icon-theme /etc/gtk-2.0/gtkrc; then
					gtkIcons=$(awk -F'"' '/^icon-theme/ {print $2}' /etc/gtk-2.0/gtkrc)
				fi
				if  grep -q gtk-fallback-icon-theme /etc/gtk-2.0/gtkrc  && ! [ "x$gtkIcons" = "x" ]; then
					gtkIcons=$(awk -F'"' '/^gtk-fallback-icon-theme/ {print $2}' /etc/gtk-2.0/gtkrc)
				fi

				if grep -q font /etc/gtk-2.0/gtkrc; then
					gtkFont=$(awk -F'"' '/^gtk-font-name/ {print $2}' /etc/gtk-2.0/gtkrc)
				fi
			fi

			# EXPERIMENTAL gtk3 Theme detection
			if [ -f $HOME/.config/gtk-3.0/settings.ini ]; then
				if grep -q gtk-theme-name $HOME/.config/gtk-3.0/settings.ini; then
					gtk3Theme=$(awk -F'=' '/^gtk-theme-name/ {print $2}' $HOME/.config/gtk-3.0/settings.ini)
				fi
			fi

			# Proper gtk3 Theme detection
			#if [ $(which gsettings) ] && [ "$distro" != "Mac OS X" ]; then
			#	gtk3Theme="$(gsettings get org.gnome.desktop.interface gtk-theme | tr -d \"\'\")"
			#fi
			if type -p gsettings >/dev/null 2>&1; then
				gtk3Theme=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null)
				gtk3Theme=${gtk3Theme//"'"}
			fi

			# ROX-Filer icon detect only
			if [ -a ${XDG_CONFIG_HOME:-${HOME}/.config}/rox.sourceforge.net/ROX-Filer/Options ]; then
				gtkIcons=$(awk -F'[>,<]' '/^icon_theme/ {print $3}' ${XDG_CONFIG_HOME:-${HOME}/.config}/rox.sourceforge.net/ROX-Filer/Options)
			fi

			# E17 detection
			if [ $E_ICON_THEME ]; then
				gtkIcons=${E_ICON_THEME}
				gtk2Theme="Not available."
				gtkFont="Not available."
			fi

			# Background Detection (feh, nitrogen)
			if [ "$background_detect" == "1" ]; then
				if [ -a $HOME/.fehbg ]; then
					gtkBackgroundFull=$(awk -F"'" '/feh --bg/{print $2}' $HOME/.fehbg 2>/dev/null)
					gtkBackground=$(echo "$gtkBackgroundFull" | awk -F"/" '{print $NF}')
				elif [ -a ${XDG_CONFIG_HOME:-${HOME}/.config}/nitrogen/bg-saved.cfg ]; then
					gtkBackground=$(awk -F"/" '/file=/ {print $NF}' ${XDG_CONFIG_HOME:-${HOME}/.config}/nitrogen/bg-saved.cfg)
				fi
			fi

			# Font detection (OS X)
			if [[ ${distro} == "Mac OS X" ]]; then
				if ps -U ${USER} | grep [F]inder >/dev/null 2>&1; then
					gtkFont="Not Found"
					if [ -f ~/Library/Preferences/com.googlecode.iterm2.plist ]; then
						gtkFont=$(str1=$(defaults read com.googlecode.iTerm2|grep -m 1 "Normal Font");echo ${str1:29:${#str1}-29-2})
					fi
				fi
			fi

			if [ "$distro" == "Cygwin" -a "$gtkFont" == "Not Found" ]; then
				if [ -f $HOME/.minttyrc ]; then
					gtkFont="$(cat $HOME/.minttyrc | grep '^Font=.*' | grep -o '[0-9A-z ]*$')"
				fi
			fi
		;;
	esac
	if [[ "$verbosity" -eq "1" ]]; then
		verboseOut "Finding GTK2 theme...found as '$gtk2Theme'"
		verboseOut "Finding GTK3 theme...found as '$gtk3Theme'"
		verboseOut "Finding icon theme...found as '$gtkIcons'"
		verboseOut "Finding user font...found as '$gtkFont'"
		[[ $gtkBackground ]] && verboseOut "Finding background...found as '$gtkBackground'"
	fi
}
# GTK Theme\Icon\Font Detection - END

# Android-specific detections
detectdroid () {
	distro_ver=$(getprop ro.build.version.release)

	hostname=$(getprop net.hostname)

	_device=$(getprop ro.product.device)
	_model=$(getprop ro.product.model)
	device="${_model} (${_device})"

	if [[ $(getprop ro.build.host) == "cyanogenmod" ]]; then
		rom=$(getprop ro.cm.version)
	else
		rom=$(getprop ro.build.display.id)
	fi

	baseband=$(getprop ro.baseband)

	cpu=$(grep '^Processor' /proc/cpuinfo)
	cpu=$(echo "$cpu" | sed 's/Processor.*: //')
}


#######################
# End Detection Phase
#######################

takeShot () {
	if [[ -z $screenCommand ]]; then
		if [[ "$hostshot" == "1" ]]; then
			if [ "$distro" == "Mac OS X" ]; then screencapture -x -T 3 ${serverdir}${shotfile} &> /dev/null
			else scrot -cd3 "${shotfile}"; fi
			if [ -f "${shotfile}" ]; then
				[[ "$verbosity" -eq "1" ]] && verboseOut "Screenshot saved at '${shotfile}'"
				scp -qo ConnectTimeout="${scptimeout}" "${shotfile}" "${serveraddr}:${serverdir}"
				echo -e "${bold}==>${c0} Your screenshot can be viewed at ${baseurl}/$shotfile"
			else
				verboseOut "ERROR: Problem saving screenshot to ${shotfile}"
			fi
		else
			if [ "$distro" == "Mac OS X" ]; then screencapture -x -T 3 "${shotfile} 2>dev/null"
			else scrot -cd3 "${shotfile}"; fi
			if [ -f "${shotfile}" ]; then
				[[ "$verbosity" -eq "1" ]] && verboseOut "Screenshot saved at '${shotfile}'"
			else
				verboseOut "ERROR: Problem saving screenshot to ${shotfile}"
			fi
		fi
	else
		$screenCommand
	fi
}



asciiText () {
# Distro logos and ASCII outputs
	if [[ "$fake_distro" ]]; then distro="${fake_distro}"; fi
	if [[ "$asc_distro" ]]; then myascii="${asc_distro}"
	else myascii="${distro}"; fi
	case ${myascii} in
		"Arch Linux - Old")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;37m" # White
				c2="\e[1;34m" # Light Blue
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			fulloutput=("$c1              __                      %s"
"$c1          _=(SDGJT=_                 %s"
"$c1        _GTDJHGGFCVS)                %s"
"$c1       ,GTDJGGDTDFBGX0               %s"
"$c1      JDJDIJHRORVFSBSVL$c2-=+=,_        %s"
"$c1     IJFDUFHJNXIXCDXDSV,$c2  \"DEBL      %s"
"$c1    [LKDSDJTDU=OUSCSBFLD.$c2   '?ZWX,   %s"
"$c1   ,LMDSDSWH'     \`DCBOSI$c2     DRDS], %s"
"$c1   SDDFDFH'         !YEWD,$c2   )HDROD  %s"
"$c1  !KMDOCG            &GSU|$c2\_GFHRGO\'  %s"
"$c1  HKLSGP'$c2           __$c1\TKM0$c2\GHRBV)'  %s"
"$c1 JSNRVW'$c2       __+MNAEC$c1\IOI,$c2\BN'     %s"
"$c1 HELK['$c2    __,=OFFXCBGHC$c1\FD)         %s"
"$c1 ?KGHE $c2\_-#DASDFLSV='$c1    'EF         %s"
"$c1 'EHTI                    !H         %s"
"$c1  \`0F'                    '!         %s")
		;;

		"Arch Linux")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;36m" # Light
				c2="\e[0;36m" # Dark
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="1"
			fulloutput=("${c1}                   -\`"
"${c1}                  .o+\`                 %s"
"${c1}                 \`ooo/                %s"
"${c1}                \`+oooo:               %s"
"${c1}               \`+oooooo:              %s"
"${c1}               -+oooooo+:             %s"
"${c1}             \`/:-:++oooo+:            %s"
"${c1}            \`/++++/+++++++:           %s"
"${c1}           \`/++++++++++++++:          %s"
"${c1}          \`/+++o"${c2}"oooooooo"${c1}"oooo/\`        %s"
"${c2}         "${c1}"./"${c2}"ooosssso++osssssso"${c1}"+\`       %s"
"${c2}        .oossssso-\`\`\`\`/ossssss+\`      %s"
"${c2}       -osssssso.      :ssssssso.     %s"
"${c2}      :osssssss/        osssso+++.    %s"
"${c2}     /ossssssss/        +ssssooo/-    %s"
"${c2}   \`/ossssso+/:-        -:/+osssso+-  %s"
"${c2}  \`+sso+:-\`                 \`.-/+oso: %s"
"${c2} \`++:.                           \`-/+/  %s"
"${c2} .\`                                 \`/")
		;;

		"Mint")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;37m" # White
				c2="\e[1;32m" # Bold Green
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			fulloutput=("$c2 MMMMMMMMMMMMMMMMMMMMMMMMMmds+.        %s"
"$c2 MMm----::-://////////////oymNMd+\`    %s"
"$c2 MMd      "$c1"/++                "$c2"-sNMd:   %s"
"$c2 MMNso/\`  "$c1"dMM    \`.::-. .-::.\` "$c2".hMN:  %s"
"$c2 ddddMMh  "$c1"dMM   :hNMNMNhNMNMNh: "$c2"\`NMm  %s"
"$c2     NMm  "$c1"dMM  .NMN/-+MMM+-/NMN\` "$c2"dMM  %s"
"$c2     NMm  "$c1"dMM  -MMm  \`MMM   dMM. "$c2"dMM  %s"
"$c2     NMm  "$c1"dMM  -MMm  \`MMM   dMM. "$c2"dMM  %s"
"$c2     NMm  "$c1"dMM  .mmd  \`mmm   yMM. "$c2"dMM  %s"
"$c2     NMm  "$c1"dMM\`  ..\`   ...   ydm. "$c2"dMM  %s"
"$c2     hMM- "$c1"+MMd/-------...-:sdds  "$c2"dMM  %s"
"$c2     -NMm- "$c1":hNMNNNmdddddddddy/\`  "$c2"dMM  %s"
"$c2      -dMNs-"$c1"\`\`-::::-------.\`\`    "$c2"dMM  %s"
"$c2       \`/dMNmy+/:-------------:/yMMM  %s"
"$c2          ./ydNMMMMMMMMMMMMMMMMMMMMM  %s"
"$c2             \.MMMMMMMMMMMMMMMMMMM    %s")
		;;


		"LMDE")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;37m" # White
				c2="\e[1;32m" # Bold Green
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="1"
			fulloutput=("          "${c1}"\`.-::---.."
"${c2}       .:++++ooooosssoo:.       %s"
"${c2}     .+o++::.      \`.:oos+.    %s"
"${c2}    :oo:.\`             -+oo"${c1}":   %s"
"${c2}  "${c1}"\`"${c2}"+o/\`    ."${c1}"::::::"${c2}"-.    .++-"${c1}"\`  %s"
"${c2} "${c1}"\`"${c2}"/s/    .yyyyyyyyyyo:   +o-"${c1}"\`  %s"
"${c2} "${c1}"\`"${c2}"so     .ss       ohyo\` :s-"${c1}":  %s"
"${c2} "${c1}"\`"${c2}"s/     .ss  h  m  myy/ /s\`"${c1}"\`  %s"
"${c2} \`s:     \`oo  s  m  Myy+-o:\`   %s"
"${c2} \`oo      :+sdoohyoydyso/.     %s"
"${c2}  :o.      .:////////++:       %s"
"${c2}  \`/++        "${c1}"-:::::-          %s"
"${c2}   "${c1}"\`"${c2}"++-                        %s"
"${c2}    "${c1}"\`"${c2}"/+-                       %s"
"${c2}      "${c1}"."${c2}"+/.                     %s"
"${c2}        "${c1}"."${c2}":+-.                  %s"
"${c2}           \`--.\`\`              %s")
		;;

		"Ubuntu")
			if [[ "$no_color" != "1" ]]; then
				c1="\033[1;37m" # White
				c2="\033[1;31m" # Light Red
				c3="\033[1;33m" # Bold Yellow
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; c3="${my_lcolor}"; fi
			startline="1"
			fulloutput=("$c2                          ./+o+-"
"$c1                  yyyyy- $c2-yyyyyy+      %s"
"$c1               $c1://+//////$c2-yyyyyyo     %s"
"$c3           .++ $c1.:/++++++/-$c2.+sss/\`     %s"
"$c3         .:++o:  $c1/++++++++/:--:/-     %s"
"$c3        o:+o+:++.$c1\`..\`\`\`.-/oo+++++/    %s"
"$c3       .:+o:+o/.$c1          \`+sssoo+/   %s"
"$c1  .++/+:$c3+oo+o:\`$c1             /sssooo.  %s"
"$c1 /+++//+:$c3\`oo+o$c1               /::--:.  %s"
"$c1 \+/+o+++$c3\`o++o$c2               ++////.  %s"
"$c1  .++.o+$c3++oo+:\`$c2             /dddhhh.  %s"
"$c3       .+.o+oo:.$c2          \`oddhhhh+   %s"
"$c3        \+.++o+o\`\`-\`\`$c2\`\`.:ohdhhhhh+    %s"
"$c3         \`:o+++ $c2\`ohhhhhhhhyo++os:     %s"
"$c3           .o:$c2\`.syhhhhhhh/$c3.oo++o\`     %s"
"$c2               /osyyyyyyo$c3++ooo+++/    %s"
"$c2                   \`\`\`\`\` $c3+oo+++o\:    %s"
"$c3                          \`oo++.")
		;;

		"Debian")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;37m" # White
				c2="\e[1;31m" # Light Red
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
                        fulloutput=("  $c1       _,met\$\$\$\$\$gg.           %s"
"  $c1    ,g\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$P.       %s"
"  $c1  ,g\$\$P\"\"       \"\"\"Y\$\$.\".     %s"
"  $c1 ,\$\$P'              \`\$\$\$.     %s"
"  $c1',\$\$P       ,ggs.     \`\$\$b:   %s"
"  $c1\`d\$\$'     ,\$P\"\'   $c2.$c1    \$\$\$    %s"
"  $c1 \$\$P      d\$\'     $c2,$c1    \$\$P    %s"
"  $c1 \$\$:      \$\$.   $c2-$c1    ,d\$\$'    %s"
"  $c1 \$\$\;      Y\$b._   _,d\$P'     %s"
"  $c1 Y\$\$.    $c2\`.$c1\`\"Y\$\$\$\$P\"'         %s"
"  $c1 \`\$\$b      $c2\"-.__              %s"
"  $c1  \`Y\$\$                        %s"
"  $c1   \`Y\$\$.                      %s"
"  $c1     \`\$\$b.                    %s"
"  $c1       \`Y\$\$b.                 %s"
"  $c1          \`\"Y\$b._             %s"
"  $c1              \`\"\"\"\"")
		;;


		"CrunchBang")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;37m" # White
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="1"
            fulloutput=("$c2                                   "
"$c2         "$c1"███"$c2"        "$c1"███"$c2"          "$c1"███"$c2"   %s"
"$c2         "$c1"███"$c2"        "$c1"███"$c2"          "$c1"███"$c2"  %s"
"$c2         "$c1"███"$c2"        "$c1"███"$c2"          "$c1"███"$c2"  %s"
"$c2         "$c1"███"$c2"        "$c1"███"$c2"          "$c1"███"$c2"  %s"
"$c2  "$c1"████████████████████████████"$c2"   "$c1"███"$c2"  %s"
"$c2  "$c1"████████████████████████████"$c2"   "$c1"███"$c2"  %s"
"$c2         "$c1"███"$c2"        "$c1"███"$c2"          "$c1"███"$c2"  %s"
"$c2         "$c1"███"$c2"        "$c1"███"$c2"          "$c1"███"$c2"  %s"
"$c2         "$c1"███"$c2"        "$c1"███"$c2"          "$c1"███"$c2"  %s"
"$c2         "$c1"███"$c2"        "$c1"███"$c2"          "$c1"███"$c2"  %s"
"$c2  "$c1"████████████████████████████"$c2"   "$c1"███"$c2"  %s"
"$c2  "$c1"████████████████████████████"$c2"   "$c1"███"$c2"  %s"
"$c2         "$c1"███"$c2"        "$c1"███"$c2"               %s"
"$c2         "$c1"███"$c2"        "$c1"███"$c2"               %s"
"$c2         "$c1"███"$c2"        "$c1"███"$c2"          "$c1"███"$c2"  %s"
"$c2         "$c1"███"$c2"        "$c1"███"$c2"          "$c1"███"$c2"  %s"
"$c2                                     %s")
		;;

		"Gentoo")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;37m" # White
				c2="\e[1;35m" # Light Purple
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="1"
			fulloutput=("$c2         -/oyddmdhs+:."
"$c2     -o"$c1"dNMMMMMMMMNNmhy+"$c2"-\`             %s"
"$c2   -y"$c1"NMMMMMMMMMMMNNNmmdhy"$c2"+-          %s"
"$c2 \`o"$c1"mMMMMMMMMMMMMNmdmmmmddhhy"$c2"/\`       %s"
"$c2 om"$c1"MMMMMMMMMMMN"$c2"hhyyyo"$c1"hmdddhhhd"$c2"o\`     %s"
"$c2.y"$c1"dMMMMMMMMMMd"$c2"hs++so/s"$c1"mdddhhhhdm"$c2"+\`   %s"
"$c2 oy"$c1"hdmNMMMMMMMN"$c2"dyooy"$c1"dmddddhhhhyhN"$c2"d.  %s"
"$c2  :o"$c1"yhhdNNMMMMMMMNNNmmdddhhhhhyym"$c2"Mh  %s"
"$c2    .:"$c1"+sydNMMMMMNNNmmmdddhhhhhhmM"$c2"my  %s"
"$c2       /m"$c1"MMMMMMNNNmmmdddhhhhhmMNh"$c2"s:  %s"
"$c2    \`o"$c1"NMMMMMMMNNNmmmddddhhdmMNhs"$c2"+\`   %s"
"$c2  \`s"$c1"NMMMMMMMMNNNmmmdddddmNMmhs"$c2"/.     %s"
"$c2 /N"$c1"MMMMMMMMNNNNmmmdddmNMNdso"$c2":\`       %s"
"$c2+M"$c1"MMMMMMNNNNNmmmmdmNMNdso"$c2"/-          %s"
"$c2yM"$c1"MNNNNNNNmmmmmNNMmhs+/"$c2"-\`              %s"
"$c2/h"$c1"MMNNNNNNNNMNdhs++/"$c2"-\`               %s"
"$c2\`/"$c1"ohdmmddhys+++/:"$c2".\`                  %s"
"$c2  \`-//////:--.")
		;;

		"Fedora")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;37m" # White
				c2="\e[1;34m" # Light Blue
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			fulloutput=("$c2           :/------------://          %s"
"$c2        :------------------://       %s"
"$c2      :-----------"$c1"/shhdhyo/"$c2"-://      %s"
"$c2    /-----------"$c1"omMMMNNNMMMd/"$c2"-:/     %s"
"$c2   :-----------"$c1"sMMMdo:/"$c2"       -:/    %s"
"$c2  :-----------"$c1":MMMd"$c2"-------    --:/   %s"
"$c2  /-----------"$c1":MMMy"$c2"-------    ---/   %s"
"$c2 :------    --"$c1"/+MMMh/"$c2"--        ---:  %s"
"$c2 :---     "$c1"oNMMMMMMMMMNho"$c2"     -----:  %s"
"$c2 :--      "$c1"+shhhMMMmhhy++"$c2"   ------:   %s"
"$c2 :-      -----"$c1":MMMy"$c2"--------------/   %s"
"$c2 :-     ------"$c1"/MMMy"$c2"-------------:    %s"
"$c2 :-      ----"$c1"/hMMM+"$c2"------------:     %s"
"$c2 :--"$c1":dMMNdhhdNMMNo"$c2"-----------:       %s"
"$c2 :---"$c1":sdNMMMMNds:"$c2"----------:         %s"
"$c2 :------"$c1":://:"$c2"-----------://          %s"
"$c2 :--------------------://")
		;;

		"FreeBSD")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;37m" # Red
				c2="\e[1;31m" # Light Red
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="1"
			fulloutput=(
"   "$c1"\`\`\`                        "$c2"\`  "
"  "$c1"\` \`.....---..."$c2"....--.\`\`\`   -/       %s"  #user@host
"  "$c1"+o   .--\`         "$c2"/y:\`      +.     %s"  # OS
"  "$c1" yo\`:.            "$c2":o      \`+-      %s"  # Kernel
"    "$c1"y/               "$c2"-/\`   -o/       %s"  # Uptime
"   "$c1".-                  "$c2"::/sy+:.      %s"  # Packages
"   "$c1"/                     "$c2"\`--  /      %s"  # Shell
"  "$c1"\`:                          "$c2":\`     %s"  # Resolution
"  "$c1"\`:                          "$c2":\`     %s"  # DE
"   "$c1"/                          "$c2"/      %s"  # WM
"   "$c1".-                        "$c2"-.      %s"  # WM Theme
"    "$c1"--                      "$c2"-.       %s"  # GTK2 Theme
"     "$c1"\`:\`                  "$c2"\`:\`        %s"  # GTK3 Theme
"       "$c2".--             \`--.          %s"               # Icon Theme
"         "$c2" .---.....----.             %s"             # Font
"                                     %s"             # RAM
)
                ;;

		"OpenBSD")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;33m" # Light Yellow
				c2="\e[0;33m" # Bold Yellow
				c3="\e[1;36m" # Light Cyan
				c4="\e[1;31m" # Light Red
				c5="\e[1;37m"
				c6="\e[1;30m"
			fi
			if [ -n "${my_lcolor}" ]; then c1="$my_lcolor"; c2="${my_color}"; fi
			startline="5"
			fulloutput=(
 "                                       "$c3" _      "
"                                       "$c3"(_)      "
""$c1"              |    .                            "
""$c1"          .   |L  /|   .         "$c3" _        "
""$c1"      _ . |\ _| \--+._/| .       "$c3"(_)       "
""$c1"     / ||\| Y J  )   / |/| ./            %s"   # Host
""$c1"    J  |)'( |        \` F\`.'/       "$c3" _   %s"   # OS
""$c1"  -<|  F         __     .-<        "$c3"(_)  %s"   # Kernel
""$c1"    | /       .-'"$c3". "$c1"\`.  /"$c3"-. "$c1"L___         %s" # Uptime
""$c1"    J \      <    "$c3"\ "$c1" | | "$c6"O"$c3"\\\\"$c1"|.-' "$c3" _      %s" # Package
""$c1"  _J \  .-    \\\\"$c3"/ "$c6"O "$c3"| "$c1"| \  |"$c1"F    "$c3"(_)     %s" # Shell
""$c1" '-F  -<_.     \   .-'  \`-' L__         %s"
""$c1"__J  _   _.     >-'  "$c2")"$c4"._.   "$c1"|-'         %s         "
""$c1" \`-|.'   /_.          "$c4"\_|  "$c1" F           %s     "
""$c1"  /.-   .                _.<            %s"
""$c1" /'    /.'             .'  \`\           %s"
""$c1"  /L  /'   |/      _.-'-\               %s "
""$c1" /'J       ___.---'\|                   %s"
""$c1"   |\  .--' V  | \`. \`                   %s "
""$c1"   |/\`. \`-.     \`._)                    %s"
""$c1"      / .-.\                            %s"
""$c1"      \ (  \`\                           "
""$c1"       \`.\                                  "
)
		;;

		"DragonFlyBSD")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;31m" # Red
				c2="\e[1;37m" # White
				c3="\e[1;33m" #
				c4="\e[0;31m"
			fi
			startline="0"
			fulloutput=("                     "$c1" |                     %s"
"                    "$c1" .-.                   %s"
"                   "$c3" ()"$c1"I"$c3"()                  %s"
"              "$c1" \"==.__:-:__.==\"             %s"
"              "$c1"\"==.__/~|~\__.==\"            %s"
"              "$c1"\"==._(  Y  )_.==\"            %s"
"   "$c2".-'~~\"\"~=--...,__"$c1"\/|\/"$c2"__,...--=~\"\"~~'-. %s"
"  "$c2"(               ..="$c1"\\\\="$c1"/"$c2"=..               )%s"
"   "$c2"\`'-.        ,.-\"\`;"$c1"/=\\\\"$c2" ;\"-.,_        .-'\`%s"
"      "$c2" \`~\"-=-~\` .-~\` "$c1"|=|"$c2" \`~-. \`~-=-\"~\`     %s"
"       "$c2"     .-~\`    /"$c1"|=|"$c2"\    \`~-.          %s"
"       "$c2"  .~\`       / "$c1"|=|"$c2" \       \`~.       %s"
" "$c2"    .-~\`        .'  "$c1"|=|"$c2"  \\\\\`.        \`~-.  %s"
" "$c2"  (\`     _,.-=\"\`  "$c1"  |=|"$c2"    \`\"=-.,_     \`) %s"
" "$c2"   \`~\"~\"\`        "$c1"   |=|"$c2"           \`\"~\"~\`  %s"
"                   "$c1"  /=\                   %s"
"                   "$c1"  \=/                          %s"
"                   "$c1"   ^                           %s"
)
		;;

		"NetBSD")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;31m" # Light Red
				c2="\e[1;37m" # White
			fi
			startline="2"
			fulloutput=(
"                                  "$c1"__,gnnnOCCCCCOObaau,_         "
"   "$c2"_._                    "$c1"__,gnnCCCCCCCCOPF\"''                 "
"  "$c2"(N\\\\\\\\"$c1"XCbngg,._____.,gnnndCCCCCCCCCCCCF\"___,,,,___           %s"
"   "$c2"\\\\N\\\\\\\\"$c1"XCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCOOOOPYvv.     %s"
"    "$c2"\\\\N\\\\\\\\"$c1"XCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCPF\"''               %s"
"     "$c2"\\\\N\\\\\\\\"$c1"XCCCCCCCCCCCCCCCCCCCCCCCCCOF\"'                     %s"
"      "$c2"\\\\N\\\\\\\\"$c1"XCCCCCCCCCCCCCCCCCCCCOF\"'                         %s"
"       "$c2"\\\\N\\\\\\\\"$c1"XCCCCCCCCCCCCCCCPF\"'                             %s"
"        "$c2"\\\\N\\\\\\\\"$c1"\"PCOCCCOCCFP\"\"                                  %s"
"         "$c2"\\\\N\                                                %s"
"          "$c2"\\\\N\                                               %s"
"           "$c2"\\\\N\                                              %s"
"            "$c2"\\\\NN\                                            %s"
"             "$c2"\\\\NN\                                           %s"
"              "$c2"\\\\NNA.                                         %s"
"               "$c2"\\\\NNA,                                        %s"
"                "$c2"\\\\NNN,                                       %s"
"                 "$c2"\\\\NNN\                                      %s"
"                  "$c2"\\\\NNN\ "
"                   "$c2"\\\\NNNA")
		;;

		"Mandriva"|"Mandrake")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;34m" # Light Blue
				c2="\e[1;33m" # Bold Yellow
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			fulloutput=("$c2                         \`\`               %s"
"$c2                        \`-.              %s"
"$c1       \`               $c2.---              %s"
"$c1     -/               $c2-::--\`             %s"
"$c1   \`++    $c2\`----...\`\`\`-:::::.             %s"
"$c1  \`os.      $c2.::::::::::::::-\`\`\`     \`  \` %s"
"$c1  +s+         $c2.::::::::::::::::---...--\` %s"
"$c1 -ss:          $c2\`-::::::::::::::::-.\`\`.\`\` %s"
"$c1 /ss-           $c2.::::::::::::-.\`\`   \`    %s"
"$c1 +ss:          $c2.::::::::::::-            %s"
"$c1 /sso         $c2.::::::-::::::-            %s"
"$c1 .sss/       $c2-:::-.\`   .:::::            %s"
"$c1  /sss+.    $c2..\`$c1  \`--\`    $c2.:::            %s"
"$c1   -ossso+/:://+/-\`        $c2.:\`           %s"
"$c1     -/+ooo+/-.              $c2\`           %s"
"                                         %s")
		;;

		"openSUSE")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;32m" # Bold Green
				c2="\e[1;37m" # Bold White
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="1"
			fulloutput=("$c2             .;ldkO0000Okdl;."
"$c2         .;d00xl:,'....';:ok00d;.            %s"
"$c2       .d00l'                ,o00d.         %s"
"$c2     .d0Kd."$c1" :Okxol:;'.          "$c2":O0d.       %s"
"$c2    'OK"$c1"KKK0kOKKKKKKKKKKOxo:'      "$c2"lKO'      %s"
"$c2   ,0K"$c1"KKKKKKKKKKKKKKK0d:"$c2",,,"$c1":dx:"$c2"    ;00,     %s"
"$c2  .OK"$c1"KKKKKKKKKKKKKKKk."$c2".oOkdl."$c1"'0k."$c2"   cKO.    %s"
"$c2  :KK"$c1"KKKKKKKKKKKKKKK: "$c2"kKx..od "$c1"lKd"$c2"   .OK:    %s"
"$c2  dKK"$c1"KKKKKKKKKOx0KKKd "$c2";0KKKO, "$c1"kKKc"$c2"   dKd    %s"
"$c2  dKK"$c1"KKKKKKKKKK;.;oOKx,.."$c2"'"$c1"..;kKKK0."$c2"  dKd    %s"
"$c2  :KK"$c1"KKKKKKKKKK0o;...;cdxxOK0Oxc,.  "$c2".0K:    %s"
"$c2   kKK"$c1"KKKKKKKKKKKKK0xl;'......,cdo  "$c2"lKk     %s"
"$c2   '0K"$c1"KKKKKKKKKKKKKKKKKKKK00KKOo;  "$c2"c00'     %s"
"$c2    .kK"$c1"KKOxddxkOO00000Okxoc;'.   "$c2".dKk.      %s"
"$c2      l0Ko.                    .c00l.       %s"
"$c2       .l0Kk:.              .;xK0l.         %s"
"$c2          ,lkK0xl:;,,,,;:ldO0kl,            %s"
"$c2              .':ldxkkkkxdl:'.")
		;;

		"Slackware")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;34m" # Light Blue
				c2="\e[1;37m" # Bold White
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="2"
			fulloutput=("$c1                   :::::::"
"$c1             :::::::::::::::::::"
"$c1          :::::::::::::::::::::::::            %s"
"$c1        ::::::::"${c2}"cllcccccllllllll"${c1}"::::::        %s"
"$c1     :::::::::"${c2}"lc               dc"${c1}":::::::      %s"
"$c1    ::::::::"${c2}"cl   clllccllll    oc"${c1}":::::::::    %s"
"$c1   :::::::::"${c2}"o   lc"${c1}"::::::::"${c2}"co   oc"${c1}"::::::::::   %s"
"$c1  ::::::::::"${c2}"o    cccclc"${c1}":::::"${c2}"clcc"${c1}"::::::::::::  %s"
"$c1  :::::::::::"${c2}"lc        cclccclc"${c1}":::::::::::::  %s"
"$c1 ::::::::::::::"${c2}"lcclcc          lc"${c1}":::::::::::: %s"
"$c1 ::::::::::"${c2}"cclcc"${c1}":::::"${c2}"lccclc     oc"${c1}"::::::::::: %s"
"$c1 ::::::::::"${c2}"o    l"${c1}"::::::::::"${c2}"l    lc"${c1}"::::::::::: %s"
"$c1  :::::"${c2}"cll"${c1}":"${c2}"o     clcllcccll     o"${c1}":::::::::::  %s"
"$c1  :::::"${c2}"occ"${c1}":"${c2}"o                  clc"${c1}":::::::::::  %s"
"$c1   ::::"${c2}"ocl"${c1}":"${c2}"ccslclccclclccclclc"${c1}":::::::::::::   %s"
"$c1    :::"${c2}"oclcccccccccccccllllllllllllll"${c1}":::::    %s"
"$c1     ::"${c2}"lcc1lcccccccccccccccccccccccco"${c1}"::::     %s"
"$c1       ::::::::::::::::::::::::::::::::       %s"
"$c1         ::::::::::::::::::::::::::::"
"$c1            ::::::::::::::::::::::"
"$c1                 ::::::::::::")
		;;

		"Red Hat Linux")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;37m" # White
				c2="\e[1;31m" # Light Red
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			fulloutput=("$c2              \`.-..........\`               %s"
"$c2             \`////////::.\`-/.             %s"
"$c2             -: ....-////////.            %s"
"$c2             //:-::///////////\`           %s"
"$c2      \`--::: \`-://////////////:           %s"
"$c2      //////-    \`\`.-:///////// .\`        %s"
"$c2      \`://////:-.\`    :///////::///:\`     %s"
"$c2        .-/////////:---/////////////:     %s"
"$c2           .-://////////////////////.     %s"
"$c1          yMN+\`.-$c2::///////////////-\`      %s"
"$c1       .-\`:NMMNMs\`  \`..-------..\`         %s"
"$c1        MN+/mMMMMMhoooyysshsss            %s"
"$c1 MMM    MMMMMMMMMMMMMMyyddMMM+            %s"
"$c1  MMMM   MMMMMMMMMMMMMNdyNMMh\`     hyhMMM %s"
"$c1   MMMMMMMMMMMMMMMMyoNNNMMM+.   MMMMMMMM  %s"
"$c1    MMNMMMNNMMMMMNM+ mhsMNyyyyMNMMMMsMM   %s")
		;;

		"Frugalware")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;37m" # White
				c2="\e[1;36m" # Light Blue
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="4"
			fulloutput=("${c2}          \`++/::-.\`"
"${c2}         /o+++++++++/::-.\`"
"${c2}        \`o+++++++++++++++o++/::-.\`"
"${c2}        /+++++++++++++++++++++++oo++/:-.\`\`"
"${c2}       .o+ooooooooooooooooooosssssssso++oo++/:-\`   %s"
"${c2}       ++osoooooooooooosssssssssssssyyo+++++++o:  %s"
"${c2}      -o+ssoooooooooooosssssssssssssyyo+++++++s\`  %s"
"${c2}      o++ssoooooo++++++++++++++sssyyyyo++++++o:   %s"
"${c2}     :o++ssoooooo"${c1}"/-------------"${c2}"+syyyyyo+++++oo    %s"
"${c2}    \`o+++ssoooooo"${c1}"/-----"${c2}"+++++ooosyyyyyyo++++os:    %s"
"${c2}    /o+++ssoooooo"${c1}"/-----"${c2}"ooooooosyyyyyyyo+oooss     %s"
"${c2}   .o++++ssooooos"${c1}"/------------"${c2}"syyyyyyhsosssy-     %s"
"${c2}   ++++++ssooooss"${c1}"/-----"${c2}"+++++ooyyhhhhhdssssso      %s"
"${c2}  -s+++++syssssss"${c1}"/-----"${c2}"yyhhhhhhhhhhhddssssy.      %s"
"${c2}  sooooooyhyyyyyh"${c1}"/-----"${c2}"hhhhhhhhhhhddddyssy+       %s"
"${c2} :yooooooyhyyyhhhyyyyyyhhhhhhhhhhdddddyssy\`       %s"
"${c2} yoooooooyhyyhhhhhhhhhhhhhhhhhhhddddddysy/        %s"
"${c2}-ysooooooydhhhhhhhhhhhddddddddddddddddssy         %s"
"${c2} .-:/+osssyyyysyyyyyyyyyyyyyyyyyyyyyyssy:         %s"
"${c2}       \`\`.-/+oosysssssssssssssssssssssss          %s"
"${c2}               \`\`.:/+osyysssssssssssssh."
"${c2}                        \`-:/+osyyssssyo"
"${c2}                                .-:+++\`")
		;;


		"Peppermint")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;37m" # White
				c2="\e[1;31m" # Light Red
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="1"
			fulloutput=("${c2}             8ZZZZZZ"${c1}"MMMMM"
"${c2}          .ZZZZZZZZZ"${c1}"MMMMMMM.            %s"
"${c1}        MM"${c2}"ZZZZZZZZZ"${c1}"MMMMMMM"${c2}"ZZZZ         %s"
"${c1}      MMMMM"${c2}"ZZZZZZZZ"${c1}"MMMMM"${c2}"ZZZZZZZM       %s"
"${c1}     MMMMMMM"${c2}"ZZZZZZZ"${c1}"MMMM"${c2}"ZZZZZZZZZ.      %s"
"${c1}    MMMMMMMMM"${c2}"ZZZZZZ"${c1}"MMM"${c2}"ZZZZZZZZZZZI     %s"
"${c1}   MMMMMMMMMMM"${c2}"ZZZZZZ"${c1}"MM"${c2}"ZZZZZZZZZZ"${c1}"MMM    %s"
"${c2}   .ZZZ"${c1}"MMMMMMMMMM"${c2}"IZZ"${c1}"MM"${c2}"ZZZZZ"${c1}"MMMMMMMMM   %s"
"${c2}   ZZZZZZZ"${c1}"MMMMMMMM"${c2}"ZZ"${c1}"M"${c2}"ZZZZ"${c1}"MMMMMMMMMMM   %s"
"${c2}   ZZZZZZZZZZZZZZZZ"${c1}"M"${c2}"Z"${c1}"MMMMMMMMMMMMMMM   %s"
"${c2}   .ZZZZZZZZZZZZZ"${c1}"MMM"${c2}"Z"${c1}"M"${c2}"ZZZZZZZZZZ"${c1}"MMMM   %s"
"${c2}   .ZZZZZZZZZZZ"${c1}"MMM"${c2}"7ZZ"${c1}"MM"${c2}"ZZZZZZZZZZ7"${c1}"M    %s"
"${c2}    ZZZZZZZZZ"${c1}"MMMM"${c2}"ZZZZ"${c1}"MMMM"${c2}"ZZZZZZZ77     %s"
"${c1}     MMMMMMMMMMMM"${c2}"ZZZZZ"${c1}"MMMM"${c2}"ZZZZZ77      %s"
"${c1}      MMMMMMMMMM"${c2}"7ZZZZZZ"${c1}"MMMMM"${c2}"ZZ77       %s"
"${c1}       .MMMMMMM"${c2}"ZZZZZZZZ"${c1}"MMMMM"${c2}"Z7Z        %s"
"${c1}         MMMMM"${c2}"ZZZZZZZZZ"${c1}"MMMMMMM         %s"
"${c2}           NZZZZZZZZZZZ"${c1}"MMMMM"
"${c2}              ZZZZZZZZZ"${c1}"MM")
		;;

		"SolusOS")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;37m" # White
				c2="\e[1;30m" # Light Gray
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="1"
			fulloutput=("${c1}               e         e"
"${c1}             eee       ee       %s"
"${c1}            eeee     eee       %s"
"${c2}        wwwwwwwww"${c1}"eeeeee        %s"
"${c2}     wwwwwwwwwwwwwww"${c1}"eee        %s"
"${c2}   wwwwwwwwwwwwwwwwwww"${c1}"eeeeeeee %s"
"${c2}  wwwww     "${c1}"eeeee"${c2}"wwwwww"${c1}"eeee    %s"
"${c2} www          "${c1}"eeee"${c2}"wwwwww"${c1}"e      %s"
"${c2} ww             "${c1}"ee"${c2}"wwwwww       %s"
"${c2} w                 wwwww       %s"
"${c2}                   wwwww       %s"
"${c2}                  wwwww        %s"
"${c2}                 wwwww         %s"
"${c2}                wwww           %s"
"${c2}               wwww            %s"
"${c2}             wwww              %s"
"${c2}           www                 %s"
"${c2}         ww")
		;;

		"Mageia")
			if [[ "$no_color" != "1" ]]; then
			#	c1="\e[1;34m" # Light Blue
				c1="\e[1;37m" # White
			 	c2="\e[0;36m" # Light Cyan
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="1"
			fulloutput=("$c2               .°°."
"$c2                °°   .°°.         %s"
"$c2                .°°°. °°         %s"
"$c2                .   .            %s"
"$c2                 °°° .°°°.       %s"
"$c2             .°°°.   '___'       %s"
"$c1            .${c2}'___'     $c1   .      %s"
"$c1          :dkxc;'.  ..,cxkd;     %s"
"$c1        .dkk. kkkkkkkkkk .kkd.   %s"
"$c1       .dkk.  ';cloolc;.  .kkd   %s"
"$c1       ckk.                .kk;  %s"
"$c1       xO:                  cOd  %s"
"$c1       xO:                  lOd  %s"
"$c1       lOO.                .OO:  %s"
"$c1       .k00.              .00x   %s"
"$c1        .k00;            ;00O.   %s"
"$c1         .lO0Kc;,,,,,,;c0KOc.    %s"
"$c1            ;d00KKKKKK00d;         "
"$c1               .,KKKK,.            ")
		;;


		"ParabolaGNU/Linux-libre")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;35m" # Light Purple
				c2="\e[1;37m" # White
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			fulloutput=("${c1}              eeeeeeeee           %s"
"${c1}          eeeeeeeeeeeeeee        %s"
"${c1}       eeeeee"${c2}"//////////"${c1}"eeeee     %s"
"${c1}     eeeee"${c2}"///////////////"${c1}"eeeee   %s"
"${c1}   eeeee"${c2}"///           ////"${c1}"eeee   %s"
"${c1}  eeee"${c2}"//              ///"${c1}"eeeee   %s"
"${c1} eee                 "${c2}"///"${c1}"eeeee    %s"
"${c1}ee                  "${c2}"//"${c1}"eeeeee     %s"
"${c1}e                  "${c2}"/"${c1}"eeeeeee      %s"
"${c1}                  eeeeeee        %s"
"${c1}                 eeeeee          %s"
"${c1}                eeeeee           %s"
"${c1}               eeeee             %s"
"${c1}              eeee               %s"
"${c1}            eee                  %s"
"${c1}           ee                    %s"
"${c1}          e")
		;;


		"Viperr")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;37m" # White
				if [[ -n "$colors_light" ]]; then c2="\e[1;37m" # White
				else c2="\e[1;30m"; fi # Dark Gray
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="0"
			fulloutput=("${c1}    wwzapd         dlzazw       %s"
"${c1}   an"${c2}"#"${c1}"zncmqzepweeirzpas"${c2}"#"${c1}"xz     %s"
"${c1} apez"${c2}"##"${c1}"qzdkawweemvmzdm"${c2}"##"${c1}"dcmv   %s"
"${c1}zwepd"${c2}"####"${c1}"qzdweewksza"${c2}"####"${c1}"ezqpa  %s"
"${c1}ezqpdkapeifjeeazezqpdkazdkwqz  %s"
"${c1} ezqpdksz"${c2}"##"${c1}"wepuizp"${c2}"##"${c1}"wzeiapdk   %s"
"${c1}  zqpakdpa"${c2}"#"${c1}"azwewep"${c2}"#"${c1}"zqpdkqze    %s"
"${c1}    apqxalqpewenwazqmzazq      %s"
"${c1}     mn"${c2}"##"${c1}"=="${c2}"#######"${c1}"=="${c2}"##"${c1}"qp       %s"
"${c1}      qw"${c2}"##"${c1}"="${c2}"#######"${c1}"="${c2}"##"${c1}"zl        %s"
"${c1}      z0"${c2}"######"${c1}"="${c2}"######"${c1}"0a        %s"
"${c1}       qp"${c2}"#####"${c1}"="${c2}"#####"${c1}"mq         %s"
"${c1}       az"${c2}"####"${c1}"==="${c2}"####"${c1}"mn         %s"
"${c1}        ap"${c2}"#########"${c1}"qz          %s"
"${c1}         9qlzskwdewz           %s"
"${c1}          zqwpakaiw            %s"
"${c1}            qoqpe")
		;;


		"LinuxDeepin")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;32m" # Bold Green
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			fulloutput=("${c1}  eeeeeeeeeeeeeeeeeeeeeeeeeeee    %s"
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
"${c1}  eeeeeeeeeeeeeeeeeeeeeeeeeeee")
		;;


		"Chakra")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;34m" # Light Blue
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="1"
			fulloutput=("${c1}      _ _ _        \"kkkkkkkk."
"${c1}    ,kkkkkkkk.,    \'kkkkkkkkk,         %s"
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
"${c1}                   \"\'\'\"")
		;;


		"Fuduntu")
			if [[ "$no_color" != "1" ]]; then
				if [[ -n "$colors_light" ]]; then c1="\e[1;37m" # White
				else c1="\e[1;30m"; fi # Dark Gray
				c2="\033[1;33m" # Bold Yellow
				c3="\033[1;31m" # Light Red
				c4="\033[1;37m" # White
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="2"
			fulloutput=("${c1}       \`dwoapfjsod\`"${c2}"           \`dwoapfjsod\`"
"${c1}    \`xdwdsfasdfjaapz\`"${c2}"       \`dwdsfasdfjaapzx\`"
"${c1}  \`wadladfladlafsozmm\`"${c2}"     \`wadladfladlafsozmm\`   %s"
"${c1} \`aodowpwafjwodisosoaas\`"${c2}" \`odowpwafjwodisosoaaso\` %s"
"${c1} \`adowofaowiefawodpmmxs\`"${c2}" \`dowofaowiefawodpmmxso\` %s"
"${c1} \`asdjafoweiafdoafojffw\`"${c2}" \`sdjafoweiafdoafojffwq\` %s"
"${c1}  \`dasdfjalsdfjasdlfjdd\`"${c2}" \`asdfjalsdfjasdlfjdda\`  %s"
"${c1}   \`dddwdsfasdfjaapzxaw\`"${c2}" \`ddwdsfasdfjaapzxawo\`   %s"
"${c1}     \`dddwoapfjsowzocmw\`"${c2}" \`ddwoapfjsowzocmwp\`     %s"
"${c1}       \`ddasowjfowiejao\`"${c2}" \`dasowjfowiejaow\`       %s"
"                                                 %s"
"${c3}       \`ddasowjfowiejao\`"${c4}" \`dasowjfowiejaow\`       %s"
"${c3}     \`dddwoapfjsowzocmw\`"${c4}" \`ddwoapfjsowzocmwp\`     %s"
"${c3}   \`dddwdsfasdfjaapzxaw\`"${c4}" \`ddwdsfasdfjaapzxawo\`   %s"
"${c3}  \`dasdfjalsdfjasdlfjdd\`"${c4}" \`asdfjalsdfjasdlfjdda\`  %s"
"${c3} \`asdjafoweiafdoafojffw\`"${c4}" \`sdjafoweiafdoafojffwq\` %s"
"${c3} \`adowofaowiefawodpmmxs\`"${c4}" \`dowofaowiefawodpmmxso\` %s"
"${c3} \`aodowpwafjwodisosoaas\`"${c4}" \`odowpwafjwodisosoaaso\` %s"
"${c3}   \`wadladfladlafsozmm\`"${c4}"     \`wadladfladlafsozmm\`"
"${c3}     \`dwdsfasdfjaapzx\`"${c4}"       \`dwdsfasdfjaapzx\`"
"${c3}        \`woapfjsod\`"${c4}"             \`woapfjsod\`")
		;;

		"Mac OS X")
			if [[ "$no_color" != "1" ]]; then
				c1="\033[0;32m" # Green
				c2="\033[0;33m" # Yellow
				c3="\033[1;31m" # Orange
				c4="\033[0;31m" # Red
				c5="\033[0;35m" # Purple
				c6="\033[0;36m" # Blue
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; c3="${my_lcolor}"; c4="${my_lcolor}"; c5="${my_lcolor}"; c6="${my_lcolor}"; fi
			startline="0"
			fulloutput=("\n${c1}                 -/+:.          %s"
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
"${c6}      \`:+oo+/:-..-:/+o+/-      %s\n")
		;;

		"Windows"|"Cygwin")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;31m" # Red
				c2="\e[1;32m" # Green
				c3="\e[1;36m" # Blue
				c4="\e[1;33m" # Yellow
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; c3="${my_lcolor}"; c4="${my_lcolor}"; fi
			startline="0"
			fulloutput=("${c1}        ,.=:!!t3Z3z.,                 %s"
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

		"Trisquel")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;34m" # Light Blue
				c2="\e[1;36m" # Blue
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="1"
			fulloutput=(
"${c1}                          ▄▄▄▄▄▄     "
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
"${c2}                      ▀▀█████▀▀      ")
		;;

		"Manjaro")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;32m" # Green
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="0"
			fulloutput=(
"${c1} ██████████████████  ████████     %s"
"${c1} ██████████████████  ████████    %s"
"${c1} ██████████████████  ████████    %s"
"${c1} ██████████████████  ████████    %s"
"${c1} ████████            ████████    %s"
"${c1} ████████  ████████  ████████    %s"
"${c1} ████████  ████████  ████████    %s"
"${c1}           ████████  ████████    %s"
"${c1} ████████  ████████  ████████    %s"
"${c1} ████████  ████████  ████████    %s"
"${c1} ████████  ████████  ████████    %s"
"${c1} ████████  ████████  ████████    %s"
"${c1} ████████  ████████  ████████    %s"
"${c1} ████████  ████████  ████████    %s"
"${c1} ████████  ████████  ████████    %s"
"${c1} ████████  ████████  ████████    %s"
"${c1} ████████  ████████  ████████")
		;;




		"Elementary OS")
			if [[ "$no_color" != "1" ]]; then
				c1="\033[1;37m" # White
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="1"
			fulloutput=(
""
"${c1}           \$?77777\$\$\$IO           %s"
"${c1}        \$III777ZZZZ\$\$\$ZZ\$8       %s"
"${c1}      ZI777           OZZZ\$      %s"
"${c1}     Z777             O7ZZO8     %s"
"${c1}    Z777            O\$ZZZ8       %s"
"${c1}    I\$\$           O\$ZZZD         %s"
"${c1}   0\$\$O         O\$\$ZZ            %s"
"${c1}   0\$\$O       8\$\$\$\$              %s"
"${c1}   0\$\$O     8\$\$\$\$                %s"
"${c1}    \$ZZ   O\$\$ZZ           D      %s"
"${c1}     ZZZ8ZZZZ             O88    %s"
"${c1}     DZZZZ8             D888     %s"
"${c1}       ZZZZDMMMMMMMMMMDO888      %s"
"${c1}         ZOOOOOOOOOOOO888        %s"
"${c1}           N8OOOOOOO8D           %s"
"                                 %s"
"")
		;;


		"Android")
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;37m" # White
				c2="\e[1;32m" # Bold Green
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
			startline="2"
	                fulloutput=(
"${c2}       ╲ ▁▂▂▂▁ ╱"
"${c2}       ▄███████▄ "
"${c2}      ▄██${c1} ${c2}███${c1} ${c2}██▄        %s"
"${c2}     ▄███████████▄      %s"
"${c2}  ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄ █▄   %s"
"${c2}  ██ █████████████ ██   %s"
"${c2}  ██ █████████████ ██   %s"
"${c2}  ██ █████████████ ██   %s"
"${c2}  ██ █████████████ ██   %s"
"${c2}     █████████████      %s"
"${c2}      ███████████       %s"
"${c2}       ██     ██"
"${c2}       ██     ██")
		;;

		"Scientific Linux")
			if [[ "$no_color" != "1" ]]; then
				c1="\033[1;34m" 
				c2="\033[1;31m" 
				c3="\033[1;37m" 
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="2"
			fulloutput=("${c1}                  =/;;/-"
"${c1}                 +:    //"
"${c1}                /;      /;                   %s"
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
"${c1}                 //    +;"
"${c1}                  '////'")
		;;

		"BackTrack Linux")
			if [[ "$no_color" != "1" ]]; then
				c1="\033[1;37m" # White
				c2="\033[1;31m" # Light Red
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; fi
			startline="2"
			fulloutput=("${c1}................."
"${c1}               ..,;:ccc,."
"${c1}             ......''';lxO."
"${c1}........''''..........,:ld;"
"${c1}              .';;;:::;,,.x,"
"${c1}         ..'''.            0Xxoc:,.  ..."
"${c1}     ....                ,ONkc;,;cokOdc',."
"${c1}    .                   OMo           ':"${c2}"dd"${c1}"o."
"${c1}                       dMc               :OO;"
"${c1}                       0M.                 .:o."
"${c1}                       ;Wd"
"${c1}                        ;XO,"
"${c1}                          ,d0Odlc;,.."
"${c1}                              ..',;:cdOOd::,."
"${c1}                                       .:d;.':;."
"${c1}                                          'd,  .'"
"${c1}                                            ;l   .."
"${c1}                                             .o"
"${c1}                                               c"
"${c1}                                               .'"
"${c1}                                                .")
		;;

                "Sabayon")
                        if [[ "$no_color" != "1" ]]; then
                                c1="\033[1;37m" # White
				c2="\033[1;34m" # Blue
                        fi
                        if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; fi
                        startline="1"
                        fulloutput=("${c2}            ..........."
"${c2}         ..             ..             %s"
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
"${c2}          ...............")
                ;;

		*)
			if [[ "$no_color" != "1" ]]; then
				c1="\e[1;37m" # White
				c2="\e[1;30m" # Light Gray
				c3="\e[1;33m" # Light Yellow
			fi
			if [ -n "${my_lcolor}" ]; then c1="${my_lcolor}"; c2="${my_lcolor}"; c3="${my_lcolor}"; fi
			startline="0"
			fulloutput=("                             %s"
"                            %s"
"$c2         #####$c0              %s"
"$c2        #######             %s"
"$c2        ##"$c1"O$c2#"$c1"O$c2##             %s"
"$c2        #$c3#####$c2#             %s"
"$c2      ##$c1##$c3###$c1##$c2##           %s"
"$c2     #$c1##########$c2##          %s"
"$c2    #$c1############$c2##         %s"
"$c2    #$c1############$c2###        %s"
"$c3   ##$c2#$c1###########$c2##$c3#        %s"
"$c3 ######$c2#$c1#######$c2#$c3######      %s"
"$c3 #######$c2#$c1#####$c2#$c3#######      %s"
"$c3   #####$c2#######$c3#####        %s"
"                            %s"
"                            %s")
  		;;
	esac


	# Truncate lines based on terminal width.
	if [ "$truncateSet" == "Yes" ]; then
		for ((i=0; i<${#fulloutput[@]}; i++)); do
			my_out=$(printf "${fulloutput[i]}$c0\n" "${out_array}")
			my_out_full=$(echo "$my_out" | cat -v)
			termWidth=$(tput cols)
			SHOPT_EXTGLOB_STATE=$(shopt -p extglob)
			read SHOPT_CMD SHOPT_STATE SHOPT_OPT <<< ${SHOPT_EXTGLOB_STATE}
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
								j=$((${j} + 5))
							else
								j=$((${j} + 4))
							fi
						elif [[ "${my_out_full:${j}:8}" =~ ^\^\[\[[[:digit:]]\;[[:digit:]][[:digit:]]m ]]; then
							if [[ ${j} -eq 0 ]]; then
								j=$((${j} + 8))
							else
								j=$((${j} + 7))
							fi
						fi
					else
						((NORMAL_CHAR_COUNT++))
						if [[ ${NORMAL_CHAR_COUNT} -ge ${termWidth} ]]; then
							echo -e "${my_out:0:$((${j} - 5))}"$c0
							break 1
						fi
					fi
				done
			fi

			if [[ "$i" -ge "$startline" ]]; then
				unset out_array[0]
				out_array=( "${out_array[@]}" )
			fi
		done
	else
		#n=${#fulloutput[*]}
		for ((i=0; i<${#fulloutput[*]}; i++)); do
			# echo "${out_array[@]}"
			printf "${fulloutput[i]}$c0\n" "${out_array}"
			if [[ "$i" -ge "$startline" ]]; then
				unset out_array[0]
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
		"Arch Linux - Old"|"Fedora"|"Mandriva"|"Mandrake"|"Chakra"|"Sabayon") labelcolor="\e[1;34m";;
		"Arch Linux"|"Frugalware"|"Mageia") labelcolor="\e[1;36m";;
		"Mint"|"LMDE"|"openSUSE"|"LinuxDeepin"|"DragonflyBSD"|"Manjaro"|"Android") labelcolor="\e[1;32m";;
		"Ubuntu"|"FreeBSD"|"Debian"|"BSD"|"Red Hat Linux"|"Peppermint"|"Cygwin"|"Fuduntu"|"NetBSD"|"Scientific Linux") labelcolor="\e[1;31m";;
		"CrunchBang"|"SolusOS"|"Viperr"|"Elementary OS")
			if [[ -n "$colors_light" ]]; then labelcolor="\e[1;37m"
			else labelcolor="\e[1;30m"; fi
		;;
		"Gentoo"|"ParabolaGNU/Linux-libre") labelcolor="\e[1;35m";;
		"Slackware") labelcolor="\e[1;34m";;
		"Mac OS X"|"Trisquel") labelcolor="\033[1;34m";;
		*) labelcolor="\e[1;33m";;
	esac
	[[ "$my_lcolor" ]] && labelcolor="${my_lcolor}"
	if [[ "$no_color" == "1" ]]; then labelcolor=""; bold=""; c0=""; textcolor=""; fi
	# Some verbosity stuff
	[[ "$verbosity" == "1" ]] && [[ "$screenshot" == "1" ]] && verboseOut "Screenshot will be taken after info is displayed."
	[[ "$verbosity" == "1" ]] && [[ "$hostshot" == "1" ]] && verboseOut "Screenshot will be transferred/uploaded to specified location."
	#########################
	# Info Variable Setting #
	#########################
	if [[ "${distro}" == "Android" ]]; then
		myhostname=$(echo -e "${labelcolor}${hostname}"); out_array=( "${out_array[@]}" "$myhostname" )
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
		if [[ "${display[@]}" =~ "host" ]]; then myinfo=$(echo -e "${labelcolor}${myUser}$textcolor${bold}@${c0}${labelcolor}${myHost}"); out_array=( "${out_array[@]}" "$myinfo" ); ((display_index++)); fi
		if [[ "${display[@]}" =~ "distro" ]]; then
			if [ "$distro" == "Mac OS X" ]; then
				sysArch=`str1=$(ioreg -l -p IODeviceTree | grep firmware-abi);echo ${str1: -4: 2}bit`
				prodVers=`prodVers=$(sw_vers|grep ProductVersion);echo ${prodVers:15}`
				buildVers=`buildVers=$(sw_vers|grep BuildVersion);echo ${buildVers:14}`
				if [ -n "$distro_more" ]; then mydistro=$(echo -e "$labelcolor OS:$textcolor $distro_more $sysArch")
				else mydistro=$(echo -e "$labelcolor OS:$textcolor $sysArch $distro $prodVers $buildVers"); fi
			elif [[ "$distro" == "Cygwin" ]]; then
				distro=$(wmic os get name | head -2 | tail -1)
				distro=$(expr match "$distro" '\(Microsoft Windows [A-Za-z0-9]\+\)')
				sysArch=$(wmic os get OSArchitecture | head -2 | tail -1 | tr -d '\r ')
				mydistro=$(echo -e "$labelcolor OS:$textcolor $distro $sysArch")
			else
				if [ -n "$distro_more" ]; then mydistro=$(echo -e "$labelcolor OS:$textcolor $distro_more")
				else mydistro=$(echo -e "$labelcolor OS:$textcolor $distro $sysArch"); fi
			fi
			out_array=( "${out_array[@]}" "$mydistro" )
			((display_index++))
		fi
		if [[ "${display[@]}" =~ "kernel" ]]; then mykernel=$(echo -e "$labelcolor Kernel:$textcolor $kernel"); out_array=( "${out_array[@]}" "$mykernel" ); ((display_index++)); fi
		if [[ "${display[@]}" =~ "uptime" ]]; then myuptime=$(echo -e "$labelcolor Uptime:$textcolor $uptime"); out_array=( "${out_array[@]}" "$myuptime" ); ((display_index++)); fi
		if [[ "${display[@]}" =~ "pkgs" ]]; then mypkgs=$(echo -e "$labelcolor Packages:$textcolor $pkgs"); out_array=( "${out_array[@]}" "$mypkgs" ); ((display_index++)); fi
		if [[ "${display[@]}" =~ "shell" ]]; then myshell=$(echo -e "$labelcolor Shell:$textcolor $myShell"); out_array=( "${out_array[@]}" "$myshell" ); ((display_index++)); fi
		if [[ -n "$DISPLAY" ]]; then
			if [[ "${display[@]}" =~ "res" ]]; then myres=$(echo -e "$labelcolor Resolution:${textcolor} $xResolution"); out_array=( "${out_array[@]}" "$myres" ); ((display_index++)); fi
			if [[ "${display[@]}" =~ "de" ]]; then
				if [[ "${DE}" != "Not Present" ]]; then
					myde=$(echo -e "$labelcolor DE:$textcolor $DE"); out_array=( "${out_array[@]}" "$myde" ); ((display_index++))
				fi
			fi
			if [[ "${display[@]}" =~ "wm" ]]; then mywm=$(echo -e "$labelcolor WM:$textcolor $WM"); out_array=( "${out_array[@]}" "$mywm" ); ((display_index++)); fi
			if [[ "${display[@]}" =~ "wmtheme" ]]; then
					if [[ "${Win_theme}" == "Not Present" ]]; then
						:
					else
						mywmtheme=$(echo -e "$labelcolor WM Theme:$textcolor $Win_theme"); out_array=( "${out_array[@]}" "$mywmtheme" ); ((display_index++)); fi
					fi
			if [[ "${display[@]}" =~ "gtk" ]]; then
				if [ "$distro" == "Mac OS X" ]; then
					if [ "$gtkIcons" != "Not Found" ]; then
						if [ -n "$gtkIcons" ]; then 
							myicons=$(echo -e "$labelcolor Icon Theme:$textcolor $gtkIcons"); out_array=( "${out_array[@]}" "$myicons" ); ((display_index++))
						fi
					fi
					if [ "$gtkFont" != "Not Found" ]; then
						if [ -n "$gtkFont" ]; then 
							myfont=$(echo -e "$labelcolor Font:$textcolor $gtkFont"); out_array=( "${out_array[@]}" "$myfont" ); ((display_index++))
						fi
					fi
				else
					if [ "$gtk2Theme" != "Not Found" ]; then
						if [ -n "$gtk2Theme" ]; then 
							mygtk2=$(echo -e "$labelcolor GTK2 Theme:$textcolor $gtk2Theme"); out_array=( "${out_array[@]}" "$mygtk2" ); ((display_index++))
						fi
					fi
					if [ "$gtk3Theme" != "Not Found" ]; then
						if [ -n "$gtk3Theme" ]; then 
							mygtk3=$(echo -e "$labelcolor GTK3 Theme:$textcolor $gtk3Theme"); out_array=( "${out_array[@]}" "$mygtk3" ); ((display_index++))
						fi
					fi
					if [ "$gtkIcons" != "Not Found" ]; then
						if [ -n "$gtkIcons" ]; then 
							myicons=$(echo -e "$labelcolor Icon Theme:$textcolor $gtkIcons"); out_array=( "${out_array[@]}" "$myicons" ); ((display_index++))
						fi
					fi
					if [ "$gtkFont" != "Not Found" ]; then
						if [ -n "$gtkFont" ]; then 
							myfont=$(echo -e "$labelcolor Font:$textcolor $gtkFont"); out_array=( "${out_array[@]}" "$myfont" ); ((display_index++))
						fi
					fi
					# [ "$gtkBackground" ] && mybg=$(echo -e "$labelcolor BG:$textcolor $gtkBackground"); out_array=( "${out_array[@]}" "$mybg" ); ((display_index++))
				fi
			fi
		elif [[ "$fake_distro" == "Cygwin" ]]; then
			if [[ "${display[@]}" =~ "res" ]]; then myres=$(echo -e "$labelcolor Resolution:${textcolor} $xResolution"); out_array=( "${out_array[@]}" "$myres" ); ((display_index++)); fi
			if [[ "${display[@]}" =~ "de" ]]; then
				if [[ "${DE}" != "Not Present" ]]; then
					myde=$(echo -e "$labelcolor DE:$textcolor $DE"); out_array=( "${out_array[@]}" "$myde" ); ((display_index++))
				fi
			fi
			if [[ "${display[@]}" =~ "wm" ]]; then mywm=$(echo -e "$labelcolor WM:$textcolor $WM"); out_array=( "${out_array[@]}" "$mywm" ); ((display_index++)); fi
			if [[ "${display[@]}" =~ "wmtheme" ]]; then
				if [[ "${Win_theme}" == "Not Present" ]]; then
					:
				else
					mywmtheme=$(echo -e "$labelcolor WM Theme:$textcolor $Win_theme"); out_array=( "${out_array[@]}" "$mywmtheme" ); ((display_index++))
				fi
			fi
		fi
		if [[ "${display[@]}" =~ "cpu" ]]; then mycpu=$(echo -e "$labelcolor CPU:$textcolor $cpu"); out_array=( "${out_array[@]}" "$mycpu" ); ((display_index++)); fi
		if [[ "${display[@]}" =~ "gpu" ]]; then mygpu=$(echo -e "$labelcolor GPU:$textcolor $gpu"); out_array=( "${out_array[@]}" "$mygpu" ); ((display_index++)); fi
		if [[ "${display[@]}" =~ "mem" ]]; then mymem=$(echo -e "$labelcolor RAM:$textcolor $mem"); out_array=( "${out_array[@]}" "$mymem" ); ((display_index++)); fi
	fi
	if [[ "$display_type" == "ASCII" ]]; then
		asciiText
	else
		if [[ "${display[@]}" =~ "host" ]]; then echo -e " $myinfo"; fi
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
			if [[ "${display[@]}" =~ "pkgs" ]]; then echo -e "$myuptime"; fi
			if [[ "${display[@]}" =~ "shell" ]]; then echo -e "$myshell"; fi
			if [[ "${display[@]}" =~ "res" ]]; then echo -e "$myres"; fi
			if [[ "${display[@]}" =~ "de" ]]; then
				if [[ "${DE}" != "Not Present" ]]; then echo -e "$myde"; fi
			fi
			if [[ "${display[@]}" =~ "wm" ]]; then
				echo -e "$mywm"
				if [[ "${Win_theme}" != "Not Present" ]]; then
					echo -e "$mywmtheme"
				fi
			fi
			if [[ "${display[@]}" =~ "gtk" ]]; then
				echo -e "$mygtk2"
				echo -e "$mygtk3"
				echo -e "$myicons"
				echo -e "$myfont"
			fi
			if [[ "${display[@]}" =~ "cpu" ]]; then echo -e "$mycpu"; fi
			if [[ "${display[@]}" =~ "gpu" ]]; then echo -e "$mygpu"; fi
			if [[ "${display[@]}" =~ "mem" ]]; then echo -e "$mymem"; fi
		fi
	fi
}

########
# Theme Exporting (Experimental!)
########
themeExport () {
	WM=$(echo "$mywm" | awk '{print $NF}')
	if [[ ! -d /tmp/screenfetch-export ]]; then mkdir -p "/tmp/screenfetch-export/Icons" & mkdir -p "/tmp/screenfetch-export/GTK-Theme" & mkdir -p "/tmp/screenfetch-export/WM-${WM}" ; fi
	if [[ "$WM" ]]; then
		if [[ "$WM" =~ "Openbox" ]]; then
			if [[ "$Win_theme" != "Not Found" ]]; then
				if [[ -d "$HOME/.themes/$Win_theme" ]]; then
					cp -r "$HOME/.themes/$Win_theme" "/tmp/screenfetch-export/WM-${WM}/$Win_theme" &>/dev/null
					[[ "$verbosity" -eq "1" ]] && verboseOut "Found WM theme folder. Transferring to /tmp/screenfetch-export/..."
				fi
			fi
		elif [[ "$WM" =~ "Fluxbox" ]]; then
			if [[ "$Win_theme" != "Not Found" ]]; then
				if [[ -d "$HOME/.fluxbox/styles/$Win_theme" ]]; then
					cp -r "$HOME/.fluxbox/styles/$Win_theme" "/tmp/screenfetch-export/WM-${WM}/$Win_theme" &>/dev/null
					[[ "$verbosity" -eq "1" ]] && verboseOut "Found WM theme folder. Transferring to /tmp/screenfetch-export/..."
				fi
			fi
		elif [[ "$WM" =~ "Blackbox" ]]; then
			if [[ "$Win_theme" != "Not Found" ]]; then
				if [[ -d "$HOME/.blackbox/styles/$Win_theme" ]]; then
					cp -r "$HOME/.blackbox/styles/$Win_theme" "/tmp/screenfetch-export/WM-${WM}/$Win_theme" &>/dev/null
					[[ "$verbosity" -eq "1" ]] && verboseOut "Found WM theme folder. Transferring to /tmp/screenfetch-export/..."
				elif [[ -d "/usr/share/blackbox/styles/$Win_theme" ]]; then
					cp -r "/usr/share/blackbox/styles/$Win_theme" "/tmp/screenfetch-export/WM-${WM}/$Win_theme" &>/dev/null
					[[ "$verbosity" -eq "1" ]] && verboseOut "Found WM theme folder. Transferring to /tmp/screenfetch-export/..."
				fi
			fi
		elif [[ "$WM" =~ "PekWM" ]]; then
			if [[ "$Win_theme" != "Not Found" ]]; then
				if [[ -d "$HOME/.pekwm/themes/$Win_theme" ]]; then
					cp -r "$HOME/.pekwm/themes/$Win_theme" "/tmp/screenfetch-export/WM-${WM}/$Win_theme" &>/dev/null
					[[ "$verbosity" -eq "1" ]] && verboseOut "Found WM theme folder. Transferring to /tmp/screenfetch-export/..."
				fi
			fi
		elif [[ "$WM" =~ "Metacity" ]]; then
			if [[ "$Win_theme" != "Not Found" ]]; then
				if [[ -d "$HOME/.themes/$Win_theme" ]]; then
					cp -r "$HOME/.themes/$Win_theme" "/tmp/screenfetch-export/WM-${WM}/$Win_theme" &>/dev/null
					[[ "$verbosity" -eq "1" ]] && verboseOut "Found WM theme folder. Transferring to /tmp/screenfetch-export/..."
				elif [[ -d "/usr/share/themes/$Win_theme" ]]; then
					cp -r "/usr/share/themes/$Win_theme" "/tmp/screenfetch-export/WM-${WM}/$Win_theme" &>/dev/null
					[[ "$verbosity" -eq "1" ]] && verboseOut "Found WM theme folder. Transferring to /tmp/screenfetch-export/..."
				fi
			fi
		elif [[ "$WM" =~ "Xfwm4" ]]; then
			if [[ "$Win_theme" != "Not Found" ]]; then
				WM_theme=$(echo "$Win_theme" | awk '{print $NF}')
				if [[ -d "$HOME/.themes/$Win_theme" ]]; then
					cp -r "$HOME/.themes/$Win_theme" "/tmp/screenfetch-export/WM-${WM}/$Win_theme" &>/dev/null
					[[ "$verbosity" -eq "1" ]] && verboseOut "Found WM theme folder. Transferring to /tmp/screenfetch-export/..."
				elif [[ -d "/usr/share/themes/$Win_theme" ]]; then
					cp -r "/usr/share/themes/$Win_theme" "/tmp/screenfetch-export/WM-${WM}/$Win_theme" &>/dev/null
					[[ "$verbosity" -eq "1" ]] && verboseOut "Found WM theme folder. Transferring to /tmp/screenfetch-export/..."
				fi
			fi
		fi
	fi
	if [[ "$gtkBackgroundFull" ]]; then
		cp "$gtkBackgroundFull" /tmp/screenfetch-export/
		[[ "$verbosity" -eq "1" ]] && verboseOut "Found BG file. Transferring to /tmp/screenfetch-export/..."
	fi
	if [[ "$mygtk" ]]; then
		GTK_theme=$(echo "$mygtk" | awk '{print $NF}')
		if [ -d "/usr/share/themes/$GTK_theme" ]; then
			cp -r "/usr/share/themes/$GTK_theme" "/tmp/screenfetch-export/GTK/Theme/$GTK_theme" &>/dev/null
			[[ "$verbosity" -eq "1" ]] && verboseOut "Found GTK theme folder. Transferring to /tmp/screenfetch-export/..."
		fi
	fi
	if [[ "$myicons" ]]; then
		GTK_icons=$(echo "$myicons" | awk '{print $NF}')
		if [ -d "/usr/share/icons/$GTK_icons" ]; then
			cp -r "/usr/share/icons/$GTK_icons" "/tmp/screenfetch-export/GTK/Icons/$GTK_icons" &>/dev/null
			[[ "$verbosity" -eq "1" ]] && verboseOut "Found GTK icons theme folder. Transferring to /tmp/screenfetch-export/..."
		fi
		if [ -d "$HOME/.icons/$GTK_icons" ]; then
			cp -r "$HOME/.icons/$GTK_icons" "/tmp/screenfetch-export/GTK/Icons/$GTK_icons" &>/dev/null
			[[ "$verbosity" -eq "1" ]] && verboseOut "Found GTK icons theme folder. Transferring to /tmp/screenfetch-export/..."
		fi
	fi
	if [[ "$myfont" ]]; then
		GTK_font=$(echo "$myfont" | awk '{print $NF}')
		if [ -d "/usr/share/fonts/$GTK_font" ]; then
			cp -r "/usr/share/fonts/$GTK_font" "/tmp/screenfetch-export/GTK/$GTK_font" &>/dev/null
			[[ "$verbosity" -eq "1" ]] && verboseOut "Found GTK font. Transferring to /tmp/screenfetch-export/..."
		elif [ -d "$HOME/.fonts/$GTK_font" ]; then
			cp -r "$HOME/.fonts/$GTK_font" "/tmp/screenfetch-export/GTK/$GTK_font" &>/dev/null
			[[ "$verbosity" -eq "1" ]] && verboseOut "Found GTK font. Transferring to /tmp/screenfetch-export/..."
		fi
	fi
	if [ "$screenshot" == "1" ]; then
		if [ -f "${shotfile}" ]; then
			cp "${shotfile}" "/tmp/screenfetch-export/"
			[[ "$verbosity" -eq "1" ]] && verboseOut "Found screenshot. Transferring to /tmp/screenfetch-export/..."
		fi
	fi
	cd /tmp/screenfetch-export/
	[[ "$verbosity" -eq "1" ]] && verboseOut "Creating screenfetch-export.tar.gz archive in /tmp/screenfetch-export/...."
	tar -czf screenfetch-export.tar.gz ../screenfetch-export &>/dev/null
	mv /tmp/screenfetch-export/screenfetch-export.tar.gz $HOME/
	echo -e "${bold}==>${c0} Archive created in /tmp/ and moved to $HOME. Removing /tmp/screenfetch-export/..."
	rm -rf /tmp/screenfetch-export/
}


##################
# Let's Do This!
##################

# Check for android
if type -p getprop >/dev/null 2>&1; then
	distro="Android"
	detectmem
	detectuptime
	detectkernel
	detectdroid
	infoDisplay
	exit 0
fi

for i in "${display[@]}"; do

	if [[ $i =~ wm ]]; then
		 ! [[ $WM  ]] && detectwm;
		 ! [[ $Win_theme ]] && detectwmtheme;
	else
		if [[ "${display[*]}" =~ "$i" ]]; then 
			if [[ "$errorSuppress" == "1" ]]; then detect${i} >/dev/null 2>&1
			else detect${i}; fi
		fi
	fi
done

if [[ -f "$HOME/.screenfetchOR" ]]; then
    vars=("$(cat $HOME/.screenfetchOR | grep '^.*=.*$')")
    for v in "${vars[@]}"; do #=$(echo $v | sed -e 's/^.*=//')"
        varname="$(echo $v | sed -e 's/=.*$//')"
        eval $varname="\"$(echo $v | sed -e 's/^.*=//')\""
    done
fi

infoDisplay
[ "$screenshot" == "1" ] && takeShot
[ "$exportTheme" == "1" ] && themeExport

exit 0
