function git-delete-local-branches
    git for-each-ref --format '%(refname:short)' refs/heads | grep -v master | xargs git branch -D
end