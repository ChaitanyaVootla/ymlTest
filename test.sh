retry_command() {
  for i in $(seq 1 3);
  do
    {
      "$@"
      ret=$?
      [ $ret -eq 0 ] && break;
    } || {
      echo "retrying $i of 3 times..."
    }
  done
  return $ret
}

git_commit_and_push() {
    local clonePath="/Users/vootlac/pip/workspace/ymlTest"
    local userToken="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"
    local commitMessage="wasup"

    pushd $clonePath

    REMOTE_URL=$(git config --get remote.origin.url)
    REPO_NAME=$(basename "$REMOTE_URL" .git)
    REPO_OWNER=$(basename $(dirname "$REMOTE_URL"))
    REMOTE_URL="https://$userToken@github.com/$REPO_OWNER/$REPO_NAME.git"
    BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

    # Set the new remote repository URL with the token
    git remote set-url origin $REMOTE_URL

    retry_command git add -A
    retry_command git commit -m "$commitMessage"
    retry_command git push origin $BRANCH_NAME
    popd
}

git_commit_and_push