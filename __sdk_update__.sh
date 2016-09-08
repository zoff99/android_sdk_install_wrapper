#!/usr/bin/env bash
#
# Wrapper for "android sdk" script installer
# Copyright (C) 2016  Zoff <zoff@zoff.cc>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#

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
