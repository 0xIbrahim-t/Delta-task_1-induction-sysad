#!/bin/bash



if ! [ -f ~/domain_pref.txt ]; then
	echo "Only a mentee can run this command to answer their questions by their mentor"
	exit 1
fi

answers=()
question_number=1
readarray -t questions_to_answer < ~/questions.txt

for question_to_answer in "${questions_to_answer[@]}"; do
	echo $question_to_answer
	read -p "${question_to_answer}: " answer_to_the_question
	answers+=("question-${question_number}: $answer_to_the_question")
	question_number=$(($question_number + 1))
done
touch ~/quiz_answers
chown :${USER}_group ~/quiz_answers
chmod -R 770 ~/quiz_answers
for answer in ${answers[@]}; do
	echo "$answer" >> ~/quiz_answers
done

echo "Thanks for answering those questions :)"
