#!/bin/bash

case $# in
3)
  zenity --question --text="Really truncate up to current position (byte ${2})?\n(Data will be deleted permanently.)" && ( error=$( fallocate --collapse-range --offset $1 --length $2 "$3" 2>&1 ) || ( zenity --error --title="fallocate collapse failed" --text="${error}" && false ) )
;;
2)
  zenity --question --text="Really truncate to current position (byte ${1})?\n(Data will be deleted permanently.)" && ( error=$( truncate -s $1 "$2" 2>&1 ) || ( zenity --error --title="truncate failed" --text="${error}" && false ) )
;;
*)
  zenity --error --text="Unsupported number of parameters.\nChose 3 for collapsing (front or intermediate) or 2 for truncation."
;;
esac
