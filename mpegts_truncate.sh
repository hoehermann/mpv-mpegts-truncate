#!/bin/bash

zenity --question --text="Really truncate up to current position (byte ${3})?\n(Data will be deleted permanently.)" && ( error=$("$(dirname "$0")"/fcollapse "$@" 2>&1) && exit 0 || zenity --error --title="fcollapse failed" --text="${error}" && exit 1 )
