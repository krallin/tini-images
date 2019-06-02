#!/bin/bash
set -o errexit
set -o nounset

USAGE="$0 [--push]"

PUSH=0

if [[ "$#" -eq 0 ]]; then
  # Noop
  true
elif [[ "$#" -gt 1 ]]; then
  echo "$USAGE" >&2
  exit 1
elif [[ "$1" != "--push" ]]; then
  echo "$USAGE" >&2
  exit 1
else
  PUSH=1
fi


CHRONIC="$(command -v chronic || true)"

function chronic () {
  if [[ -n "$CHRONIC" ]];then
    "$CHRONIC" "$@"
  else
    "$@"
  fi
}

./src/autogen.sh

for dir in autogen/*; do
  SOURCE="$(cat "${dir}/SOURCE-TAG")"
  TAG="$(cat "${dir}/TAG")"
  echo "Building ${TAG} FROM ${SOURCE} in ${dir}"
  chronic docker pull "$SOURCE" # ensure up to date
  chronic docker build --tag "$TAG" "${dir}/."
done

if [[ "$PUSH" -eq 0 ]]; then
  exit 0
fi

for dir in autogen/*; do
  TAG="$(cat "${dir}/TAG")"
  echo "Pushing $TAG"
  chronic docker push "$TAG"
done
