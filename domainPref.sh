#!/bin/bash





if ! [ -f ~/domain_pref.txt ]; then
	echo "You are not a mentee and hence cannot use this command to set a domain preference"
	exit 1
fi

pref="first"
x=0
PS3="what is $pref preference"
select domain in sysad web app "exit"; do
	if [[ $domain == "exit" ]]; then
		break
	else
		pref1="$domain"
		pref="second"
		x=1
		PS3="what is $pref preference"
		select domain in sysad web app "exit"; do
			if [[ $domain == "exit" ]]; then
				break
			else
				pref2="$domain"
				pref="third"
				x=2
				PS3="what is $pref preference"
				select domain in sysad web app "exit"; do
					if [[ $domain == "exit" ]]; then
						break
					else
						pref3="$domain"
						x=3
					fi
					break
				done
			fi
			break
		done
	fi
	break
done
readarray -t rollnumber_of_mentee < ~/rollnumber.txt
mentee_rollnumber=${rollnumber_of_mentee}
case "$x" in 
	0) exit 1;;
	1) 
		content="$mentee_rollnumber $USER ${pref1}"
		if [ -f ~/domain_pref.txt ]; then
			if [ -s ~/domain_pref.txt ]; then
				echo "You have already setted the domain preference"
			else
				echo "$content" >> ~Core/mentees_domain.txt
				echo "$pref1" >> ~/domain_pref.txt
				mkdir ~/$pref1
				chown $USER:${USER}_group ~/$pref1 
				chmod -R 770 ~/$pref1
				echo "your domain preference has been set"
			fi
		fi
		;;
	2)
		content="$mentee_rollnumber $USER ${pref1}->${pref2}"
		if [ -f ~/domain_pref.txt ]; then
			if [ -s ~/domain_pref.txt ]; then
				echo "You have already setted the domain preference"
			else
				echo "$content" >> ~Core/mentees_domain.txt
				echo "$pref1" >> ~/domain_pref.txt
				echo "$pref2" >> ~/domain_pref.txt
				mkdir ~/$pref1
				mkdir ~/$pref2
				chown $USER:${USER}_group ~/$pref1
				chmod -R 770 ~/$pref1
				chown $USER:${USER}_group ~/$pref2
				chmod -R 770 ~/$pref2
				echo "your domain preference has been set"
			fi
		fi
		;;
	3)
		content="$mentee_rollnumber $USER ${pref1}->${pref2}->${pref3}"
		if [ -f ~/domain_pref.txt ]; then
			if [ -s ~/domain_pref.txt ]; then
				echo "You have already setted the domain preference"
			else
				echo "$content" >> ~Core/mentees_domain.txt
				echo "$pref1" >> ~/domain_pref.txt
				echo "$pref2" >> ~/domain_pref.txt
				echo "$pref3" >> ~/domain_pref.txt
				mkdir ~/$pref1
				mkdir ~/$pref2
				mkdir ~/$pref3
				chown $USER:${USER}_group ~/$pref1
				chmod -R 770 ~/$pref1
				chown $USER:${USER}_group ~/$pref2
				chmod -R 770 ~/$pref2
				chown $USER:${USER}_group ~/$pref3
				chmod -R 770 ~/$pref3
				echo "your domain preference has been set"
			fi
		fi
		;;
esac
