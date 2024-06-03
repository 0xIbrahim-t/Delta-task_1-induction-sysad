#!/bin/bash



if ! [[ $USER==Core ]]; then
	echo "You are not the Core user and hence cannot use this command which is used to allocate mentors"
	exit 1
fi


readarray -t mentor_info_list < ~/mentorDetails.txt
readarray -t mentee_info_list < ~/mentees_domain.txt
mentor_list_web=()
mentor_list_app=()
mentor_list_sysad=()
mentor_list=()
for mentor_ in "${mentor_info_list[@]}"; do
	IFS=' '
	read -a mentor_info <<< "$mentor_"
	name="${mentor_info[0]}"
	domain="${mentor_info[1]}"
	capacity="${mentor_info[2]}"
	mentor_list+=($name)
	case $domain in
		"web") mentor_list_web+=($name);;
		"app") mentor_list_app+=($name);;
		"sysad") mentor_list_sysad+=($name);;
	esac
	capacity="${capacity//[$'\t\r\n ']}"
	mentor_capacity["$name"]=$capacity
done

mentee_list=()
for mentee_ in "${mentee_info_list[@]}"; do
	IFS=' '
	read -a mentee_info <<< "$mentee_"
	roll_number="${mentee_info[0]}"
	name="${mentee_info[1]}"
	domain="${mentee_info[2]}"
	mentee_roll_number["$name"]=$roll_number
	mentee_list+=($name)
	IFS='->'
	read -a xyz <<< "$domain"
	domain_pref["$name"]="${xyz[0]} ${xyz[2]} ${xyz[4]}"
done

IFS=$OLDIFS

for i in 0 1 2; do
	for mentee_name in ${mentee_list[@]}; do
		OLDIFS=$IFS
		IFS=' '
		read -a domainpref <<< "${domain_pref["$mentee_name"]}"
		IFS=$OLDIFS
		case ${domainpref[$i]} in
			"web")
				for mentor_name in ${mentor_list_web[@]}; do
					if [ $((${mentor_capacity["$mentor_name"]})) -gt 0 ] && [ ! -f $(eval echo ~$mentee_name)/mentorAllotted${domainpref[$i]} ]; then
						echo "${mentee_roll_number[$mentee_name]} $mentee_name web" >> "$(eval echo ~$mentor_name)/allocatedMentees.txt"
						mentor_capacity["$mentor_name"]=$((${mentor_capacity["$mentor_name"]} - 1))
						echo "$mentor_name has been allocated as a mentor for $mentee_name for the domain Webdev"
						touch $(eval echo ~$mentee_name)/mentorAllotted${domainpref[$i]}
						chmod 700 $(eval echo ~$mentee_name)/mentorAllotted${domainpref[$i]}
						break
					fi
				done
				;;
			"app")
				for mentor_name in ${mentor_list_app[@]}; do
					if [ $((${mentor_capacity["$mentor_name"]})) -gt 0 ]  && [ ! -f $(eval echo ~$mentee_name)/mentorAllotted${domainpref[$i]} ]; then
						echo "${mentee_roll_number[$mentee_name]} $mentee_name app" >> "$(eval echo ~$mentor_name)/allocatedMentees.txt"
						mentor_capacity["$mentor_name"]=$((${mentor_capacity["$mentor_name"]} - 1))
						echo "$mentor_name has been allocated as a mentor for $mentee_name for the domain Appdev"
						touch ~Core/mentees/$mentee_name/mentorAllotted${domainpref[$i]}
						chmod 700 $(eval echo ~$mentee_name)/mentorAllotted${domainpref[$i]}
						break
					fi
				done
				;;
			"sysad")
				for mentor_name in ${mentor_list_sysad[@]}; do
					if [ $((${mentor_capacity["$mentor_name"]})) -gt 0 ]  && [ ! -f $(eval echo ~$mentee_name)/mentorAllotted${domainpref[$i]} ]; then
						echo "${mentee_roll_number[$mentee_name]} $mentee_name sysad" >> "$(eval echo ~$mentor_name)/allocatedMentees.txt"
						mentor_capacity["$mentor_name"]=$((${mentor_capacity["$mentor_name"]} - 1))
						echo "$mentor_name has been allocated as a mentor for $mentee_name for the domain Sysad"
						touch $(eval echo ~$mentee_name)/mentorAllotted${domainpref[$i]}
						chmod 700 $(eval echo ~$mentee_name)/mentorAllotted${domainpref[$i]}
						break
					fi
				done
		esac
		if [ $i -eq 2 ] && [ -f ~Core/mentees/$mentee_name/mentorAllotted${domainpref[$i]} ]; then
			echo "cannot allocate a mentor for $mentee_name in the domain ${domainpref[$i]}"

		fi
	done
done

echo "Mentor allocation for mentees is done"
export EDITOR=vim
export VISUAL=vim
echo "00 00 * * * displayStatus" | crontab -u Core -
echo "10 10 * * 0,3,6 /script/check_deregistered.sh" | crontab -u Core -
echo "Cronjobs for displayStatus every day at 00:00 and for checking deregistered mentees at 10:10 on sunday, wednesday and saturday every week."
