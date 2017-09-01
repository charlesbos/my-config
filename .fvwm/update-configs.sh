#!/bin/sh
# Simple script to make changes to the Fvwm config file on the go

usage() {
  echo "update-configs.sh task-number [ARGS]

Where task-number can be:
  1 - Change the focus policy
  2 - Enable/Disable edge scrolling
  3 - Change the theme

ARGS:
  1 - new-policy old-policy new-policy-var old-policy-var
  2 - new-scroll-val old-scroll-val new-scroll-var old-scroll-var
  3 - new-theme-name

For more information see your config file: $FVWM_USERDIR/config"
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
  3)
    themepath=`grep "Read themes.*theme" $FVWM_USERDIR/config | cut -d ' ' -f 2`
    sed -i "s@$themepath@themes/$2/theme@g" $FVWM_USERDIR/config
    unset themepath
    ;;
  *)
    usage
    ;;
esac
