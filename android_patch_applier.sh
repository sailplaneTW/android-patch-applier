#!/usr/bin/env bash

# ----- [global variable] -----
ANDROID_BUILD_TOP=''
CURRENT_TIME=''
BRANCH_NAME=''
BRANCH_NAME_POSTFIX=''
PATCHES_NUM=0
declare -a PATCHES_DIR
declare -a PATCHES_CONTENT
GIT_LINK_PREFIX='' # TODO : waiting for user input

# ----- [general functions] -----

# show_info ($1 : color, $2 : msg)
function show_info() {
    local msg=$2
    local color='1;31'

    if [ "$1" = 'light-white' ]; then
        color='1;37'
    elif [ "$1" = 'green' ]; then
        color='1;32'
    elif [ "$1" = 'yellow' ]; then
        color='1;33'
    elif [ "$1" = 'blue' ]; then
        color='1;34'
    elif [ "$1" = 'light-blue' ]; then
        color='1;36'
    elif [ "$1" = 'red' ]; then
        color='1;31'
    else
        color='1;31'
    fi

    echo -e "\033[${color}m$msg\033[0m"
}

# apply_patch ($1 : working directory, $2,$3 : patch partial link)
# FIXME : the second parameter may have more than one whitespace ?
function apply_patch() {
    local dir=$1
    local patch_link="$2 $3"
    local current_branch='no branch'

    cd ${dir}
    current_branch=`git branch | sed -n -e 's/^\* \(.*\)/\1/p'`

    if [ ! "${current_branch}" == "${BRANCH_NAME}" ]; then
        repo start ${BRANCH_NAME} . ; repo sync .
    fi

    git fetch ${GIT_LINK_PREFIX}:${patch_link} && git cherry-pick FETCH_HEAD
    cd ${ANDROID_BUILD_TOP}

    show_info ' ' ' '
}

# register_patches ($1 : dir, $2 : patch partial)
function register_patch() {
    local dir=$1
    local patch_link=$2
    
    PATCHES_DIR[${PATCHES_NUM}]=$dir
    PATCHES_CONTENT[${PATCHES_NUM}]=$patch_link
    PATCHES_NUM=$((${PATCHES_NUM} + 1))
}

# ------------------------------------------------------------------------------------------- #

BRANCH_NAME_POSTFIX='' # TODO : waiting for user input
register_patch 'xxxx1'   'yyyy1' # TODO : waiting for user input
# ...
register_patch 'xxxxn'   'yyyyn' # TODO : waiting for user input


function apply_all_patches() {
    for (( i=0; i<${#PATCHES_DIR[@]}; i++ ));
    do

        local current_num=$(($i+1))
        show_info 'green' "[${current_num}/${PATCHES_NUM}]\tNow patching ${PATCHES_DIR[$i]}"
        apply_patch ${PATCHES_DIR[$i]} ${PATCHES_CONTENT[${i}]}

    done
}

# ------------------------------------------------------------------------------------------- #
function main() {
    # check current position
    if [ ! -d './bionic' ] || [ ! -d './dalvik' ]; then
        show_info 'red' '\nPlease move to the top of android source tree ...\n'
        return
    fi

    ANDROID_BUILD_TOP=`pwd`
    CURRENT_TIME=`date +"%Y%m%d_%H%M"`
    BRANCH_NAME="${CURRENT_TIME}-${BRANCH_NAME_POSTFIX}"

    show_info 'light-blue' "\n\n\nPatches will be applied to branch [${BRANCH_NAME}]\n"
    apply_all_patches
    show_info 'light-blue' "\n......... [Done] .........\n"
    
}
main

