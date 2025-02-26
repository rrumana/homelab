#!/bin/bash

# Set your GitHub username
GITHUB_USERNAME="rrumana"
DEFAULT_BRANCH="main"

# Check if GITHUB_TOKEN is set
if [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: GITHUB_TOKEN is not set. Please export it before running the script."
    exit 1
fi

# Check if jq is installed
if ! command -v jq &>/dev/null; then
    echo "Error: jq is not installed. Please install jq and retry."
    exit 1
fi

# Fetch all repository details using GitHub API
echo "Fetching repositories for user $GITHUB_USERNAME..."
REPOS_JSON=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
    "https://api.github.com/user/repos?per_page=100")

# Extract SSH clone URLs and default branch names
REPOS=$(echo "$REPOS_JSON" | jq -r '.[] | "\(.ssh_url) \(.default_branch)"')

# Clone each repository and set upstream branch
while read -r REPO_URL DEFAULT_BRANCH; do
    REPO_NAME=$(basename -s .git "$REPO_URL")
    
    if [ -d "$REPO_NAME" ]; then
        echo "Skipping $REPO_NAME - already exists."
    else
        echo "Cloning $REPO_NAME..."
        git clone "$REPO_URL"
        cd "$REPO_NAME" || continue

        # Ensure the correct default branch is checked out
        git checkout "$DEFAULT_BRANCH"

        # Set tracking to origin/<default_branch>
        git branch --set-upstream-to=origin/"$DEFAULT_BRANCH" "$DEFAULT_BRANCH"

        cd ..
    fi
done <<< "$REPOS"

echo "All repositories have been cloned and set up for contribution."

