#!/bin/sh

cd "${GITHUB_WORKSPACE}" || exit

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

if [ "${INPUT_REPORTER}" = 'github-pr-review' ]; then
  # erroformat: https://git.io/JeGMU
  remark --quiet . 2>&1 |
  reviewdog \
    -efm="%f\n%l:%c: %m" \
    -name="remark-lint" \
    -reporter="github-pr-review" \
    -level="${INPUT_LEVEL}" \
    -filter-mode="${INPUT_FILTER_MODE:-added}" \
    -fail-on-error="${INPUT_FAIL_ON_ERROR:-false}" \
    -level="${INPUT_LEVEL:-error}" \
    ${INPUT_REVIEWDOG_FLAGS}
else
  # github-pr-check,github-check (GitHub Check API) doesn't support markdown annotation.
  remark --quiet --use=remark-preset-lint-recommended . 2>&1 |
    reviewdog -efm="%f\n%l:%c: %m" -name="remark-lint" -reporter="${INPUT_REPORTER:-github-pr-check}" -level="${INPUT_LEVEL}" -tee
fi
