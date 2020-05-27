#!/bin/sh

cd "${GITHUB_WORKSPACE}" || exit

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

npm install

remark --quiet . 2>&1 | reviewdog \
  -efm="%-P%f\ %#%l:%c %# %trror  %m\ %s %# %trror  %m\ %#%l:%c %# %tarning  %m\ %s %# %tarning  %m\ %-Q\ %-G%.%#" \
  -name="remark-lint" \
  -reporter="github-pr-review" \
  -level="${INPUT_LEVEL:-info}" \
  ${INPUT_REVIEWDOG_FLAGS} \
  -tee