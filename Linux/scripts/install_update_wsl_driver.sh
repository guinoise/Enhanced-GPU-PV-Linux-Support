#!/bin/bash
echo "Install / Update WSL drivers"
echo
DEPLOY=0
DEPLOYED=0
if [ -d /usr/lib/wsl ]; then
  echo "Driver already installed"
  DEPLOYED=1
else
  echo "Driver NOT installed"
  DEPLOY=1
fi

if [ $DEPLOY -eq 1 ]; then
  if [ $DEPLOYED -eq 1 ]; then
    echo "Removing old WSL drivers"
    rm -Rf /usr/lib/wsl
  fi
  echo "Deploying drivers"
  echo "...TODO..."
fi

