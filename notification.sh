#!/bin/bash


if [ -f ~/notification.txt]; then
	cat ~/notification.txt
	rm ~/notification.txt
fi
