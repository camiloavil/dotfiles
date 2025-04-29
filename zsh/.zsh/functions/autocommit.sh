#!/bin/zsh

autocommit() {
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo "Error: Not a Git repository. Please navigate to a Git repository and try again."
        return 1
    fi

    if git diff --cached --quiet; then
        echo "Error: No changes staged for commit. Please stage your changes and try again."
        return 1
    fi

    echo "Let's AutoCommit"
    local commit_file="/tmp/commit.txt"
    trap 'rm -f "$commit_file"; echo "Finish AutoCommit"' EXIT

    if ! git diff --cached | llm_wrapper -t gcommit > "$commit_file"; then
        echo "Error: Failed to generate commit message."
        return 1
    fi

    if ! less "$commit_file"; then
        echo "Error: Failed to display commit message."
        return 1
    fi

    if ! git commit -m "$(cat "$commit_file")"; then
        echo "Error: Git commit failed."
        return 1
    fi
}

