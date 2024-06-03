#!/bin/bash

if [ -d ~/submittedTasks]; then
	PS3="Choose an option below: "
	question_number=1
	option_1='do you set a question to your mentee/mentees?'
	questions=()
	select option in option_1 'exit' 'exit without setting the quiz'; do
		case $option in
			$option_1)
				read -p "Enter the question number $question_number: " question
				questions+=$question
				;;
				
			'exit')
				for allocated_mentee_info in ${allocated_mentees[@]}; do
					if [$allocated_mentee_info == "rollnumber name domain"]; then
						continue
					fi
					read -a allocated_mentee_info_array <<< "$allocated_mentee_info"
					allocated_mentees+=("${allocated_mentee_info_array[1]}")
				done
				for allocated_mentee in ${allocated_mentees[@]}; do
					if [ -f $(eval echo ~$allocated_mentee)/questions.txt]; then
						rm $(eval echo ~$allocated_mentee)/questions.txt
					fi
					touch $(eval echo ~$allocated_mentee)/questions.txt
					chown :${sllocated_mentee}_group $(eval echo ~$allocated_mentee)/questions.txt
					chmod -R 770 $(eval echo ~$allocated_mentee)/questions.txt
					for qn in ${questions[@]}; do
						echo "${qn}" >> $(eval echo ~$allocated_mentee)/questions.txt
					done
					echo "We have set some question as a part of the induction process, please answer those questions by running the command answerQuiz" > $(eval echo ~$allocated_mentee)/notification.txt
					echo "/script/notification.sh" >> $(eval echo ~$allocated_mentee)/.bashrc
					echo "/script/delete_noti.sh" >> $(eval echo ~$allocated_mentee)/.bashrc
					echo "The quiz has been successfully set for this $allocated_mentee and the notification has been sent."
				done
				break
				;;

			'exit without setting the quiz')
				exit 0
				break
				;;
	done
else
	echo "Only a mentor can run this alias to set questions for their mentees."
fi
