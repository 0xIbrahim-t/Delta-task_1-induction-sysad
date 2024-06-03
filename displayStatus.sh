#!/bin/bash




if [[ $USER=="Core" ]]; then
	if ! [ -d ~/display_status ]; then
		mkdir ~/display_status
		touch ~/display_status/sysad_task1_info.txt
		touch ~/display_status/sysad_task2_info.txt
		touch ~/display_status/sysad_task3_info.txt
		touch ~/display_status/web_task1_info.txt
		touch ~/display_status/web_task2_info.txt
		touch ~/display_status/web_task3_info.txt
		touch ~/display_status/app_task1_info.txt
		touch ~/display_status/app_task2_info.txt
		touch ~/display_status/app_task3_info.txt
		chmod -R 700 ~/display_status/sysad_task1_info.txt
		chmod -R 700 ~/display_status/sysad_task2_info.txt
		chmod -R 700 ~/display_status/sysad_task3_info.txt
		chmod -R 700 ~/display_status/web_task1_info.txt
		chmod -R 700 ~/display_status/web_task2_info.txt
		chmod -R 700 ~/display_status/web_task3_info.txt
		chmod -R 700 ~/display_status/app_task1_info.txt
		chmod -R 700 ~/display_status/app_task2_info.txt
		chmod -R 700 ~/display_status/app_task3_info.txt
		chmod -R 700 ~/display_status
	fi

	readarray -t mentees_dir < <(ls ~/mentees)
	for arg in $@; do
		completed_tasks=(0 0 0)
		total_tasks=0
		if [ $arg == "sysad" ]; then
			echo "Sysad Tasks information:"
		elif [ $arg == "web" ]; then
			echo "Webdev Tasks information:"
		elif [ $arg == "app" ]; then
			echo "Appdev Tasks information:"
		else
			echo "cant find $arg domain, you can only use sysad, web and app as arguments of the command line, example:"
			echo "> displayStatus sysad app"
			echo "this will print the info of sysad and app domain tasks."
			exit 1

		fi
		for i in 1 2 3; do
			j=$(($i - 1))
			echo "    task-$i:"
			completed_tasks[$j]=0
			total_tasks=0
			task_completed_mentees=()
			for mentee_n in ${mentees_dir[@]}; do
				if [ -d ~/mentees/$mentee_n/$arg ]; then
					total_tasks=$(($total_tasks + 1))
					if [ -d ~/mentees/$mentee_n/${arg}/task$i ]; then
						if ! [ -z "$(ls -A ~/mentees/$mentee_n/${arg}/task$i)" ]; then
							completed_tasks[$j]=$((completed_tasks[$j] + 1))
							task_completed_mentees+=($mentee_n)
						fi
					fi
				fi
			done
			echo "        the total percentage of people who submitted task$i ; $((${completed_tasks[$j]} * 100 / $total_tasks))"
			echo "        list of mentees who submitted the task-$i since the last time this command has been used:"

			readarray -t old_completed_mentees < ~/display_status/${arg}_task${i}_info.txt
			for task_completed_mentee in ${task_completed_mentees[@]}; do
				is_there="no"
				for old_completed_mentee in ${old_completed_mentees[@]}; do
					if [[ "$task_completed_mentee" == "$old_completed_mentee" ]]; then
						is_there="yes"
					fi
				done
				if [[ $is_there == "no" ]]; then
					echo "            $task_completed_mentee"
					echo "$task_completed_mentee" >> ~/display_status/${arg}_task${i}_info.txt
				fi
			done
		done
	done	

else
	echo "Only the core user can use this command."
fi
