#!/bin/bash


day_of_week=$(date +%w)

displayStatus

if [ $day_of_week -eq 0 ] || [ $day_of_week -eq 3 ] || [ $day_of_week -eq 6 ]; then
	/scripts/check_deregistered.sh
fi
