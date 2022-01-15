#!/bin/bash

eval "$(oh-my-posh --init --shell bash --config ~/.mytheme.omp.json)"

function installOhMyPosh {
    brew tap jandedobbeleer/oh-my-posh
    brew install oh-my-posh
}

export installOhMyPosh 
