# About how litebastion git repo was moved inside sigsum's ansible repo

The litebastion ansible role was first kept in a separete git repo,
but we wanted to move it inside the larger ansible repo.

## Useful tool: git-filter-repo

The git-filter-repo tool was installed using "apt install
git-filter-repo". It can be used to rewrite history in a git repo.

## Procedure used

The idea is to first prepare the litebastion repo so that it has a
directory structure matching the structure in the ansible repo, and
then merge.

The change was done by first running the following "git filter-repo"
command in the litebastion repo to move everything inside a
roles/litebastion/ directory there:

```
git filter-repo --path-rename :roles/litebastion/
```

Then the merge was done like this in the ansible repo:

```
cd ansible/
git checkout -b elias/merge-litebastion-repo
git remote add litebastion /tmp/litebastion
git fetch litebastion
git merge --allow-unrelated-histories litebastion/main
git remote remove litebastion
```

## Related issue and MR:

https://git.glasklar.is/sigsum/admin/litebastion/-/issues/2 - "Move into admin/ansible and refactor"

https://git.glasklar.is/sigsum/admin/ansible/-/merge_requests/55 - "Merge litebastion repo into roles/litebastion/ directory"

## Other links

Using the git-filter-repo tool for this was suggested by filippo at a
sigsum weekly meeting:
https://git.glasklar.is/sigsum/project/documentation/-/blob/main/archive/2025-03-04--meeting-minutes.md

The merge procedure used follows what was suggested on this
stackoverflow page ("How do you merge two Git repositories?"):
https://stackoverflow.com/questions/1425892/how-do-you-merge-two-git-repositories/10548919#10548919
