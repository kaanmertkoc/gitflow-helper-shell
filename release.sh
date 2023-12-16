#!/bin/bash

# Capture the version argument
version=$1
echo "Arguments: $*"
if [ -z "$version" ]; then
  echo "You must provide a version number. Usage: hotfix <version>"
  exit 1
fi

# Function to check if a command exists
is_command_available() {
  command -v $1 >/dev/null 2>&1
}

# Check for lolcat and GitHub CLI (gh)
is_command_available lolcat
is_lolcat_available=$?
is_command_available gh
is_gh_available=$?

if [ $is_lolcat_available -eq 0 ]; then
  # Use the provided version to create a release branch
  echo "Creating release $version" | lolcat
  git flow release start $version | lolcat
  echo "Release branch created" | lolcat
  
  # Rest of your commands with lolcat
  echo "Release works" | lolcat
  npm version patch | lolcat
  echo "made version patch" | lolcat
  git add . | lolcat && git commit -m "docs: version bump" | lolcat
  echo "committed" | lolcat
  git flow release publish | lolcat
  echo "published the branch 🎉" | lolcat
  if [ $is_gh_available -eq 0 ]; then
    gh pr create --title "Release $version" --body "Release $version" --base main
    echo "created the PR 🎉" | lolcat
  fi
else
  # Use the provided version to create a release branch
  echo "Creating release $version"
  git flow release start $version
  echo "Release branch created"

  # Rest of your commands
  echo "Release works"
  npm version patch
  echo "made version patch"
  git add . && git commit -m "docs: version bump"
  echo "committed"
  git flow release publish
  echo "published the branch 🎉"
  if [ $is_gh_available -eq 0 ]; then
    gh pr create --title "Release $version" --body "Release $version" --base main
    echo "created the PR 🎉"
  fi
fi
