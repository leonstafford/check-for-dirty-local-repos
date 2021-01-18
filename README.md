# Check for dirty local repos

Script to check for any uncommitted/unpushed changes in repos before wiping system.

[![codecheck](https://github.com/leonstafford/check-for-dirty-local-repos/workflows/codecheck/badge.svg)](https://github.com/leonstafford/check-for-dirty-local-repos/actions)

## Use case

I have a bunch of git repositories on my system. I run very light systems, whether on OpenBSD, macOS or Linux, so not really a worry for me to blow them away frequently. The most important thing that would suck to lose is any development work on my projects that I'm in the middle of and may not have pushed, which is where I'm at today.

## Acceptance criteria

 - [ ] prints list of each repo directory, listing whether it has uncommitted or unpushed changes (checkout out branch only sufficient)
 - [ ] prints the dirty files from applicable repos

Not adding a batch commit and push just yet, as opens up to accidentally pushing sensitive infos.

## Usage 

- `sh check.sh`

Will output a list of the repos with uncommitted / unpushed changes.

```
$ sh check.sh ~
check-for-dirty-local-repos: you have unstaged changes.
ljsdotdev: you have unstaged changes.
lokl-cli: you have unstaged changes.
wp2static-addon-cloudflare-workers: you have unstaged changes.
```
