#!/bin/sh
# Simple script to make changes to the Fvwm config file on the go

usage() {
  echo "update-configs.sh task-number [OPTIONS]

Where task-number can be:
  1 - Change the focus policy
  2 - Enable/Disable edge scrolling
  3 - Change the theme

Options:
  These are dependent on the operation in question. Please consult your config
  file: $FVWM_USERDIR/config"
} 

case $1 in 
  1)
    sed -i "s/^Style \* $3\b/Style \* $2/g" $FVWM_USERDIR/config
    sed -i "s/^InfoStoreAdd focus_method $5\b/InfoStoreAdd focus_method $4/g" \
      $FVWM_USERDIR/config
    ;;
  2)
    sed -i "s/^EdgeScroll $3\b/EdgeScroll $2/g" $FVWM_USERDIR/config
    sed -i "s/^InfoStoreAdd edge_scroll $5\b/InfoStoreAdd edge_scroll $4/g" \
      $FVWM_USERDIR/config
    ;;
  *)
    usage
    ;;
esac
