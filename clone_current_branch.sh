#!/bin/bash

# Get the branch name from the argument
BRANCH=$1

# Clone the repository with the specified branch
git clone --depth=1 --branch "$BRANCH" https://github.com/cleffex/elora /opt/odoo
