#!/usr/bin/env zsh

function my-open-prs {
  gh search prs --author=@me --state=open --draft=false --limit 100 --json url --jq '.[].url'
}
