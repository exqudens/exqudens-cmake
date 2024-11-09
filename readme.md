# exqudens-cmake

##### how-to-git-tag

1. `git tag -a 0.0.0 -m "version: 0.0.0"`
2. `git push <remote_name> 0.0.0` example: `git push origin 0.0.0`

##### how-to-remove-git-branch

1. `git push <remote_name> --delete <branch_name>` example: `git push origin --delete 1-implement-project`
2. `git branch -D <branch_name>` example: `git branch -D 1-implement-project`

##### how-to-test

1. `cmake --preset windows.ninja`
2. `cmake --build --preset windows.ninja` or `cmake --build --preset windows.ninja --target cmake-test`
