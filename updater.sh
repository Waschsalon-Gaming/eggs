#!/bin/bash

# Configuration
log_file="darkrp-update.log"
repo_url="https://github.com/FPtje/DarkRP"
repository_path="/home/container/garrysmod/gamemodes"
repository_name="darkrp"

# Function to log messages to a file
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$log_file"
}

# Function to check if the repository has been updated
check_repo_commit() {
    current_commit_hash=$(git ls-remote "$repo_url" HEAD | awk '{print $1;}')
    if [[ "$last_commit_hash" != "$current_commit_hash" ]]; then
        return 1  # Repository has been updated
    else
        return 0  # Repository is up-to-date
    fi
}

# Function to update the repository
update_repository() {
    log_message "Updating DarkRP repository"
    cd "$repository_path" || exit 1

    rm -rf "$repository_name"
    git clone -q "$repo_url"
    mv "DarkRP" "$repository_name"
    cd - || exit 1

    last_commit_hash=$(git ls-remote "$repo_url" HEAD | awk '{print $1;}')
    log_message "Updated DarkRP to commit $last_commit_hash"
}

# Main script
if [ -d "$repository_path" && -d "$repository_path/$repository_name" ]; then
    cd "$repository_path/$repository_name" || exit 1

    last_commit_hash=$(git rev-parse HEAD)
    cd - || exit 1

    if ! check_repo_commit; then
        update_repository
    else
        log_message "DarkRP up-to-date"
    fi
else
    mkdir $repository_path
    update_repository()
fi
