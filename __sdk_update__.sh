#!/bin/bash

tmpfile="/tmp/sdk_update.$$.txt"
rm -f "$tmpfile"

function sdk_update_function()
{
        echo y | android update sdk --no-ui --all --filter "$1" > "$tmpfile" 2>&1
        cat "$tmpfile"
        cat "$tmpfile" | grep -i 'package installed' > /dev/null 2>&1
        ret_code=$?
        rm -f "$tmpfile"
        return $ret_code
}

if [[ "$1""x" == "build-tools-"* ]]; then
        num=`echo "$1"|cut -d'-' -f3`

        if [ ! -e "$ANDROID_SDK/build-tools/""$num" ]; then
                sdk_update_function "$1"
                exit $?
        else
                echo "$1 already installed"
                exit 0
        fi
elif [[ "$1""x" == "sys-img-armeabi-v7a-android-"* ]]; then
        num=`echo "$1"|awk -F'-' '{print $NF}'`

        if [ ! -e "$ANDROID_SDK/system-images/android-""$num" ]; then
                sdk_update_function "$1"
                exit $?
        else
                echo "$1 already installed"
                exit 0
        fi
elif [[ "$1""x" == "android-"* ]]; then
        num=`echo "$1"|awk -F'-' '{print $NF}'`

        if [ ! -e "$ANDROID_SDK/platforms/android-""$num" ]; then
                sdk_update_function "$1"
                exit $?
        else
                echo "$1 already installed"
                exit 0
        fi
else
        sdk_update_function "$1"
        exit $?
fi


echo "Unknown Paramter"
exit 1
