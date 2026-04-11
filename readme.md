# exqudens-cmake

## how-to-config

1. select one of presets as `<preset>` from output of `cmake --list-presets`:
    * `windows.ninja`
    * `linux.ninja`
    * `darwin.ninja`
2. `camke --preset <preset>`

## how-to-test

1. follow `how-to-config` instructions
2. `cmake --build build --target cmake-test`

## how-to-export

1. follow `how-to-config` instructions
2. `cmake --build build --target conan-export`

## how-to-git-tag

1. `git tag -a 0.0.0 -m "version: 0.0.0"` example: `git tag -a 0.0.0 -m "version: 0.0.0"`
2. `git push <remote_name> 0.0.0` example: `git push origin 0.0.0`

## how-to-remove-git-branch

1. `git push <remote_name> --delete <branch_name>` example: `git push origin --delete 1-implement-project`
2. `git branch -D <branch_name>` example: `git branch -D 1-implement-project`

## vscode

1. `git clean -xdf`
2. `cmake --preset ${preset}`
3. `cmake --build --preset ${preset} --target vscode`
4. use vscode debugger launch configurations: `ctest`

### extensions

For `command-variable-launch.json`
use [Command Variable](https://marketplace.visualstudio.com/items?itemName=rioj7.command-variable#pickstringremember) `version >= v1.69.0`
