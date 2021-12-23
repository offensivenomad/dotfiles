#!/bin/bash
#
# Dotfiles installer script

#
# Offensive Nomad

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

${BREAK}
clr_green "${LINE}"
clr_green "#-#-##-- " -n; clr_escape "${BARS}" 1 33; clr_green " --##-#-#";
clr_green "#-#-##-- " -n; clr_escape "${BARS}" 1 33; clr_green " --##-#-#";
clr_green "#-#-##-- " -n; clr_escape "OFFENSIVE NOMAD'S DOTFILE INSTALLER" 1 31; clr_green " --##-#-#";
clr_green "#-#-##-- " -n; clr_escape "${BARS}" 1 33; clr_green " --##-#-#";
clr_green "#-#-##-- " -n; clr_escape "${BARS}" 1 33; clr_green " --##-#-#";
clr_green "${LINE}"
$BREAK

## Link BASHRC customizations
clr_brown echo 'LINKING Local bash customisations'; clr_escape
clr_blueb echo ". $HOME/.dotfiles/bashrc.local" | tee -a "$H"/.bashrc; clr_escape


## UPDATE SYSTEM
clr_red echo 'Install dependencies? (y/n) '; clr_escape; 
read -r depInstall
if [[ "${depInstall}" == "y" ]]; then
	clr_brown echo "...UPDATING SYSTEM"; clr_escape;
	sudo apt-get update
	sudo apt-get full-upgrade -y 
	clr_brown echo "...INSTALLING DEPENDENCIES"; clr_escape;
	sudo apt install -y build-essential neofetch openssh-client openssh-server git wget curl python3 python3-pip
else
clr_blueb clr_brown	echo "Skipping package dependency install"; clr_escape;
fi

"${COMPLETE[@]}"

## LINK DOTFILES
clr_red echo "Link User Dotfiles? (y/n)"; clr_escape;
read -r dotLink
if [[ "${dotLink}" == "y" ]]; then
	clr_brown "...LINKING DOTFILES"; clr_escape;

	ln -sfn "$D"/bashrc.local "$H"/.bashrc.local
	ln -sfn "$D"/bash.d "$H"/.bash.d
	
	if [ -d "$H"/.config ]; then
		mv "$H"/.config "$H"/.config.bak
		clr_green "...CONFIG FILES BACKUP CREATED"; clr_escape;
		ln -snf "$D"/config "$H"/.config
	fi
	

	if [ ! -d "$H"/MEGAsync ]; then
		ln -snf "$W"/MEGAsync "$H"
	fi
	
	ln -snf "$D"/backup-exclusions "$H"/.backup-exclusions
	ln -snf "$D"/backup-inclusions "$H"/.backup-inclusions
	ln -snf "$D"/gitconfig "$H"/.gitconfig
	ln -snf "$D"/gitignore "$H"/.gitignore
	ln -snf "$D"/mytheme.omp.json "$H"/.mytheme.omp.json
	ln -snf 
	sudo ln -snf "$D"/nanorc /etc/nanorc
fi
"${COMPLETE[@]}"

## LINKING ROOT DOTS
clr_brown "...LINKING ROOT DOTS"; clr_escape;
if [ -f "${ROOT}/.bashrc" ]; then
	sudo cp "${ROOT}/.bashrc" "${ROOT}/.bashrc.bak"
	clr_blueb clr_red "...ROOT BASHRC BACKUP CREATED"; clr_escape;
	sudo ln -snf "${R}"/bashrc "${ROOT}"/.bashrc
fi
"${COMPLETE[@]}"

## INSTALL NVM
clr_red echo "Install NVM? (y/n)"; clr_escape;
read -r installNvm
if [[ ${installNvm} == "y" ]]; then
	clr_brown "...INSTALLING NVM & NODEJS"; clr_escape;
	# shellcheck source=/dev/null
	source "$H/.bash.d/nvm"
	installNVM
fi
"${COMPLETE[@]}"

## INSTALL Homebrew
clr_red echo "Install Homebrew? (y/n)"; clr_escape;
read -r installHomebrew
if [[ ${installHomebrew} == "y" ]]; then
	clr_brown "...INSTALLING HOMEBREW"; clr_escape;
	# shellcheck source=/dev/null
	source "$H/.bash.d/brew"
	installBrew
fi
"${COMPLETE[@]}"

## INSTALL Oh-My-Posh
clr_red echo "Install Oh-My-Posh? (y/n)"; clr_escape;
read -r installMyPosh
if [[ ${installMyPosh} == "y" ]]; then
	clr_brown "...INSTALLING OH-MY-POSH"; clr_escape;
	# shellcheck source=/dev/null
	source "$H"/.bash.d/oh-my-posh
	installOhMyPosh
fi
"${COMPLETE[@]}"




# shellcheck source=/dev/null
source "$H"/.bashrc

clr_blueb clr_white clr_bold "#-#-##-- Offensive Nomad's dotfile installation complete"

exit 0
