#!/bin/bash

# Check if version number is provided
if [ -z "$1" ]; then
  echo "Usage: release_finish <version_number>"
  exit 1
fi

# Function to check if a command exists
is_command_available() {
  command -v $1 >/dev/null 2>&1
}

# Check for lolcat and GitHub CLI (gh)
is_command_available lolcat
is_lolcat_available=$?

version_number=$1

# Path to the temporary commit message editing script
commit_editor_script="/tmp/edit_commit_message_$$.sh"

# Create the temporary commit message editing script
cat > "$commit_editor_script" <<EOF
#!/bin/bash
commit_message_file="\$1"
sed -i '/^[vV]?\d+\.\d+(\.\d+)*\$/d' "\$commit_message_file"
EOF

if [ $is_lolcat_available -eq 0 ]; then
    echo "Finishing hotfix $version_number" | lolcat
else
    echo "Finishing hotfix $version_number"
fi

# Make the temporary script executable
chmod +x "$commit_editor_script"

# Set Git to use the custom commit message editing script
export GIT_EDITOR="$commit_editor_script"

if [ $is_lolcat_available -eq 0 ]; then
    # Finish the release with Git Flow
    git flow hotfix finish -m "Hotfix $version_number" "$version_number" | lolcat
else
    # Finish the release with Git Flow
    git flow hotfix finish -m "Hotfix $version_number" "$version_number"
fi

if [ $is_lolcat_available -eq 0 ]; then
    echo "Finished hotfix $version_number 🎉" | lolcat
else
    echo "Finished hotfix $version_number 🎉"
fi

if [ $is_lolcat_available -eq 0 ]; then
    git push origin dev --tags | lolcat
    git checkout main | lolcat 
    git push origin main --tags | lolcat
    echo "Pushing to origin" | lolcat
else
    git push origin dev --tags
    git checkout main
    git push origin main --tags
    echo "Pushing to origin"
fi

# Cleanup: Remove the temporary script
rm -f "$commit_editor_script"
