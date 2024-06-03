#!/bin/bash



if [ -f ~/domain_pref.txt]; then
	PS3="Select the domain you want to deregister from your induction process: "
	readarray -t domains_registered < ~/domain_pref.txt
	select domain_to_deregister in ${domains_registered[@]}; do
		rm -R ~/domain_to_deregister
		rm ~/domain_pref.txt
		touch ~/domain_pref.txt
		for domain_registered in ${domains_registered[@]}; do
			if ["$domain_registered"=="$domain_to_deregister"]; then
				continue
			fi
			echo "domain_registered" >> ~/domain_pref.txt
		done
	done
else
	echo "You should be an mentee to run this command to deregister from this induction process."
fi
