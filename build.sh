#!/bin/bash

#Parse argument for filepath
BUILD_PROJ=$1

#import default config file
source ./configs/default.config

#import user config file if exists
if [ -f "./configs/$BUILD_PROJ.config" ]; then
    source ./configs/$BUILD_PROJ.config
else
    echo "No user config file found"
    exit 1
fi


# cleanup
if [ -d "builddir" ]; then
    rm -rf builddir
fi


# argbuilder for Nativefier
mkdir builddir && cd builddir

NATIVEFIER_ARGUMENTS="\"$URL\""
NATIVEFIER_ARGUMENTS="$NATIVEFIER_ARGUMENTS --name \"$APP_NAME\""
NATIVEFIER_ARGUMENTS="$NATIVEFIER_ARGUMENTS --app-version \"$VERSION\""
NATIVEFIER_ARGUMENTS="$NATIVEFIER_ARGUMENTS --width $WIDTH"
NATIVEFIER_ARGUMENTS="$NATIVEFIER_ARGUMENTS --height $HEIGHT"
NATIVEFIER_ARGUMENTS="$NATIVEFIER_ARGUMENTS --background-color \"$BACKGROUND_COLOR\""
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
    NATIVEFIER_ARGUMENTS="$NATIVEFIER_ARGUMENTS --user-agent \"$USER_AGENT\""
fi

echo "##############################################"
echo "Nativefier arguments:"
echo $NATIVEFIER_ARGUMENTS
echo "##############################################"

# run nativefier
nativefier $NATIVEFIER_ARGUMENTS
ls -la

zip -r "$FILENAME-native-$VERSION-$PLATFORM-$ARCH.zip" $APP_NAME-$PLATFORM-$ARCH

mkdir -p ../export
mv "$FILENAME-native-$VERSION-$PLATFORM-$ARCH.zip" ../export


# argbuilder for AppImage
mv $APP_NAME-$PLATFORM-$ARCH $FILENAME.AppDir
cp ../icons/$BUILD_PROJ.png $FILENAME.AppDir/$BUILD_PROJ.png
cd $FILENAME.AppDir

echo "[Desktop Entry]" > $FILENAME.desktop
echo "Name=$APP_NAME" >> $FILENAME.desktop
echo "Exec=AppRun %U" >> $FILENAME.desktop
echo "Terminal=false" >> $FILENAME.desktop
echo "Type=Application" >> $FILENAME.desktop
echo "Icon=$BUILD_PROJ" >> $FILENAME.desktop
echo "X-AppImage-Version=$VERSION" >> $FILENAME.desktop
echo "Categories=AudioVideo;" >> $FILENAME.desktop
echo "StartupWMClass=$APP_NAME" >> $FILENAME.desktop

echo "#!/bin/bash" > AppRun
echo "exec \$APPDIR/$APP_NAME" >> AppRun
chmod +x ./AppRun

cd ../

[ ! -e /tmp/appimagetool ] && wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage -O /tmp/appimagetool
chmod +x /tmp/appimagetool

/tmp/appimagetool "$FILENAME.AppDir" "$APP_NAME.AppImage"
mv "$APP_NAME.AppImage" ../export




