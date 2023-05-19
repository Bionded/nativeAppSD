#!/bin/bash

#Parse argument for filepath
IMPORT_CONFIG_FILE=$1

#import default config file
source ./configs/default.config

#import user config file if exists
if [ -f "$IMPORT_CONFIG_FILE" ]; then
    source $IMPORT_CONFIG_FILE
else
    echo "No user config file found"
    exit 1
fi

# argbuilder for Nativefier

NATIVEFIER_ARGUMENTS="$URL"
NATIVEFIER_ARGUMENTS="$NATIVEFIER_ARGUMENTS $FILENAME-native"
NATIVEFIER_ARGUMENTS="$NATIVEFIER_ARGUMENTS --name $APP_NAME"
NATIVEFIER_ARGUMENTS="$NATIVEFIER_ARGUMENTS --version $VERSION"
NATIVEFIER_ARGUMENTS="$NATIVEFIER_ARGUMENTS --width $WIDTH"
NATIVEFIER_ARGUMENTS="$NATIVEFIER_ARGUMENTS --height $HEIGHT"
NATIVEFIER_ARGUMENTS="$NATIVEFIER_ARGUMENTS --background-color $BACKGROUND_COLOR"
NATIVEFIER_ARGUMENTS="$NATIVEFIER_ARGUMENTS --platform $PLATFORM"
NATIVEFIER_ARGUMENTS="$NATIVEFIER_ARGUMENTS --arch $ARCH"
if [ "$FULLSCREEN" = true ] ; then
    NATIVEFIER_ARGUMENTS="$NATIVEFIER_ARGUMENTS --fullscreen"
fi
if [ "$PORTABLE" = true ] ; then
    NATIVEFIER_ARGUMENTS="$NATIVEFIER_ARGUMENTS --portable"
fi
if [ "$DISABLE_DEV_TOOLS" = true ] ; then
    NATIVEFIER_ARGUMENTS="$NATIVEFIER_ARGUMENTS --disable-dev-tools"
fi
if [ "$DISABLE_CONTEXT_MENU" = true ] ; then
    NATIVEFIER_ARGUMENTS="$NATIVEFIER_ARGUMENTS --disable-context-menu"
fi
if [ "$WIDEVINE" = true ] ; then
    NATIVEFIER_ARGUMENTS="$NATIVEFIER_ARGUMENTS --widevine"
fi
if [ "$USER_AGENT" != false ] ; then
    NATIVEFIER_ARGUMENTS="$NATIVEFIER_ARGUMENTS --user-agent $USER_AGENT"
fi

echo "##############################################"
echo "Nativefier arguments:"
echo $NATIVEFIER_ARGUMENTS
echo "##############################################"

# run nativefier
nativefier $NATIVEFIER_ARGUMENTS
zip -r $FILENAME-native-$VERSION-$PLATFORM-$ARCH.zip $FILENAME-native > /dev/null 2>&1

ZIP_FILE=$FILENAME-native-$VERSION-$PLATFORM-$ARCH.zip