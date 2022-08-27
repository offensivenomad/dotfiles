#!/bin/bash
#
# Dotfiles installer script

#
# Offensive Nomad

# Must not prefix with sudo when calling script
if [[ $(id -u) == 0 ]]; then
	clr_red echo "You cannot call this script using sudo. Aborting."
	exit 99
fi

H="$HOME"
D="$HOME/.dotfiles"
R="$D/rootrc"
W="/mnt/c/Users/offend"

# shellcheck source=/dev/null
source "${D}/bash_colors.sh"

BREAK=$(echo " " | sed 's/ \+/\n/g')
LINE="#-#-##--#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#--##-#-#"
BARS="-----------------------------------"
COMPLETE=$(clr_green "...COMPLETE")

echo "${BREAK}"
clr_green "${LINE}"
clr_green "#-#-##-- " -n
clr_escape "${BARS}" 1 33
clr_green " --##-#-#"
clr_green "#-#-##-- " -n
clr_escape "${BARS}" 1 33
clr_green " --##-#-#"
clr_green "#-#-##-- " -n
clr_escape "OFFENSIVE NOMAD'S DOTFILE INSTALLER" 1 33
clr_green " --##-#-#"
clr_green "#-#-##-- " -n
clr_escape "${BARS}" 1 33
clr_green " --##-#-#"
clr_green "#-#-##-- " -n
clr_escape "${BARS}" 1 33
clr_green " --##-#-#"
clr_green "${LINE}"
echo "${BREAK}"
echo "${BREAK}"
echo "${BREAK}"

## Link BASHRC customizations
clr_brown echo 'LINKING Local bash customisations'
echo "source $HOME/.dotfiles/bashrc.local" | tee -a "$H"/.bashrc
echo "source $HOME/.bashrc" | tee
echo "${COMPLETE}"
echo "${BREAK}"
echo "${BREAK}"
echo "${BREAK}"

## UPDATE SYSTEM
clr_whiteb clr_red echo 'Install dependencies? (y/n) '
clr_escape
read -res depInstall
if [[ "${depInstall}" == "y" ]]; then
	clr_brown echo "...UPDATING SYSTEM"
	sudo apt-get update
	sudo apt-get full-upgrade -y
	echo "${COMPLETE}"
	clr_escape
	clr_brown echo "...INSTALLING DEPENDENCIES"
	sudo apt install -y build-essential neofetch openssh-client openssh-server git wget curl python3 python3-pip icdiff youtube-dl
	echo "${COMPLETE}"
else
	clr_blueb clr_brown echo "Skipping package dependency install"
fi
echo "${BREAK}"
echo "${BREAK}"
echo "${BREAK}"

