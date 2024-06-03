#!/bin/bash

create_user() {
	 username=$1
	 password=$2
	 sudo adduser --home "$3" "$username" --force-badname --disabled-password --gecos ""
	 sudo cp -r /etc/skel/. "$3"
	 echo "$username:$password" | sudo chpasswd
	 echo "User '$username' with has been created with the password '$password'"
}

create_user Core 1234567890 $(pwd)/core
chown Core ~Core
chown Core ~Core/.bash_history
chown Core ~Core/.bash_logout
chown Core ~Core/.bashrc
chown Core ~Core/.profile
chmod -R 700 ~Core
mkdir ~Core/mentors
mkdir ~Core/mentors/Webdev
mkdir ~Core/mentors/Appdev
mkdir ~Core/mentors/Sysad
mkdir ~Core/mentees
chown Core ~Core/mentors
chown Core ~Core/mentors/Webdev
chown Core ~Core/mentors/Appdev
chown Core ~Core/mentors/Sysad
chown Core ~Core/mentees
chmod 711 $(pwd)core/mentees
chmod 711 $(pwd)/core
chmod 711 $(pwd)
chmod 711 $(pwd)/core/mentors
chmod 711 $(pwd)/core/mentors/Sysad
chmod 711 $(pwd)/core/mentors/Appdev
chmod 711 $(pwd)/core/mentors/Webdev
touch ~Core/mentees_domain.txt
cp menteeDetails.txt ~Core
cp mentorDetails.txt ~Core
chown Core ~Core/menteeDetails.txt
chown Core ~Core/mentorDetails.txt

mentees=()
alias_script_files=(deRegister.sh displayStatus.sh domainPref.sh mentorAllocation.sh setQuiz.sh submitTask.sh userGen.sh answerQuiz.sh)
for alias_script_file in ${alias_script_files[@]}; do
	echo "alias ${alias_script_file:0:-3}='/scripts/$alias_script_file'" >> ~Core/.bashrc
done
groupadd core_mentee_group
usermod -aG core_mentee_group Core
while read line; do
	mentee=$(echo "$line" | awk '{print $1}')
	mentees+=($mentee)
	roll_number=$(echo "$line" | awk '{print $2}')
	create_user "$mentee" 123456789 ~Core/mentees/$mentee
	touch ~Core/mentees/$mentee/domain_pref.txt
	touch ~Core/mentees/$mentee/task_completed.txt
	touch ~Core/mentees/$mentee/task_submitted.txt
	touch ~Core/mentees/$mentee/rollnumber.txt
	groupadd ${mentee}_group
	usermod -aG core_mentee_group ${mentee}
	usermod -aG ${mentee}_group $mentee
	chown Core:core_mentee_group ~Core/mentees_domain.txt
	chown $mentee:${mentee}_group ~Core/mentees/$mentee/domain_pref.txt
	chown $mentee:${mentee}_group ~Core/mentees/$mentee/task_submitted.txt
	chown $mentee:${mentee}_group ~Core/mentees/$mentee/task_completed.txt
	chown $mentee:${mentee}_group ~Core/mentees/$mentee/rollnumber.txt
	chown $mentee:${mentee}_group $(eval echo ~$mentee)
	chmod -R 770 ~Core/mentees/$mentee/domain_pref.txt
	chmod -R 770 ~Core/mentees/$mentee/task_completed.txt
	chmod -R 770 ~Core/mentees/$mentee/task_submitted.txt
	chmod -R 770 ~Core/mentees/$mentee/rollnumber.txt
	chmod -R 770 $(eval echo ~$mentee)
	chmod -R 720 ~Core/mentees_domain.txt
	echo "$roll_number" >> ~Core/mentees/$mentee/rollnumber.txt
	for alias_script_file in ${alias_script_files[@]}; do
		echo "alias ${alias_script_file:0:-3}='/scripts/$alias_script_file'" >> $(eval echo ~$mentee)/.bashrc
	done
	source ~Core/mentees/$mentee/.bashrc
done < ~Core/menteeDetails.txt

while read line; do
	mentor=$(echo "$line" | awk '{print $1}')
	dom=$(echo "$line" | awk '{print $2}')
	case "$dom" in

		"web") domain="Webdev";;
		"app") domain="Appdev";;
		"sysad") domain="Sysad";;
	esac
	create_user "$mentor" "123456789"  ~Core/mentors/$domain/$mentor
	touch ~Core/mentors/$domain/$mentor/allocatedMentees.txt
	mkdir ~Core/mentors/$domain/$mentor/submittedTasks
	mkdir ~Core/mentors/$domain/$mentor/submittedTasks/task1
	mkdir ~Core/mentors/$domain/$mentor/submittedTasks/task2
	mkdir ~Core/mentors/$domain/$mentor/submittedTasks/task3
	groupadd ${mentor}_group
	usermod -aG ${mentor}_group $mentor
	usermod -aG ${mentor}_group Core
	chown $mentor:${mentor}_group ~Core/mentors/$domain/$mentor
	chown $mentor:${mentor}_group ~Core/mentors/$domain/$mentor
	chown $mentor:${mentor}_group ~Core/mentors/$domain/$mentor/allocatedMentees.txt
	chown $mentor:${mentor}_group ~Core/mentors/$domain/$mentor/submittedTasks/task1
	chown $mentor:${mentor}_group ~Core/mentors/$domain/$mentor/submittedTasks/task2
	chown $mentor:${mentor}_group ~Core/mentors/$domain/$mentor/submittedTasks/task3
	chmod -R 770 ~Core/mentors/$domain/$mentor
	chmod -R 770 ~Core/mentors/$domain/$mentor/allocatedMentees.txt
	chmod -R 770 ~Core/mentors/$domain/$mentor/submittedTasks/task1
	chmod -R 770 ~Core/mentors/$domain/$mentor/submittedTasks/task2
	chmod -R 770 ~Core/mentors/$domain/$mentor/submittedTasks/task3
	for i in ${mentees[@]}; do
		usermod -aG ${i}_group $mentor
		usermod -aG ${i}_group Core
	done
	for alias_script_file in ${alias_script_files[@]}; do
		echo "alias ${alias_script_file:0:-3}='/scripts/$alias_script_file'" >> $(eval echo ~$mentor)/.bashrc
	done
	source $(eval echo ~$mentor)/.bashrc
done < ~Core/mentorDetails.txt
