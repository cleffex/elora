#!/bin/bash

# Get the current branch name
BRANCH=$(git symbolic-ref --short HEAD)

# Clone the repository with the current branch
git clone --depth=1 --branch "$BRANCH" https://github.com/cleffex/elora /opt/odoo