## LINK DOTFILES
clr_whiteb clr_red echo "Link User Dotfiles? (y/n)"
clr_escape
read -res dotLink
if [[ "${dotLink}" == "y" ]]; then
	clr_reverse clr_brown echo "...LINKING DOTFILES"

	if [ ! -d "$H"/.bash.d ]; then
		ln -snf "$D"/bash.d "$H"/.bash.d
	else
		clr_red echo "...BASH.D LINK ALREADY EXISTS"
	fi

	if [ ! -d "$H"/.config ]; then
		mv "$H"/.config "$H"/.config.bak
		clr_brown echo "...CONFIG FILES BACKUP CREATED"
		ln -snf "$D"/config "$H"/.config
	else
		clr_red echo "...CONFIG ALREADY LINKED"
	fi

	if [ ! -d "$H"/MEGAsync ] && [ -d "$W"/MEGAsync ]; then
		ln -snf "$W"/MEGAsync "$H"
	fi

	if [ ! -L "$H"/.bashrc ]; then
		mv "$H"/.bashrc "$H"/.bashrc.bak
		clr_brown echo "...BASHRC BACKUP CREATED"
		ln -snf "$D"/bashrc "$H"/.bashrc
		clr_brown echo "...BASHRC LINKED!"
	else
		clr_red echo "...BASHRC ALREADY LINKED!"
	fi

	if [ ! -L "$H"/.profile ]; then
		mv "$H"/.profile "$H"/.profile.bak
		clr_brown echo "...PROFILE CONFIG BACKUP CREATED"
		ln -snf "$D"/profile "$H"/.profile
		clr_brown echo "...PROFILE LINKED!"
	else
		clr_red echo "...PROFILE ALREADY LINKED!"
	fi

	if [ ! -L "$H"/.backup-exclusions ]; then
		ln -snf "$D"/backup-exclusions "$H"/.backup-exclusions
		clr_brown echo "...BACKUP EXCLUSIONS LINKED!"
	else
		clr_red echo "...BACKUP EXCLUSIONS ALREADY LINKED!"
	fi

	if [ ! -L "$H"/.backup-inclusions ]; then
		ln -snf "$D"/backup-inclusions "$H"/.backup-inclusions
		clr_brown echo "...BACKUP INCLUSIONS LINKED"
	else
		clr_red echo "...BACKUP INCLUSIONS ALREADY LINKED!"
	fi

	if [ ! -L "$H"/.gitconfig ]; then
		ln -snf "$D"/gitconfig "$H"/.gitconfig
		clr_brown echo "...GIT CONFIG LINKED"
	else
		clr_red echo "...GIT CONFIG ALREADY LINKED!"
	fi

	if [ ! -L "$H"/.gitignore ]; then
		ln -snf "$D"/gitignore "$H"/.gitignore
		clr_brown echo "...GIT IGNORE LINKED"
	else
		clr_red echo "...GIT IGNORE ALREADY LINKED!"
	fi

	if [ ! -L "$H"/.mytheme.omp.json ]; then
		ln -snf "$D"/mytheme.omp.json "$H"/.mytheme.omp.json
		clr_brown echo "...POSH THEME CONFIG LINKED!"
	else
		clr_red echo "...POSH THEME CONFIG ALREADY LINKED!"
	fi

	if [ ! -L "$H"/.nanorc ]; then
		ln -snf "$D"/nanorc "$H"/.nanorc
		clr_brown echo "...NONORC LINKED!"
	else
		clr_red "...NANORC ALREADY LINKED!"
	fi

	echo "${COMPLETE}"
fi
echo "${BREAK}"

## LINKING ROOT DOTS
${BREAK}
clr_reverse clr_brown echo "...LINKING ROOT DOTS"

if [ -d "/root" ]; then
	sudo cp "${ROOT}"/.bashrc "${ROOT}"/.bashrc.bak
	clr_brown echo "...ROOT BASHRC BACKUP CREATED"
	sudo ln -snf "${R}"/bashrc "${ROOT}"/.bashrc
	echo "${COMPLETE}"
else
	clr_red echo "...ROOTRC LINKS SKIPPED"
fi
echo "${BREAK}"
echo "${BREAK}"
echo "${BREAK}"

## INSTALL NVM
clr_whiteb clr_red echo "Install NVM? (y/n)"
clr_escape
read -res installNvm
if [[ ${installNvm} == "y" ]]; then
	clr_brown echo "...INSTALLING NVM & NODEJS"
	clr_escape
	# shellcheck source=/dev/null
	source "$H"/.bash.d/nvm.sh
	installNVM
fi
echo "${COMPLETE}"
echo "${BREAK}"
echo "${BREAK}"
echo "${BREAK}"

## INSTALL Homebrew
clr_whiteb clr_red echo "Install Homebrew? (y/n)"
clr_escape
read -res installHomebrew
if [[ ${installHomebrew} == "y" ]]; then
	if [[ ! -d "$H"/.linuxbrew ]]; then
		clr_brown echo "...INSTALLING HOMEBREW"
		clr_escape
		# shellcheck source=/dev/null
		source "$H/.bash.d/brew"
		installBrew
		echo "${COMPLETE}"
	fi
else
	clr_red echo "...HOMEBREW ALREADY EXISTS"
fi
echo "${BREAK}"
echo "${BREAK}"
echo "${BREAK}"

## INSTALL Oh-My-Posh
clr_whiteb clr_red echo "Install Oh-My-Posh? (y/n)"
clr_escape
read -res installMyPosh
if [[ ${installMyPosh} == "y" ]]; then
	clr_brown echo "...INSTALLING OH-MY-POSH"
	clr_escape
	# shellcheck source=/dev/null
	source "$H"/.bash.d/posh-install
	installOhMyPosh
fi
echo "${COMPLETE}"
echo "${BREAK}"
echo "${BREAK}"
echo "${BREAK}"

clr_blueb clr_white clr_bold echo "#-#-##-- Offensive Nomad's dotfile installation complete"

# shellcheck source=/dev/null
source "${HOME}/.bashrc"

exit 0
