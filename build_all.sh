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

TAGS=()

for dir in autogen/*; do
  TAG="$(cat "${dir}/TAG")"
  echo "Building ${TAG} in ${dir}"
  chronic docker build --tag "$TAG" "${dir}/."
  TAGS+="$TAG"
done

if [[ "$PUSH" -eq 0 ]]; then
  exit 0
fi

for dir in autogen/*; do
  TAG="$(cat "${dir}/TAG")"
  echo "Pushing $TAG"
  chronic docker push "$TAG"
done
