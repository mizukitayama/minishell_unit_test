#!/bin/bash

# path to minishell
path_to_executable=".."
# path to csv file
test_cases_file="test_cases.csv"

output_bash="output_bash.txt"
output_minishell="output_minishell.txt"
failed_tests=""

RESET="\033[0m"
RED="\033[31m"
GREEN="\033[32m"

make -C ${path_to_executable}

while IFS=, read -r command
do
    # execute bash
    bash -c "$command" 2>/dev/null > "$output_bash"

    # execute minishell
    echo "$command" | $path_to_executable/minishell 2>/dev/null > "$output_minishell"

    # diff
    if diff "$output_bash" "$output_minishell" > /dev/null; then
        echo -en "${GREEN}.${RESET}"
    else
        echo -en "${RED}.${RESET}"
        failed_tests+="Failed command: $command\n"
        failed_tests+="bash output:\n$(cat "$output_bash")\n"
        failed_tests+="minishell output:\n$(cat "$output_minishell")\n"
        failed_tests+="--------------------------------\n"
    fi
done < "$test_cases_file"

# display details of failed test cases if any
if [ -n "$failed_tests" ]; then
    echo -e "\nDetails of failed test cases:\n$failed_tests"
else
    echo -e "\n🎉 All tests passed successfully 🎉"
fi

rm "$output_bash" "$output_minishell"
