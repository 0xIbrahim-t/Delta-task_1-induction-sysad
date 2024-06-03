#!/bin/bash




if [ -f ~/domain_pref.txt ]; then
	tasks_completed=(n n n n n n n n n)
	mentee_dom=()
	for d in sysad web app; do
		if [ -d ~/$d ]; then
			mentee_dom+=($d)
		fi
	done
	v=0
	for dom in ${mentee_dom[@]}; do
		for n in 1 2 3; do
			PS3="Is the task-$n for $dom is done?(for yes-enter 1, for no-enter 2): "
			select task_completed in y n; do
				if [[ $task_completed == "y" ]]; then
					if [ -d ~/$dom/task$n ]; then
						tasks_completed[$v]=$task_completed
					else
						mkdir ~/$dom/task$n
						chown $USER:${USER}_group ~/$dom/task$n
						chmod -R 770 ~/$dom/task$n
						tasks_completed[$v]=$task_completed
					fi
				else
					if [ -d ~/$dom/task$n ]; then
						rm -R ~/$dom/task$n
					fi
				fi
				v=$(($v+1))
				echo $task_completed
				break
			done

		done
	done
	v=0
	if [ -s ~/task_submitted.txt ]; then
		rm -R ~/task_submitted.txt
	fi
	for doma in Sysad Web App; do
		echo "$doma:" >> ~/task_submitted.txt
		for nu in 1 2 3; do
			echo "    Task$nu: ${tasks_completed[$v]}" >> ~/task_submitted.txt
			v=$(($v+1))
		done
	done

elif [ -f ~/allocatedMentees.txt ]; then

	readarray -t allocated_mentees < <(awk '{print $2}' ~/allocatedMentees.txt)
	readarray -t domain_allocated_mentees < <(awk '{print $3}' ~/allocatedMentees.txt)
	if [ -s $(awk "NR==2 {print \$3}" ~/allocatedMentees.txt) ]; then
		line=2
	else
		line=1
	fi
	domain=$(awk "NR==$line {print \$3}" ~/allocatedMentees.txt)
	echo $domain
	for allocated_mentee in ${allocated_mentees[@]}; do
		echo $allocated_mentee
		echo $domain
		task_completed=(n n n)
		for h in 1 2 3; do

			c=$(($h - 1))

			if [ -d $(eval echo ~$allocated_mentee)/$domain/task$h ]; then

				ln -s -f $(eval echo ~$allocated_mentee)/$domain/task$h ~/submittedTasks/task$h/$allocated_mentee
				echo "successfully created a symlink for task$h with the $allocated_mentee's task$h"

				if [ -z "$(ls -A $(eval echo ~$allocated_mentee)/$domain/task$h)" ]; then
					task_completed[$c]=n
				else
					task_completed[$c]=y
				fi
			fi
		done

		if [ -s $(eval echo ~$allocated_mentee)/task_completed.txt ]; then
			readarray -t contents_task_completed < $(eval echo ~$allocated_mentee)/task_completed.txt
			x=0
			case $domain in
				"sysad") x=1;;
				"web") x=5;;
				"app") x=9;;
			esac
			rm -R $(eval echo ~$allocated_mentee)/task_completed.txt

			for line_task_completed in ${contents_task_completed[@]};do
				if [[ $line_task_completed==${content_task_completed[$x]} ]]; then
					echo "${line_task_completed:0:$((${#line_task_completed}-1))}${task_completed[0]}" >> $(eval echo ~$allocated_mentee)/task_completed.txt

				elif [[ $line_task_completed==${content_task_completed[$(($x+1))]} ]]; then
					echo "${line_task_completed:0:$((${#line_task_completed}-1))}${task_completed[1]}" >> $(eval echo ~$allocated_mentee)/task_completed.txt

				elif [[ $line_task_completed==${content_task_completed[$(($x+2))]} ]]; then
					echo "${line_task_completed:0:$((${#line_task_completed}-1))}${task_completed[2]}" >> $(eval echo ~$allocated_mentee)/task_completed.txt

				else
					echo $line_task_completed >> $(eval echo ~$allocated_mentee)/task_completed.txt

				fi
			done
		else
			v=0
			for g in SysAd Web App; do
				echo "$g:" >> $(eval echo ~$allocated_mentee)/task_completed.txt
				for k in Task1: Task2: Task3:; do
					v=$(($v+1))
					if [ ${g,,}==$domain ]; then
						r=${task_completed[v]}
					else
						r=n
					fi
					echo "    $k: $r" >> $(eval echo ~$allocated_mentee)/task_completed.txt
				done
			done
		fi
	done
else
	echo "you are neither a mentee nor a mentor, and hence cannot run this command"

fi
