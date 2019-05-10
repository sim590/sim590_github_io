#!/bin/bash

git submodule update --init
has_submodule=$?

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project.
hugo -t imperfect

if (( $? == 0 )) && (( $has_submodule == 0 )); then
  # Go To Public folder
  cd public || exit 1

  git reset master
  git checkout master

  git add -A
  msg="rebuilding site `date`"
  (( $# == 1 )) && msg="$1"
  git commit -m "$msg"
  git push origin master

  cd -
fi

# vim: set sts=2 ts=2 sw=2 tw=120 et :

