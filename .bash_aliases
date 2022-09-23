# Get current branch name
get_branch_name() {
    echo $(git symbolic-ref --short -q HEAD)
}


# Upgrade packages
aptupupgrade() {
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get dist-upgrade -y
}
# Clean environment.
function clean() {
    find ./ -name '*.pyc' -exec rm -rf {} \;
    find ./ -name '__pycache__' -print0 | xargs -0 rm -rf;
    rm -rf ./xunit* ./.coverage* ./.pytest_cache ./*artifacts.tar.gz;
    truncate -s0 log/voipgrid*.log
    find ./ -name '*.py.py' -delete;
    find ./ -name '*.html.py' -delete;
    find ./ -name '*.txt.py' -delete;
    echo "Done"
}
function sudo_clean() {
    sudo find ./ -name '*.pyc' -exec rm -rf {} \;
    sudo find ./ -name '__pycache__' -print0 | xargs -0 rm -rf;
    sudo rm -rf ./xunit* ./.coverage* ./.pytest_cache ./*artifacts.tar.gz;
    sudo truncate -s0 log/voipgrid*.log
    sudo find ./ -name '*.py.py' -delete;
    sudo find ./ -name '*.html.py' -delete;
    sudo find ./ -name '*.txt.py' -delete;
    echo "Done"
}

# Process changes in *.in files.
function pipcompile() {
    pip-compile --no-annotate -r requirements.in
    pip-compile --no-annotate -r requirements-dev.in
    pip-compile --no-annotate -r requirements-staging.in
}

# Sync local env with requirements txt files.
function pipsync() {
    pip-sync requirements.txt requirements-dev.txt
    ./contrib/patch_packages.py --apply
}

# new minor or hotfix tag
tag() {
    # update everything including tags.
    git fetch --tags

    # get tag for current HEAD
    current_tag_full=$(git describe --tag)

    # get jus the tag, strip the number of commits ahead and short commit hash
    current_tag=$(cut -d '-' -f 1 <<< "$current_tag_full")

    if [[ $# -eq 0 ]]
    then
        echo "$current_tag"
    else
        # strip prefix 'v'
        current_version=${current_tag:1}

        # break it up into $numbers. Don't use an array, because they
        # are not interchangeable with zsh.
        major=$(echo "$current_version" | cut -d. -f1)
        minor=$(echo "$current_version" | cut -d. -f2)
        patch=$(echo "$current_version" | cut -d. -f3)

        # tag up -> from 2.18.2 to 2.19.0
        if [[ "$1" == "up" ]]
        then
            new_tag="v$major.$((minor+1)).0"

        # tag hotfix -> from 2.18.2 to 2.18.3
        elif [[ "$1" == "hotfix" ]]
        then
            new_tag="v$major.$minor.$((patch+1))"
        fi

        echo "git tag -a $new_tag -m '$new_tag'"
        echo "git push origin $new_tag"
    fi
}

# remove traces of branches that were removed.
function ggone() {
    git fetch -p
    git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D
}
# Loop given tests until it fails.
function rununtilfail() {
    set -x
    echo "Start testrun until failure '$@'"
    while [ "$?" ];
        do
            pytest "$@";
    done
    set +x
}

# Remove given branch(es) local and remote.
function gdelete(){
while [[ $# -gt 0 ]]
do
    key="$1"
    echo "Deleting git branch '$key'"
    git push origin --delete --no-verify $key
    git branch -D $key
    shift # past argument
done

}

# Start screen to manage vpn in.
function start_vpn() {
    screen -t "start_vpn" bash -c "sudo openvpn --config /etc/openvpn/myvpn/myvpn.ovpn"
}
function updateapp(){
    if [ -z "${VIRTUAL_ENV}" ]; then
        name=$(basename `pwd`)
        workon $name
        if [ -n "${VIRTUAL_ENV}" ]; then
            echo "Activated '${name}' virtualenv for you";
        else
            echo "No virtualenv found for $name"
            return
        fi
    fi
    clean
    rm  -rf /home/uittenbroek/projects/xs2event-ops/output
    ./build.sh config INVENTORY=production
    installreq
}

alias doco=docker-compose
alias gs="git status"
alias gp="git pull -p"
alias gma="git commit --amend --no-edit"
alias gitmerge="git merge --no-ff"

