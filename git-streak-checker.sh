#!/usr/bin/env bash

POSITIONAL_ARG="$1"

if [[ "$POSITIONAL_ARG" != "" ]]; then
	GIT_USER="$POSITIONAL_ARG"
else
	GIT_USER="ASHWIN990" #Default
fi

CURL_PARAM="https://github-readme-streak-stats.herokuapp.com?user=$GIT_USER"
GREP_PATTERN1="Current Streak Big Number"
GREP_PATTERN2="Total Contributions Big Number"
GREP_PATTERN3="total contributions range"
GREP_PATTERN4="Current Streak Range"
GREP_PATTERN_NOTAUSER="The username given is not a user."
GREP_PATTERN_NOUSERNAME="User could not be found."

CURR_DATE=$(date +"%b %e, %G")

CURL_OUT=$(curl -s "$CURL_PARAM")
CURL_EXIT_CODE=$?

GITHUB_STREAK=$(echo -e "$CURL_OUT" | grep "$GREP_PATTERN1" -A4 | tail -n1 | xargs)
GITHUB_CONTRI=$(echo -e "$CURL_OUT" | grep "$GREP_PATTERN2" -A4 | tail -n1 | xargs)
CONTRIB_RANGE=$(echo -e "$CURL_OUT" | grep "$GREP_PATTERN3" -A4 | tail -n1 | xargs | sed 's/Present//')
CUR_STREAK_RANGE=$(echo -e "$CURL_OUT" | grep "$GREP_PATTERN4" -A4 | tail -n1 | xargs)

if [[ "$GITHUB_STREAK" != "" ]]
	then
		echo -e "Github Streaks for \e[1;93m$GIT_USER \e[0m: \e[1;92m$GITHUB_STREAK \e[0mDays (\e[94m""$CUR_STREAK_RANGE""\e[0m)"
		echo -e "Total Contribution \e[1;93m$GIT_USER \e[0m: \e[1;92m$GITHUB_CONTRI \e[0mCommits (\e[94m""$CONTRIB_RANGE$CURR_DATE""\e[0m)"
	else
		GITHUB_NOTAUSER_CHECK=$(echo -e "$CURL_OUT" | grep "$GREP_PATTERN_NOTAUSER" | xargs)
		GITHUB_NOUSERNAME_CHECK=$(echo -e "$CURL_OUT" | grep "$GREP_PATTERN_NOUSERNAME" | xargs)
		if [[ "$GITHUB_NOTAUSER_CHECK" != "" ]]; then
			echo -e "Error occurred, \e[91mUsername Not A User\e[0m."
		elif [[ "$GITHUB_NOUSERNAME_CHECK" != "" ]]; then
			echo -e "Error occurred, \e[91mNo User Found\e[0m."
		elif [[ "$CURL_EXIT_CODE" == "6" ]]; then
			echo -e "Error occurred, \e[91mNo Network\e[0m."
		else
			echo -e "Error occurred, With error code \e[91m$CURL_EXIT_CODE\e[0m."
		fi
fi

