#!/bin/bash



readarray -t mentee_names < <(ls ~/mentees)

for mentee_name in ${mentee_names[@]}; do
	number_of_domains=0
	for domain_ in Sysad Webdev Appdev; do
		readarray -t mentor_names < <(ls ~/mentors/$domain_)
		for mentor in ${mentor_names[@]}; do
			OLDIFS=$IFS
			readarray -t allocated_mentees < ~/$domain_/$mentor/allocatedMentees.txt
			IFS=' '
			for allocated_mentee_info in ${allocated_mentees[@]}; do
				read -a allocated_mentee_info_array <<< "$allocated_mentee_info"
				if [ "${allocated_mentee_info_array[1]}" == "$mentee_name" ]; then
					allocated_mentor="$mentor"
				fi
			done
			IFS=$OLDIFS
		done
	done
	num_domains_registered=3
	domains_registered=()
	for domain_ in sysad web app; do
		case $domain_ in
			"sysad") domain_dev=Sysad;;
			"web") domain_dev=Webdev;;
			"app") domain_dev=Appdev;;
		esac
		if ! [ -d ~/$mentee_name/${domain} ]; then
			num_domains_registered=$(($num_domains_registered - 1))
			for task_num in 1 2 3; do
				if [ -d ~/mentors/$domain_dev/$allocated_mentor/submittedTasks/task$task_num/$allocated_mentee ]; then
					rm -R ~/mentors/$domain_dev/$allocated_mentor/submittedTasks/task$task_num/$allocated_mentee
				fi
			done
			if [ -f mentorAllotted$domain_ ]; then
				sed -i "/^[^ ]* $mentee_name/d" ~/mentors/$domain_/$allocated_mentor/allocatedMentees.txt
			fi
		else
			domains_registered+=($domain_)
		fi
	done
	if [ $num_domains_registered -eq 0 ]; then
		rm -R ~/mentees/$mentee_name
		sed -i "/^$mentee_name/d" ~/menteeDetails.txt
		sed -i "/^[^ ]* $mentee_name/d" ~/mentees_domain.txt
	else
		case "$num_domains_registered" in
			1) pref_order="${pref1}";;
			2) pref_order="${pref1}->${pref2}";;
			3) pref_order="${pref1}->${pref2}->${pref3}";;
		esac
		awk '$2 == "$mentee_name" {$3 = "$pref_order"}1' ~/mentees_domain.txt
	fi
done

